Class {
	#name : #GitlabModelImporter,
	#superclass : #GitModelImporter,
	#instVars : [
		'withInitialCommits',
		'withInitialMergeRequest'
	],
	#category : #'GitLabHealth-Model-Importer'
}

{ #category : #private }
GitlabModelImporter >> addCommits: commitsList toRepository: aProjectRepository [
	"I take a list of GLHCommit. But some might have been parsed but are already on the model..."

	"I return the list of added commits"

	| existingCommits newlyFoundCommit |
	existingCommits := aProjectRepository mooseModel allWithType:
		                   GLHCommit.
	newlyFoundCommit := commitsList reject: [ :commitParsed |
		                    existingCommits anySatisfy: [ :existingCommit |
			                    existingCommit id = commitParsed id ] ].
	aProjectRepository mooseModel addAll: newlyFoundCommit.
	aProjectRepository commits addAll: newlyFoundCommit.
	^ newlyFoundCommit
]

{ #category : #private }
GitlabModelImporter >> addGroupResultToModel: groupResult [
	|group|
	group := self glhModel add: groupResult unless: self blockOnIdEquality.
	self glhModel
		addAll: group projects
		unless: self blockOnIdEquality.
	^ group 
]

{ #category : #'import - pipelines' }
GitlabModelImporter >> allPipelinesOf: aProjectID [

	| result |
	('Search pipelines of: ' , aProjectID printString) recordInfo.
	result := self repoApi pipelines getAllInProject: aProjectID.
	result isString ifTrue: [ ^ self parsePipelinesResult: result ].

	^ (result collect: [ :pipelinesJson |
			   self parsePipelinesResult: pipelinesJson ]) flattened
]

{ #category : #'import - commits' }
GitlabModelImporter >> commitsOfProject: aGLHProject forRefName: refName until: toDate [

	| params results allCommits |
	
	params := { 
		#ref_name -> refName.
		#until -> (toDate ifNotNil: [ toDate asDateAndTime asString ] ifNil: [ '' ]) 
	} asDictionary.
	results := self repoApi commits getAllInProject: aGLHProject id withParams: params.
	allCommits := (results collect: [ :commitsJson | self parseCommitsResult: commitsJson ]) flattened.
	
	self glhModel addAll: allCommits unless: self blockOnIdEquality.
	aGLHProject repository commits addAll: allCommits unless: self blockOnIdEquality.

	self withCommitDiffs ifTrue: [
		aGLHProject repository commits do: [ :commit |
			self importDiffOfCommit: commit ] ].
	
	^allCommits
]

{ #category : #'import - projects' }
GitlabModelImporter >> completeImportProject: aGLHProject [

	| importedProject |
	('Complete import of project: ' , aGLHProject id printString)
		recordInfo.
	aGLHProject repository ifNotNil: [ ^ aGLHProject ].

	importedProject := self glhModel
		                   add: aGLHProject
		                   unless: self blockOnIdEquality.

	self importLatestPipelinesOfProject: importedProject.

	"aGLHProject creator: (self importUser: aGLHProject creator_id)."

	(self importUser: importedProject creator_id) addCreatedProject:
		importedProject.


	importedProject repository: GLHRepository new.
	self glhModel add: importedProject repository.
	self completeImportsOfRepository: importedProject repository.


	withInitialMergeRequest ifTrue: [
		self
			importMergeRequestsOfProject: importedProject
			since: DateAndTime today
			until: DateAndTime now ].

	^ importedProject
	

]

{ #category : #'import - commits' }
GitlabModelImporter >> completeImportedCommit: aCommit [

	('completing commit: ' , aCommit short_id printString) recordInfo.
	self importCreatorOfCommit: aCommit.

	self withCommitDiffs ifTrue: [
		| diffs |
		aCommit diffs ifEmpty: [
			diffs := self importDiffOfCommit: aCommit.
			self glhModel addAll: diffs unless: self blockForDiffEquality ] ].

	^ aCommit
]

{ #category : #'import - jobs' }
GitlabModelImporter >> completeImportedJob: aGLHJob [
	
	aGLHJob commit ifNil: [ 
		|commit|
		commit := self
		          importCommit:
		          (aGLHJob cacheAt: #commitID ifAbsent: [ '' ])
		          ofProject: aGLHJob pipeline project.
		aGLHJob commit: commit. ].
	
	aGLHJob user ifNil: [ 
		|user|
		user := self importUser: (aGLHJob cacheAt: #userID ifAbsent: [ '' ]).
	aGLHJob user: user.
		 ]. 
	
	
	^ aGLHJob
]

{ #category : #'import - pipelines' }
GitlabModelImporter >> completeImportedPipeline: aGLHPipeline [ 
	|result parsedResult|
	
	aGLHPipeline duration ifNotNil: [ ^ aGLHPipeline ].
	
	result := self repoApi pipelines get: aGLHPipeline id inProject: aGLHPipeline project id. 
	parsedResult := self parsePipelineResult: result. 
	
	"aGLHPipeline methods".
	{ #'created_at:' . #'status:' . #'finished_at:' . #'duration:' . #'started_at:' . #'updated_at:' . #'ref:' } do: [ :m |
		aGLHPipeline perform: m asSymbol with: (parsedResult perform: (m withoutSuffix: ':') asSymbol )
		 ].
	
	parsedResult cacheAt: #userID ifPresent: [:id |
		aGLHPipeline user: (self importUser: id). 
		].
	
	^ aGLHPipeline. 
]

{ #category : #'import - pipelines' }
GitlabModelImporter >> completeImportedPipelines: aCollectionOfGLHPipeline [
	^ aCollectionOfGLHPipeline collect: [ :pipeline | self completeImportedPipeline: pipeline ].  
]

{ #category : #'import - projects' }
GitlabModelImporter >> completeImportedProject: aGLHProject [

	| importedProject |
	('Complete import of project: ' , aGLHProject id printString)
		recordInfo.
	aGLHProject repository ifNotNil: [ ^ aGLHProject ].

	importedProject := self glhModel
		                   add: aGLHProject
		                   unless: self blockOnIdEquality.

	self importLatestPipelinesOfProject: importedProject.

	"aGLHProject creator: (self importUser: aGLHProject creator_id)."

	(self importUser: importedProject creator_id) addCreatedProject:
		importedProject.

	
	importedProject repository: GLHRepository new.
	self glhModel add: importedProject repository.
	self completeImportsOfRepository: importedProject repository.
	

	withInitialMergeRequest ifTrue: [
		self
			importMergeRequestsOfProject: importedProject
			since: DateAndTime today
			until: DateAndTime now ].

	^ importedProject
	

]

{ #category : #'import - repositories' }
GitlabModelImporter >> completeImportsOfRepository: aGLHRepository [

	| branches |
	[
	('import the repository of project ' , aGLHRepository project name)
		recordInfo.
	branches := self importBranchesOf: aGLHRepository project.
	self withFiles ifTrue: [
		branches do: [ :branch | self importFilesOfBranch: branch ] ] ]
		on: NeoJSONParseError
		do: [
		self inform: aGLHRepository project name , ' has no repository' ].

	withInitialCommits ifTrue: [
		aGLHRepository branches do: [ :branch |
			self importCommitsOfBranch: branch ] ].
	
	^ aGLHRepository 
]

{ #category : #'private - configure reader' }
GitlabModelImporter >> configureReaderForBranch: reader [

	super configureReaderForBranch: reader.
	
		reader for: GLHBranch do: [ :mapping |
		mapping
			mapProperty: #commit
			getter: [  ]
			setter: [ :branch :rawCommit | branch sha: (rawCommit at: #id) ] ].
]

{ #category : #'private - configure reader' }
GitlabModelImporter >> configureReaderForCommit: reader [

	super configureReaderForCommit: reader.

	reader for: GLHCommit do: [ :mapping |

		(mapping mapInstVar: #authored_date) valueSchema: DateAndTime.
		(mapping mapInstVar: #committed_date) valueSchema: DateAndTime.
		(mapping mapInstVar: #created_at) valueSchema: DateAndTime.
		(mapping mapInstVar: #parent_ids) valueSchema: #ArrayOfIds.
		mapping
			mapProperty: 'stats'
			getter: [ :el | "Not used" ]
			setter: [ :commit :value |
				commit deletions: (value at: #deletions).
				commit additions: (value at: #additions) ] ].

	reader
		for: #ArrayOfIds
		customDo: [ :mapping | mapping decoder: [ :string | string ] ]
]

{ #category : #'private - configure reader' }
GitlabModelImporter >> configureReaderForDiff: reader [

	super configureReaderForDiff: reader.
	reader
		for: GLHDiff
		do: [ :mapping | 
			"mapping mapInstVars:
			#( deleted_file new_file new_path old_path renamed_file )."
			mapping mapInstVar: #diffString to: #diff ].

	^ reader
]

{ #category : #'private - configure reader' }
GitlabModelImporter >> configureReaderForGroup: reader [

	super configureReaderForGroup: reader.

	reader for: GLHGroup do: [ :mapping |
		(mapping mapInstVar: #projects) valueSchema: #ArrayOfProject ]
]

{ #category : #'private - configure reader' }
GitlabModelImporter >> configureReaderForJob: reader [

	super configureReaderForJob: reader.

	reader
		for: GLHJob
		do: [ :mapping | "(mapping mapInstVar: #user) valueSchema: GLHUser.
		(mapping mapInstVar: #pipeline) valueSchema: GLHPipeline."
			mapping
				mapProperty: #user
				getter: [  ]
				setter: [ :job :rawUser |
				job cacheAt: #userID put: (rawUser at: #id) ].

			mapping
				mapProperty: #pipeline
				getter: [  ]
				setter: [ :job :rawPipeline |
					job cacheAt: #pipelineID put: (rawPipeline at: #id) ].
				
			mapping
				mapProperty: #commit
				getter: [  ]
				setter: [ :job :rawCommit |
					job cacheAt: #commitID put: (rawCommit at: #id) ].

			"mapping
			mapProperty: #user
			getter: [ :object | #ignore ]
			setter: [ :object :value |
			object user: (self importUser: (value at: #id)) ]."

			mapping
				mapProperty: #duration
				getter: [ :object | #ignore ]
				setter: [ :object :value |
				value ifNotNil: [ object duration: value seconds ] ] ]
]

{ #category : #'private - configure reader' }
GitlabModelImporter >> configureReaderForMergeRequest: reader [
	"declare quil y a un array a mapper"
	self flag: 'assignee.s must be parsed with nil condition'.
	super configureReaderForMergeRequest: reader.

	"declare la liste des properties"
	reader
		for: GLHMergeRequest
		do: [ :mapping | 
			 
			"(mapping mapInstVar: #assignee) valueSchema: GLHUser."
			"(mapping mapInstVar: #assignees) valueSchema: #ArrayOfUser."
			(mapping mapInstVar: #created_at) valueSchema: DateAndTime.
			(mapping mapInstVar: #updated_at) valueSchema: DateAndTime.
			(mapping mapInstVar: #merged_at) valueSchema: DateAndTime.
			(mapping mapInstVar: #closed_at) valueSchema: DateAndTime.

			mapping
				mapProperty: #author
				getter: [  ]
				setter: [ :object :value |
				object cacheAt: #authorID put: (value at: #id) ].
			mapping
				mapProperty: #merge_user
				getter: [  ]
				setter: [ :object :value |
					value ifNotNil: [
						object cacheAt: #mergeUserID put: (value at: #id) ] ] ]
]

{ #category : #'private - parsing' }
GitlabModelImporter >> configureReaderForNote: reader [

	super configureReaderForNote: reader.

	reader for: GLHNote do: [ :mapping |
		(mapping mapInstVar: #created_at) valueSchema: DateAndTime.
		(mapping mapInstVar: #updated_at) valueSchema: DateAndTime.

		(mapping mapInstVar: #position) valueSchema: GLHNotePosition ]
]

{ #category : #'private - configure reader' }
GitlabModelImporter >> configureReaderForNotePosition: reader [

	super configureReaderForNotePosition: reader.

	reader for: GLHNotePosition do: [ :mapping |
		mapping mapInstVar: #file_path to: #new_path.
		mapping mapInstVar: #original_file_path to: #old_path.

		mapping
			mapProperty: #new_line
			getter: [  ]
			setter: [ :notePosition :newLine |
				notePosition start_line: newLine.
				notePosition start_line_type: 'new' ].

		mapping
			mapProperty: #old_line
			getter: [  ]
			setter: [ :notePosition :oldLine |
				notePosition start_line: oldLine.
				notePosition start_line_type: 'old' ].

		mapping
			mapProperty: #line_range
			getter: [  ]
			setter: [ :notePosition :rawLineRange |
				rawLineRange
					ifNil: [ notePosition end_line = notePosition start_line ]
					ifNotNil: [
						| start startType startLine end endType endLine |
						start := rawLineRange at: #start.
						startType := start at: #type.
						startLine := (start at: #type) = 'new'
							             ifTrue: [ start at: #new_line ]
							             ifFalse: [ start at: #old_line ].
						notePosition start_line_type: (start at: #type).
						notePosition start_line: startLine.


						end := rawLineRange at: #end.
						endType := end at: #type.
						endLine := (end at: #type) = 'new'
							           ifTrue: [ end at: #new_line ]
							           ifFalse: [ end at: #old_line ].
						notePosition end_line_type: (end at: #type).
						notePosition end_line: endLine ] ] ]
]

{ #category : #'private - configure reader' }
GitlabModelImporter >> configureReaderForPipeline: reader [

	super configureReaderForPipeline: reader.

	reader for: GLHPipeline do: [ :mapping |
		mapping
			mapProperty: #created_at
			getter: [ :object | #ignore ]
			setter: [ :object :value |
				object created_at:
					(value ifNotNil: [ DateAndTime fromString: value ]).
				object runDate:
					(value ifNotNil: [ DateAndTime fromString: value ]) ].

		mapping
			mapProperty: #updated_at
			getter: [ :object | #ignore ]
			setter: [ :object :value |
				object updated_at:
					(value ifNotNil: [ DateAndTime fromString: value ]) ].

		mapping
			mapProperty: #finished_at
			getter: [ :object | #ignore ]
			setter: [ :object :value |
				object finished_at:
					(value ifNotNil: [ DateAndTime fromString: value ]) ].

		mapping
			mapProperty: #started_at
			getter: [ :object | #ignore ]
			setter: [ :object :value |
				object started_at:
					(value ifNotNil: [ DateAndTime fromString: value ]) ].

		mapping
			mapProperty: #source
			getter: [ :object | #ignore ]
			setter: [ :object :value | object sourceEvent: value ].

		mapping
			mapProperty: #duration
			getter: [ :object | #ignore ]
			setter: [ :object :value |
				object duration: (value ifNotNil: [ value asDuration ]) ].

		mapping
			mapProperty: #user
			getter: [ :object | #ignore ]
			setter: [ :object :value |
				value ifNotNil: [ object cacheAt: #userID put: (value at: #id) ] ] ].

]

{ #category : #'private - configure reader' }
GitlabModelImporter >> configureReaderForProject: reader [

	super configureReaderForProject: reader.
	
	reader for: GLHProject do: [ :mapping |
		mapping mapInstVar: #web_url to: #html_url.
		].
]

{ #category : #'private - configure reader' }
GitlabModelImporter >> configureReaderForRelease: reader [

	super configureReaderForRelease: reader.


	reader
		for: GLHRelease
		do: [ :mapping | (mapping mapInstVar: #author) valueSchema: GLHUser ].

]

{ #category : #'private - configure reader' }
GitlabModelImporter >> configureReaderForTag: reader [

	reader mapInstVarsFor: GLHTag .
	
	reader for: GLHTag do: [ :mapping |
		
		(mapping mapInstVar: #commit) valueSchema: GLHCommit .
"		(mapping mapInstVar: #release) valueSchema: GLHRelease ."
		(mapping mapInstVar: #created_at) valueSchema: DateAndTime .
		
		mapping
			mapProperty: #release
			getter: [ :object | #ignore ]
			setter: [ :object :value |
			object release: (value ifNotNil: [ GLHRelease new description: (value at:#description); tag_name: (value at: #tag_name); yourself ]).
			].
		 ].
	
	reader
		for: #ArrayOfTags
		customDo: [ :customMappting |
		customMappting listOfElementSchema: GLHTag ].
]

{ #category : #'private - configure reader' }
GitlabModelImporter >> configureReaderForUser: reader [

	super configureReaderForUser: reader
	
]

{ #category : #private }
GitlabModelImporter >> convertApiFileAsFile: aAPIFile [

	aAPIFile type = 'tree' ifTrue: [ 
		^ GLHFileDirectory new
			  name: aAPIFile name;
			  yourself ].
	^ GLHFileBlob new
		  name: aAPIFile name;
		  yourself
]

{ #category : #private }
GitlabModelImporter >> detectEntityType: aType overAttribut: aSelector equalTo: value [

	^ (self glhModel allWithType: aType) detect: [ :entity |
		  (entity perform: aSelector) = value ] ifNone: [ nil ]. 
]

{ #category : #'import - notes' }
GitlabModelImporter >> getSuggestionsFromNote: glhNote [

	| suggestions suggestion fromLine toLine suggestionsInfo |
	glhNote position ifNil: [ ^ {  } ].
	suggestions := MooseGroup new.

	suggestionsInfo := self getSuggestionsInfoFromString: glhNote body.

	^ suggestionsInfo collect: [ :suggestionInfo |
		  suggestion := GLHNoteSuggestion new.
		  fromLine := glhNote position end_line - (suggestionInfo at: #minus).
		  toLine := glhNote position end_line + (suggestionInfo at: #plus).
		  suggestion from_line: fromLine.
		  suggestion to_line: toLine.
		  suggestion to_content: (suggestionInfo at: #content) ].

]

{ #category : #'import - notes' }
GitlabModelImporter >> getSuggestionsInfoFromString: string [

	| suggestionsInfo regex result regex2 suggestionInfo |
	suggestionsInfo := OrderedCollection new.

	regex := '```suggestion' asRegex.
	result := regex matchesIn: string.

	result isEmpty ifTrue: [ ^ suggestionsInfo ].
	result size > 1 ifTrue: [
		| start end firstPart secondPart |
		start := string findString: '```suggestion'.
		end := (string findString: '```' startingAt: start +2) + 2.

		firstPart := string copyFrom: 1 to: end.
		secondPart := string copyFrom: end to: string size.

		suggestionsInfo addAll:
			(self getSuggestionsInfoFromString: firstPart).
		suggestionsInfo addAll:
			(self getSuggestionsInfoFromString: secondPart).
		^ suggestionsInfo ].

	regex2 := '```suggestion\:-(\d+)\+(\d+)(.*)```' asRegex.
	regex2 search: string.

	suggestionInfo := {
		                  (#minus -> (regex2 subexpression: 2) asNumber).
		                  (#plus -> (regex2 subexpression: 3) asNumber).
		                  (#content -> (regex2 subexpression: 4)) }
		                  asDictionary.

	^ { suggestionInfo }
]

{ #category : #accessing }
GitlabModelImporter >> glhApi [

	self
		deprecated: 'Use #repoApi instead'
		on: '7 October 2024'
		in:
		'Pharo-11.0.0+build.726.sha.aece1b5473acf3830a0e082c1bc3a15d4ff3522b (64 Bit)'.

	^ repoApi
]

{ #category : #accessing }
GitlabModelImporter >> glhApi: anObject [

	self
		deprecated: 'Use #repoApi: instead'
		on: '7 October 2024'
		in:
		'Pharo-11.0.0+build.726.sha.aece1b5473acf3830a0e082c1bc3a15d4ff3522b (64 Bit)'.

	repoApi := anObject
]

{ #category : #accessing }
GitlabModelImporter >> glhModel [

	^ glhModel
]

{ #category : #accessing }
GitlabModelImporter >> glhModel: anObject [

	glhModel := anObject
]

{ #category : #'import - users' }
GitlabModelImporter >> importActiveHumanUsers [

	| params result users |
	params := { 
		#humans -> 'true'.
		#active -> 'true'.
		#without_project_bots -> 'true'
	} asDictionary.
	result := self repoApi users allWithParams: params.
	users := (result collect: [ :usersJson | self parseUsersResult: usersJson ]) flattened.
	
	self glhModel
				 addAll: users
				 unless: self blockOnIdEquality.

	^ users
]

{ #category : #'import - groups' }
GitlabModelImporter >> importAllGroups [

	| params results groups |
	
	params := { 
			#top_level_only -> 'true'
	} asDictionary.
	results := self repoApi groups getAllWithParams: params.
	
	groups := (results collect: [ :groupsJson | generalReader
			                    on: groupsJson readStream;
			                    nextAs: #ArrayOfGroups. ]) flattened.
	^ groups
]

{ #category : #'import - pipelines' }
GitlabModelImporter >> importAllPipelinesOfProject: aGLHProject [
	
	(self allPipelinesOf: aGLHProject id) do: [ :pipeline |
		| pip |
		pip := self glhModel add: pipeline unless: self blockOnIdEquality.
		pip := aGLHProject pipelines add: pip unless: self blockOnIdEquality.
		self completeImportedPipeline: pip ].

	^ aGLHProject pipelines
]

{ #category : #'import - commits' }
GitlabModelImporter >> importAndLoadLatestsCommitsOfProject: aGLHProject [

	| commits completedProject |
	completedProject := self completeImportedProject: aGLHProject.
	commits := self importLatestCommitsOfProject: completedProject.
	commits do: [ :commit | self completeImportedCommit: commit ].
	self chainsCommitsFrom: commits.
	^ commits
]

{ #category : #'import - users' }
GitlabModelImporter >> importAuthorOfCommit: aGLHCommit [

	| user |
		self
		deprecated: 'Use importCreatorOfCommit: instead of current one'
		on: '19 September 2025'
		in:
		'Pharo-12.0.0+SNAPSHOT.build.1571.sha.cf5fcd22e66957962c97dffc58b0393b7f368147 (64 Bit)'.

	
	user := self importUserByUsername: aGLHCommit author_name.
	aGLHCommit commitCreator: user.
	^ user
]

{ #category : #'import - branches' }
GitlabModelImporter >> importBranchesOf: aGLHProject [

	| resultBranches branches foundBranches |
	"aGLHProject repository branches removeAll "
	self
		deprecated: 'Use importBranchesOfProject: instead of current one'
		on: '26 September 2025'
		in:
		'Pharo-12.0.0+SNAPSHOT.build.1571.sha.cf5fcd22e66957962c97dffc58b0393b7f368147 (64 Bit)'.
	resultBranches := self repoApi branches getAllFromProject:
		                  aGLHProject id.

	foundBranches := (resultBranches collect: [ :branchesJson |
		                  self parseBranchesResult: branchesJson ])
		                 flattened.

	'import the branches of project ' recordInfo.

	"WARNING: always add branch first into repository, than into model !"
	branches := aGLHProject repository branches
		            addAll: foundBranches
		            unless: self blockOnNameEquality.


	branches := self glhModel
		            addAll: branches
		            unless: self blockForBranchEquality.

	"WARNING : branch must load its HEAD commit (ref) in a second time "
	^ branches
]

{ #category : #'import - branches' }
GitlabModelImporter >> importBranchesOfProject: aGLHProject [

	| resultBranches branches foundBranches |
	"aGLHProject repository branches removeAll "
	resultBranches := self repoApi branches getAllFromProject:
		                  aGLHProject id.

	foundBranches := (resultBranches collect: [ :branchesJson |
		                  self parseBranchesResult: branchesJson ])
		                 flattened.

	'import the branches of project ' recordInfo.

	"WARNING: always add branch first into repository, than into model !"
	branches := aGLHProject repository branches
		            addAll: foundBranches
		            unless: self blockOnNameEquality.


	branches := self glhModel
		            addAll: branches
		            unless: self blockForBranchEquality.

	"WARNING : branch must load its HEAD commit (ref) in a second time "
	^ branches
]

{ #category : #'import - commits' }
GitlabModelImporter >> importCommit: aCommitID ofProject: aGLHProject [

	| result parsedResult |
	(self glhModel allWithType: GLHCommit) asOrderedCollection
		detect: [ :commit | commit id = aCommitID ]
		ifFound: [ :commit | ^ commit ].

	result := self repoApi commits
		          get: aCommitID
		          inProject: aGLHProject id.

	parsedResult := self parseCommitResult: result.

	parsedResult := self glhModel
		                add: parsedResult
		                unless: self blockOnIdEquality.
	parsedResult := aGLHProject repository commits
		                add: parsedResult
		                unless: self blockOnIdEquality.

	self withCommitDiffs ifTrue: [ self importDiffOfCommit: parsedResult ].

	^ parsedResult
]

{ #category : #'import - commits' }
GitlabModelImporter >> importCommitOfProject: anProject withId: anID [

	| commit result |
self
		deprecated: 'Use importCommit:ofProject: instead of current one'
		on: '27 August 2025'
		in: 'MSR 1.3.0 '
		transformWith: '`@rcv importCommitOfProject: `arg1 withId: `arg2' -> '`@rcv importCommit: `arg2 ofProject: `arg1'.
	anID ifNil: [ ^ nil ].

	('looking for commit ' , anID printString , ' in project : '
	 , anProject id printString) recordInfo.

	commit := (self
		           detectEntityType: GLHCommit
		           overAttribut: #id
		           equalTo: anID) ifNil: [
		          result := self repoApi commits
			                    get: anID
			                    inProject: anProject id.
		          commit := (self parseCommitsResult: '[' , result , ']')
			                    first.

		          commit := self glhModel
			                    add: commit
			                    unless: self blockOnIdEquality.
		          commit repository: anProject repository.

		          commit ].

	self withCommitDiffs ifTrue: [ self importDiffOfCommit: commit ].

	^ commit
]

{ #category : #'import - commits' }
GitlabModelImporter >> importCommits: aGLHProject [
	"limited to the last 20 commits"

	| results parsedResults params |
	self
		deprecated:
		'Use importLatestCommitsOfProject: instead of current one'
		on: '19 September 2025'
		in:
		'Pharo-12.0.0+SNAPSHOT.build.1571.sha.cf5fcd22e66957962c97dffc58b0393b7f368147 (64 Bit)'.
		
	params := { (#with_stats -> 'true') } asDictionary.
	results := self repoApi commits
		           getByPage: 1
		           perPage: 20
		           inProject: aGLHProject id
		           withParams: params.

	parsedResults := self parseCommitsResult: results.
	self glhModel addAll: parsedResults unless: self blockOnIdEquality.

	parsedResults do: [ :commit |
		commit repository: aGLHProject repository ].

	self withCommitDiffs ifTrue: [
		parsedResults do: [ :commit | self importDiffOfCommit: commit ] ].

	^ parsedResults
]

{ #category : #'import - commits' }
GitlabModelImporter >> importCommitsFollowing: aCommit upToDays: aNumberOfDay [
	"import the 'n' commits of a project starting from an initial 'aCommit' commit. 
	Lazy import does not import the entities inside the model"

	| date |
	date := aCommit created_at asDateAndTime.

	^ self
		  importCommitsOfBranch: aCommit branch
		  since: date
		  until: date + aNumberOfDay day
]

{ #category : #'import - commits' }
GitlabModelImporter >> importCommitsFromTag: fromTag toTag: toTag [ 
	| results commits project|
		
	(fromTag isNil or: [ toTag isNil ] ) ifTrue: [ ^ OrderedCollection new.  ] .

	project := fromTag repository project.
	results := self repoApi repositories compareInProject: (project id) from: fromTag name to: toTag name.
	
	commits := (NeoJSONReader fromString: results ) at: #commits ifAbsent: ['[]'].
	
	
	commits := self parseCommitsResult: (NeoJSONWriter toString: commits).
 	commits := glhModel addAll: commits unless: self blockOnIdEquality.
	commits := project repository commits addAll: commits unless: self blockOnIdEquality.
	
	self chainsCommitsFrom: commits. 
	
	^ commits. 
	
]

{ #category : #'import - commits' }
GitlabModelImporter >> importCommitsOfBranch: aGLHBranch [

	| commits |
	"	result := self glhApi
		          commitsOfProject: aGLHBranch repository project id
		          forRefName: aGLHBranch name."
	commits := self
		           importCommitsOfBranch: aGLHBranch
		           since: withCommitsSince.

	self chainsCommitsFrom: commits.

	commits do: [ :aCommit |
		aCommit repository: aGLHBranch repository.
		self completeImportedCommit: aCommit ].
	^ commits
]

{ #category : #'import - commits' }
GitlabModelImporter >> importCommitsOfBranch: aGLHBranch fromCommit: anInitialCommit [

	| commits |
	"	result := self glhApi
		          commitsOfProject: aGLHBranch repository project id
		          forRefName: aGLHBranch name."
	commits := self
		           importCommitsOfBranch: aGLHBranch
		           since: anInitialCommit committed_date.

	commits do: [ :aCommit |
		aCommit repository: aGLHBranch repository.
		self completeImportedCommit: aCommit ].
	^ commits
]

{ #category : #'import - commits' }
GitlabModelImporter >> importCommitsOfBranch: aGLHBranch since: fromDate [

	^ self importCommitsOfBranch: aGLHBranch since: fromDate until: nil
]

{ #category : #'import - commits' }
GitlabModelImporter >> importCommitsOfBranch: aGLHBranch since: fromDate until: toDate [

	| params result allCommits |
	params := {
		          (#ref_name -> aGLHBranch name).
		          (#since -> (fromDate
			            ifNotNil: [ fromDate asDate asDateAndTime asString ]
			            ifNil: [ '' ])).
		          (#until -> (toDate
			            ifNotNil: [ toDate asDate asDateAndTime asString ]
			            ifNil: [ '' ])).
		          (#with_stats -> 'true') } asDictionary.
	result := self repoApi commits
		          getAllInProject: aGLHBranch repository project id
		          withParams: params.

	allCommits := (result collect: [ :commitsJson |
		               self parseCommitsResult: commitsJson ]) flattened.

	aGLHBranch commits addAll: allCommits unless: self blockOnIdEquality.

	self glhModel
		addAll: aGLHBranch commits
		unless: self blockOnIdEquality.

	self chainsCommitsFrom: allCommits.

	^ allCommits
]

{ #category : #'import - commits' }
GitlabModelImporter >> importCommitsOfBranch: aGLHBranch until: toDate [

	^ self importCommitsOfBranch: aGLHBranch since: nil until: toDate
]

{ #category : #'import - commits' }
GitlabModelImporter >> importCommitsOfProject: aProject since: fromDate until: toDate [

	| params results allCommits |
	params := {
		          (#since
		           ->
		           (fromDate
			            ifNotNil: [ fromDate asDate asDateAndTime asString ]
			            ifNil: [ '' ])).
		          (#until
		           ->
		           (toDate
			            ifNotNil: [ toDate asDate asDateAndTime asString ]
			            ifNil: [ '' ])).
		          (#with_stats -> 'true').
		          (#all -> 'true') } asDictionary.
	results := self repoApi commits
		           getAllInProject: aProject id
		           withParams: params.

	allCommits := (results collect: [ :commitsJson |
		               self parseCommitsResult: commitsJson ]) flattened.

	allCommits:= aProject repository commits
		addAll: allCommits
		unless: self blockOnIdEquality.

	^ self glhModel addAll: allCommits unless: self blockOnIdEquality
]

{ #category : #'import - commits' }
GitlabModelImporter >> importCommitsOfTag: aGLHTag [

	| taggedCommit tags commits date |
	self
		deprecated: 'Use importCommitsFromTag:toTag: instead of current one'
		on: '21 July 2025'
		in:
		'Pharo-12.0.0+SNAPSHOT.build.1571.sha.cf5fcd22e66957962c97dffc58b0393b7f368147 (64 Bit)'.
	
	
	tags := self importTagsForProject: aGLHTag repository project.


	taggedCommit := aGLHTag commit ifNil: [
		                self
			                importCommit: aGLHTag target
			                ofProject: aGLHTag repository project ].

	date := (tags isEmptyOrNil and: [ tags size < 2 ])
		        ifTrue: [ aGLHTag created_at ]
		        ifFalse: [ tags second commit committed_date ].

	commits := self
		           importParentCommitsOfCommit: taggedCommit
		           since: tags third created_at.
	commits add: taggedCommit.
	self chainsCommitsFrom: commits.

	^ commits
]

{ #category : #'import - projects' }
GitlabModelImporter >> importContributedProjectsOfUser: aGLHUser [

	| remaningProjects params results projects projectsIds |
	params := {
		          (#order_by -> 'last_activity_at').
		          (#simple -> 'true') } asDictionary.
	results := self repoApi projects
		           contributedProjectsOfUser: aGLHUser id
		           withParams: params.

	projectsIds := (results collect: [ :projectsJson |
		             (NeoJSONReader fromString: projectsJson) collect: [:projectJson | projectJson at: #id ] ]) flattened.
	
	projects := self importProjects: projectsIds.
	remaningProjects := self importProjects:
		                    ((projects collect: #id) difference:
			                     ((self userCatalogue atId: aGLHUser id) at:
				                      #contributedProjects)).


	aGLHUser contributedProjects
		addAll: projects , remaningProjects
		unless: self blockOnIdEquality.

	self userCatalogue
		addUser: aGLHUser
		withProjects: (aGLHUser contributedProjects collect: #id).

	^ projects
]

{ #category : #'import - commits' }
GitlabModelImporter >> importDiffOfCommit: aCommit [

	| result diffsResult |
	aCommit diffs ifNotEmpty: [
		'Diff already importer: ' , aCommit short_id printString recordInfo.
		^ aCommit diffs ].
	('Import diff of commit: ' , aCommit short_id printString) recordInfo.

	result := self repoApi commits
		          diffOf: aCommit id
		          inProject: aCommit repository project id
		          uniDiff: true.

	(self isServerError: result) ifTrue: [ ^ {  } ].
	diffsResult := self newParseDiffResult: result.

	aCommit diffs addAll: diffsResult unless: self blockForDiffEquality.
	
	"changes are added into the model during the import"
	aCommit diffs do: [ :diff | self importDiffRangesForDiff: diff ].

	^ aCommit diffs
]

{ #category : #'import - merge-requests' }
GitlabModelImporter >> importDiffOfMergeRequest: aMergeRequest [

	| result diffsResult |
	aMergeRequest diffs ifNotEmpty: [
		'Diff of already importer: '
		, aMergeRequest iid printString recordInfo.
		^ aMergeRequest diffs ].
	('Import diff commits of MR ' , aMergeRequest iid printString)
		recordInfo.
	result := self repoApi mergeRequests
		          diffsOf: aMergeRequest iid
		          inProject: aMergeRequest project_id.
	diffsResult := result flatCollect: [ :aResult |
		               self newParseDiffResult: aResult ].


	aMergeRequest diffs
		addAll: diffsResult
		unless: self blockForDiffEquality.
	self glhModel
		addAll: aMergeRequest diffs
		unless: self blockForDiffEquality.

	aMergeRequest diffs do: [ :diff | self importDiffRangesForDiff: diff ].

	^ aMergeRequest diffs
]

{ #category : #'import - repositories' }
GitlabModelImporter >> importDirectoryFiles: aDirectoryFile OfBranch: aBranch [

	| result files apiFiles params |
	params := { 
		#ref -> aBranch name.
		#path -> (aDirectoryFile path , '/')
	} asDictionary.
	result := self repoApi repositories repositoryTreeOfProject: aBranch repository project id withParams: params.
		         " treeOfRepository: aBranch repository project id
		          ofBranch: aBranch name
		          andPath: aDirectoryFile path , '/'."
	apiFiles := (result collect: [ :treeJson | self parseFileTreeResult: treeJson ]) flattened.
	files := apiFiles collect: [ :apiFile |
		         self convertApiFileAsFile: apiFile ].
	
	files do: [ :file |
		self glhModel add: file.
		aDirectoryFile addFile: file ].
	
	files
		select: [ :file | file isKindOf: GLHFileDirectory ]
		thenCollect: [ :file |
		self importDirectoryFiles: file OfBranch: aBranch ]
]

{ #category : #'import - file' }
GitlabModelImporter >> importFileWithPath: aPath ofProject: aGLHProject inBranch: aBranch [ 
	self flag: 'imported file need to be store inside the model'.
	^ self repoApi repositories getRawFile: aPath ofProject: aGLHProject id withParams: {#ref -> aBranch name} asDictionary .
]

{ #category : #'import - repositories' }
GitlabModelImporter >> importFilesOfBranch: aBranch [

	| result files apiFiles params |
	params := { 
		#ref -> aBranch name.
	} asDictionary.
	
	result := self repoApi repositories repositoryTreeOfProject: aBranch repository project id withParams: params.
	
		          "treeOfRepository: aBranch repository project id
		          ofBranch: aBranch name
		          andPath: nil."
	apiFiles := (result collect: [ :filesJson | self parseFileTreeResult: filesJson  ]) flattened.
	files := apiFiles collect: [ :apiFile | 
		         self convertApiFileAsFile: apiFile ].
	files do: [ :file | 
		self glhModel add: file.
		aBranch addFile: file ].
	files
		select: [ :file | file isKindOf: GLHFileDirectory ]
		thenCollect: [ :file | 
		self importDirectoryFiles: file OfBranch: aBranch ].
	
   ^ files
]

{ #category : #'import - groups' }
GitlabModelImporter >> importGroup: aGroupID [

	| result groupResult |
	('Import group: ' , aGroupID printString) recordInfo.

	result := self repoApi groups get: aGroupID.
	
	"group: aGroupID."
	groupResult := self parseGroupResult: result.
	groupResult := self addGroupResultToModel: groupResult.

	groupResult projects do: [ :project |
		self completeImportedProject: project ].

	(self subGroupsOf: aGroupID) do: [ :subGroup |
		
		groupResult subGroups
			add: (self importGroup: subGroup id)
			unless: self blockOnIdEquality ].
	^ groupResult
]

{ #category : #'import - jobs' }
GitlabModelImporter >> importJobsOf: aPipeline [

	
	self
		deprecated: 'Use importJobsOfPipeline: instead of current one'
		on: '26 September 2025'
		in:
		'Pharo-12.0.0+SNAPSHOT.build.1571.sha.cf5fcd22e66957962c97dffc58b0393b7f368147 (64 Bit)'.
	^ self importJobsOfPipeline: aPipeline.
]

{ #category : #'import - jobs' }
GitlabModelImporter >> importJobsOfPipeline: aPipeline [

	| jobs results |
	results := self repoApi jobs
		           getAllForPipeline: aPipeline id
		           inProject: aPipeline project id.
	"jobsOfProject: aPipeline project id
		          ofPipelines: aPipeline id."
	jobs := (results collect: [ :jobsJson |
		         self parseJobsResult: jobsJson ]) flattened.


	jobs := self glhModel addAll: jobs unless: self blockOnIdEquality.
	jobs := aPipeline jobs addAll: jobs unless: self blockOnIdEquality.


	jobs do: [ :job | self completeImportedJob: job ].

	^ jobs
]

{ #category : #'import - commits' }
GitlabModelImporter >> importLatestCommitsOfProject: aGLHProject [
	"limited to the last 50 commits"

	| results parsedResults params |
	params := { 
		#with_stats -> 'true'.
		#all -> true
	 } asDictionary.
	results := self repoApi commits getByPage: 1 perPage: 50 inProject: aGLHProject id withParams: params.

	parsedResults := self parseCommitsResult: results.
	parsedResults := self glhModel
		                 addAll: parsedResults
		                 unless: self blockOnIdEquality.

	aGLHProject repository commits
		addAll: parsedResults
		unless: self blockOnIdEquality.

	self withCommitDiffs ifTrue: [
		parsedResults do: [ :commit | self importDiffOfCommit: commit ] ].

	^ parsedResults
]

{ #category : #'import - merge-requests' }
GitlabModelImporter >> importLatestMergeRequestsOfProject: aGLHProject [ 
	
	|results parsedResults|
	results := self repoApi mergeRequests getByPage: 1 perPage: 20  inProject: aGLHProject id. 
	parsedResults := self parseMergeRequestsResult: results. 
	
	parsedResults := glhModel addAll: parsedResults unless: self blockOnIdEquality.
	parsedResults := aGLHProject mergeRequests addAll: parsedResults unless: self blockOnIdEquality.
	^ parsedResults.
]

{ #category : #'import - pipelines' }
GitlabModelImporter >> importLatestPipelinesOfProject: aGLHProject [ 
	(self pipelinesOf: aGLHProject id withLimit:20) do: [ :pipeline |
		|pip|
		pip := self glhModel add: pipeline unless: self blockOnIdEquality .
		pip := aGLHProject pipelines add: pip unless: self blockOnIdEquality.
		self completeImportedPipeline: pip. 
		].
	
	^ aGLHProject pipelines 
]

{ #category : #'import - releases' }
GitlabModelImporter >> importLatestReleaseOfProject: aGLHProject [ 
	
	|result foundRelease|
	result := repoApi releases getLatestOfProject: aGLHProject id.
	foundRelease := self parseReleaseResult: result. 

	foundRelease := glhModel add: foundRelease unless: self blockOnNameEquality.
	foundRelease := aGLHProject releases add: foundRelease unless: self blockOnNameEquality.

	foundRelease author: (self importUser: foundRelease author id). 
	
	^ foundRelease.
]

{ #category : #'import - commits' }
GitlabModelImporter >> importMergeRequestCommits: aGLPHEMergeRequest [

	| commits result |
	aGLPHEMergeRequest commits ifNotNil: [ ^ aGLPHEMergeRequest commits ].
	
	result := self repoApi mergeRequests commitsOf: aGLPHEMergeRequest iid inProject: aGLPHEMergeRequest project id.
	
	commits := (result collect: [ :commitsJson | self parseCommitsResult: commitsJson ]) flattened.
	commits := commits collect: [ :commit | self importCommit: commit id ofProject: aGLPHEMergeRequest project ].
	aGLPHEMergeRequest commits: commits.


	^ commits
]

{ #category : #'import - commits' }
GitlabModelImporter >> importMergeRequestMergeCommits: aGLPHEMergeRequest [

	| foundCommits |
	foundCommits := OrderedCollection new.

	('Import commit sha of MR:  ' , aGLPHEMergeRequest iid printString)
		recordInfo.
	"the founds commits are added to the model during their respective import"
	aGLPHEMergeRequest mergeRequestCommit: ((self
			  importCommitOfProject: aGLPHEMergeRequest project
			  withId: aGLPHEMergeRequest sha) ifNotNil: [ :commit |
			 foundCommits add: commit ]).

	('Import commit merge_commit_sha of MR:  '
	 , aGLPHEMergeRequest iid printString) recordInfo.
	aGLPHEMergeRequest mergedCommit: ((self
			  importCommitOfProject: aGLPHEMergeRequest project
			  withId: aGLPHEMergeRequest merge_commit_sha) ifNotNil: [ :commit |
			 foundCommits add: commit ]).

	('Import commit squash_commit_sha of MR:  '
	 , aGLPHEMergeRequest iid printString) recordInfo.
	aGLPHEMergeRequest squashCommit: ((self
			  importCommitOfProject: aGLPHEMergeRequest project
			  withId: aGLPHEMergeRequest squash_commit_sha) ifNotNil: [ :commit |
			 foundCommits add: commit ]).


	self chainsCommitsFrom: foundCommits.
	^ foundCommits
]

{ #category : #'import - pipelines' }
GitlabModelImporter >> importMergeRequestPipelines: aGLHMergeRequest [
	"default limit to one page with last 100 pipelines"

	| results parseResults |
	self
		deprecated:
		'Use importPipelinesOfMergeRequest: instead of current one'
		on: '23 September 2025'
		in:
		'Pharo-12.0.0+SNAPSHOT.build.1571.sha.cf5fcd22e66957962c97dffc58b0393b7f368147 (64 Bit)'.

	^ self importPipelinesOfMergeRequest: aGLHMergeRequest. 
]

{ #category : #'import - merge-requests' }
GitlabModelImporter >> importMergeRequestsOfProject: aGLHProject [

	| results parsedResults mrs |
	('Import merge request of Project: ' , aGLHProject id printString)
		recordInfo.

	results := self repoApi mergeRequests getAllOfProject: aGLHProject id.
	parsedResults := (results collect: [ :projectsJson | self parseMergeRequestsResult: projectsJson ]) flattened. 

	aGLHProject mergeRequests
		addAll: parsedResults
		unless: self blockOnIdEquality.

	mrs := self glhModel
		       addAll: aGLHProject mergeRequests
		       unless: self blockOnIdEquality.


	"gets it related commits"
	aGLHProject mergeRequests do: [ :mr |
		self importMergeRequestMergeCommits: mr ].


	self withCommitDiffs ifTrue: [
		aGLHProject mergeRequests do: [ :mr |
			self importDiffOfMergeRequest: mr ] ].

	^ mrs
]

{ #category : #'import - merge-requests' }
GitlabModelImporter >> importMergeRequestsOfProject: aGLHProject since: fromDate until: toDate [

	| params result mergeRequests |
	('import MR of Project ' , aGLHProject name) recordInfo.
	params := {
		          (#created_after
		           ->
		           (fromDate
			            ifNotNil: [ fromDate asDateAndTime asString ]
			            ifNil: [ '' ])).
		          (#created_before
		           ->
		           (toDate
			            ifNotNil: [ toDate asDateAndTime asString ]
			            ifNil: [ '' ])).
		          (#scope -> 'all') } asDictionary.

	result := self repoApi mergeRequests
		          getAllOfProject: aGLHProject id
		          withParams: params.
	mergeRequests := (result collect: [ :mergeRequestsJson |
		                  self parseMergeRequestsResult: mergeRequestsJson ])
		                 flattened.

	aGLHProject mergeRequests
		addAll: mergeRequests
		unless: self blockOnIdEquality.

	"gets it related commits"
	aGLHProject mergeRequests do: [ :mr |
		self importMergeRequestMergeCommits: mr ].

	self withCommitDiffs ifTrue: [
		aGLHProject mergeRequests do: [ :mr |
			self importDiffOfMergeRequest: mr ] ].

	mergeRequests := self glhModel
		addAll: mergeRequests
		unless: (self blockEqualityOn: #iid).

	^ mergeRequests
]

{ #category : #'import - merge-requests' }
GitlabModelImporter >> importMergeResquestApprovals: aGLPHEMergeRequest [

	| results parsedResult |
	(String streamContents: [ :str |
		 str << 'Check approvals of '.
		 aGLPHEMergeRequest printOn: str ]) recordInfo.
	results := self repoApi mergeRequests approvalsOf: aGLPHEMergeRequest iid inProject: aGLPHEMergeRequest project id.

	parsedResult := generalReader
		                on: results readStream;
		                next.

	(parsedResult at: #approved_by) do: [ :approvedUser |
		aGLPHEMergeRequest addApproved_by:
			(self importUser: ((approvedUser at: #user) at: #id)) ].
	aGLPHEMergeRequest approved: (parsedResult at: #approved).
	^ aGLPHEMergeRequest
]

{ #category : #'import - merge-requests' }
GitlabModelImporter >> importMergeResquestAuthor: aGLPHEMergeRequest [

	| authorID |
	aGLPHEMergeRequest author ifNotNil: [ ^ aGLPHEMergeRequest author ].
	authorID := aGLPHEMergeRequest cacheAt: #authorID ifAbsent: [
		            | result |
		            result := self repoApi mergeRequests
			                      get: aGLPHEMergeRequest iid
			                      inProject: aGLPHEMergeRequest project_id.

		            (generalReader
			             on: result readStream;
			             next) at: #author at: #id ].
	^aGLPHEMergeRequest author: (self importUser: authorID)
]

{ #category : #'import - merge-requests' }
GitlabModelImporter >> importMergeResquestMerger: aGLPHEMergeRequest [

	| authorID |
	aGLPHEMergeRequest merge_user ifNotNil: [
		^ aGLPHEMergeRequest merge_user ].
	authorID := aGLPHEMergeRequest cacheAt: #mergeUserID ifAbsent: [
		            | result |
		            result := self repoApi mergeRequests
			                      get: aGLPHEMergeRequest iid
			                      inProject: aGLPHEMergeRequest project_id.
		            (generalReader
			             on: result readStream;
			             next)
			            at: #merge_user
			            ifPresent: [ :mergeUser |
			            mergeUser ifNotNil: [ :mruser | mruser at: #id ] ] ].
	^aGLPHEMergeRequest merge_user: (self importUser: authorID)
]

{ #category : #'import - notes' }
GitlabModelImporter >> importNotesOfMergeRequest: mergeRequest [

	| results notes |
	results := self repoApi notes
		           allInMergeRequest: mergeRequest iid
		           ofProject: mergeRequest project id.

	notes := results collect: [ :note | self parseNoteJson: note ].
	
	notes do: [ :tabNotes |
		tabNotes do: [ :note |
			note author: (self importUser: (note author at: #id)).
			note name: note id asString.
			
			note suggestions: (self getSuggestionsFromNote: note)
			
	] ].
	notes := notes flattened.
	notes := self glhModel addAll: notes unless: self blockOnIdEquality.
	notes := mergeRequest note
		         addAll: notes
		         unless: self blockOnIdEquality.
		


	^ notes
]

{ #category : #'import - commits' }
GitlabModelImporter >> importParentCommitsOfCommit: aGLHCommit since: aDate [

	| parentsIds commits |
	commits := Set new.
	aGLHCommit created_at asDateAndTime < aDate asDateAndTime ifTrue: [
		 
		^ commits
			  add: aGLHCommit;
			  yourself ].

	parentsIds := aGLHCommit parent_ids.

	commits addAll: (parentsIds collect: [ :id |
			 self
				 importCommit: id ofProject: aGLHCommit repository project  ]).

	
	commits addAll: (commits collect: [ :parentCommit |
		   self importParentCommitsOfCommit: parentCommit since: aDate ]).

	^ commits flattened asSet. 
]

{ #category : #'import - pipelines' }
GitlabModelImporter >> importPipeline: pipelineId OfProject: aGLHProject [

	
	| result pipeline|
	
	aGLHProject pipelines detect: [ :pip | pip id = pipelineId ] ifOne: [ :pip| ^pip ].
	
	('Search pipelines of: ' , aGLHProject id printString) recordInfo.
	result := self repoApi pipelines get: pipelineId inProject: aGLHProject id.
	
	pipeline :=  self parsePipelineResult: result.

	pipeline := self glhModel add: pipeline unless: self blockOnIdEquality .
	pipeline := aGLHProject pipelines add: pipeline unless: self blockOnIdEquality.
	
	^ self completeImportedPipeline: pipeline. 
]

{ #category : #'import - pipelines' }
GitlabModelImporter >> importPipelinesOfMergeRequest: aGLHMergeRequest [
	"default limit to one page with last 100 pipelines"

	| results parseResults |
	results := self repoApi pipelines
		           getByPage: 1
		           perPage: 100
		           inProject: aGLHMergeRequest project id
		           forMergerRequestIid: aGLHMergeRequest iid.

	parseResults := self parsePipelinesResult: results.

	parseResults do: [ :pipeline |
		pipeline project: aGLHMergeRequest project.
		].

	parseResults := glhModel
		                addAll: parseResults
		                unless: self blockOnIdEquality.
	parseResults := aGLHMergeRequest pipelines
		                addAll: parseResults
		                unless: self blockOnIdEquality.
		
		
	^ parseResults collect: [ :pip | self completeImportedPipeline: pip ]
]

{ #category : #'import - pipelines' }
GitlabModelImporter >> importPipelinesOfProject: aGLHProject [

	self
		deprecated:
		'Use importAllPipelinesOfProject: instead of current one'
		on: '23 September 2025'
		in:
		'Pharo-12.0.0+SNAPSHOT.build.1571.sha.cf5fcd22e66957962c97dffc58b0393b7f368147 (64 Bit)'.

	self flag:
		'WARNING: this import ALL the pipelines at ones. Prefered ImportLatestPipleinesOfProject: for faster performance (if possible)'.
	^ self importAllPipelinesOfProject: aGLHProject
]

{ #category : #'import - pipelines' }
GitlabModelImporter >> importPipelinesOfProject: aGLHProject after: after andBefore: before [
	^ (self pipelinesOf: aGLHProject id after: after andBefore: before) collect: [ :pipeline |
		|pip|
		pip := self glhModel add: pipeline unless: self blockOnIdEquality .
		pip := aGLHProject pipelines add: pip unless: self blockOnIdEquality.
		
		].
	
]

{ #category : #'import - pipelines' }
GitlabModelImporter >> importPipelinesOfProject: aGLHProject after: after andBefore: before onBranch: aBranch [
	| result parsedResults|
	('Search pipelines of: ' , aGLHProject id printString) recordInfo.
	
	result := self repoApi pipelines getAllInProject: aGLHProject id 
												withParams: {	#updated_before -> before.
																	#updated_after -> after.
																	#ref -> aBranch name} asDictionary .
	result isString ifTrue: [ ^ self parsePipelinesResult: result ].

	parsedResults := (result collect: [ :pipelinesJson |
			   self parsePipelinesResult: pipelinesJson ]) flattened.
	

	^ parsedResults collect: [ :pipeline |
		|pip|
		pip := self glhModel add: pipeline unless: self blockOnIdEquality .
		aGLHProject pipelines add: pip unless: self blockOnIdEquality.
		].
	
]

{ #category : #'import - projects' }
GitlabModelImporter >> importProject: aProjectID [

	| result projectResult |
	('Import project with id:  ' , aProjectID printString) recordInfo.

	(glhModel allWithType: GLHProject)
		detect: [ :project | project id = aProjectID ]
		ifFound: [ :project | ^ project ].

	result := self repoApi projects get: aProjectID.
	projectResult := self parseProjectResult: result.

	^ self completeImportedProject: projectResult
]

{ #category : #'import - projects' }
GitlabModelImporter >> importProjects [

	| result projects |
	('import all Projects') recordInfo.


	result := self repoApi projects all.
	projects := (result collect: [ :projectsJson | self parseArrayOfProject: projectsJson ]) flattened.
	
	self glhModel addAll: projects unless: self blockOnIdEquality.

	^ projects
]

{ #category : #'import - projects' }
GitlabModelImporter >> importProjectsSince: since [
	"heavy import of all projects"

	"copy import from commits"

	| newlyFoundProjects page foundProject amount |
	('import all Projects since: ' , since printString) recordInfo.

	"number of projects per page"
	amount := 100.
	page := 0.
	foundProject := OrderedCollection new.
	newlyFoundProjects := { true }.
	[ newlyFoundProjects isNotEmpty ] whileTrue: [
		| results |
		page := page + 1.
		('import projects page #' , page printString) recordInfo.

		results := self repoApi projects allWithParams: {#since -> since} asDictionary .

		newlyFoundProjects := self glhModel
			                      addAll: (self parseArrayOfProject: results)
			                      unless: self blockOnIdEquality.
		foundProject addAll: newlyFoundProjects ].
]

{ #category : #'import - commits' }
GitlabModelImporter >> importSZZFromCommit: aCommit [

	| diffRanges diffs szzCommits |
	szzCommits := Set new.
	diffs := self importDiffOfCommit: aCommit.
	diffRanges := diffs flatCollect: #diffRanges.
	diffRanges do: [ :range |
		| blames |
		blames := NeoJSONReader fromString: (self repoApi repositories
				           getBlameOf: range diff new_path
				           inRef: aCommit id
				           start: range start
				           end: range end
				           ofProject: aCommit repository project id).
		blames collect: [ :blame |
			blame isDictionary ifTrue: [
				szzCommits add: (self
						 importCommit: (blame at: #commit at: #id)
						 ofProject: aCommit repository project) ] ] ].
	^ szzCommits
]

{ #category : #'import - tags' }
GitlabModelImporter >> importTagsForProject: aProject [ 
	|results tags |
	results  := repoApi tags getAllOfProject: aProject id.
	"get a group of tags"
	tags := results flatCollect: [ :result |
			self parseTagsResult: result. 
		 ].

	"add the tags inside the model"
	tags := glhModel addAll: tags unless: self blockOnNameEquality.
	tags := aProject repository tags addAll: tags unless: self blockOnNameEquality.
	
	"update tag's commit if already imported"
	tags do: [ :tag |
		tag commit: (self importCommit: tag commit id ofProject: aProject).
		 ].
	
	"update tag's release if already imported"
	tags do: [ :tag |
		|release|
		tag release ifNotNil: [ 
			release := glhModel add: tag release unless: (self blockEqualityOn: #tag_name).
			release := aProject releases add: tag release unless: (self blockEqualityOn: #tag_name).
			tag release: release. 
			 ].
		 ].
	
	^ tags
]

{ #category : #'import - users' }
GitlabModelImporter >> importUser: aUserID [

	| result userResult |
	(self glhModel allWithType: GLHUser)
		detect: [ :user | user id = aUserID ]
		ifFound: [ :user | ^ user ].
	('Import user: ' , aUserID printString) recordInfo.
	
	result := self repoApi users get: aUserID.
	userResult := self parseUserResult: result.
	
	userResult := self glhModel add: userResult unless: self blockOnIdEquality.
	userCatalogue addUser: userResult.
	^ userResult 
]

{ #category : #'import - users' }
GitlabModelImporter >> importUserByUsername: anUsername [

	| dicUsername resultUser |
	dicUsername := ((self glhModel allWithType: GLHUser) collect: [ :user |
		                user username -> user ]) asSet asDictionary.

	dicUsername addAll: self userCatalogue collectUsernames.


	resultUser := dicUsername
		              at: anUsername
		              ifAbsent: [ "thus we have to import this new user"
			              | result userId searchResult params |
			              ('Import user with username: '
			               , anUsername printString) recordInfo.
			              params := { (#search -> anUsername) } asDictionary.
			              result := self repoApi users allWithParams: params.
							
							 "when result is an error"
							 (result isString) ifTrue: [ result := { result } ].
							
			              searchResult := result ifEmpty: [ result ] ifNotEmpty: [(result collect: [ :usersJson |
				                               NeoJSONReader fromString: usersJson ]) first].
							 
			              (searchResult class = Dictionary and: [
				               (searchResult at: #message) includesSubstring:
					               '403 Forbidden' ])
				              ifTrue: [ "if the result is an 403 error we fake a new user"
					              self glhModel
						              add: (GLHUser new
								               username: anUsername;
								               name: anUsername;
								               yourself)
						              unless: [ :nu :ou | nu username = ou username ] ]
				              ifFalse: [
					              searchResult
						              ifEmpty: [ "results can be empty thus we force a new user with the info we have "
							              self glhModel
								              add: (GLHUser new
										               username: anUsername;
										               name: anUsername;
										               yourself)
								              unless: [ :nu :ou | nu username = ou username ] ]
						              ifNotEmpty: [ "because we may already have the researched user, we look by ID in the model"
							              userId := searchResult first at: #id.
							              (self glhModel allWithType: GLHUser)
								              detect: [ :user | user id = userId ]
								              ifNone: [ self importUser: userId ] ] ] ].

	self userCatalogue addUser: resultUser withName: anUsername.

	^ resultUser
]

{ #category : #initialization }
GitlabModelImporter >> initReader [
	
	"add specific reader for this importer here"
	super initReader
]

{ #category : #initialization }
GitlabModelImporter >> initialize [

	super initialize.
	withCommitDiffs := true.
	withInitialCommits := false.
	withInitialMergeRequest := false.

	self withCommitsSince: 1 week.

	
]

{ #category : #private }
GitlabModelImporter >> isServerError: aString [
	^ aString = '{"message":"500 Internal Server Error"}'
]

{ #category : #'import - projects' }
GitlabModelImporter >> loadAllProjectsFromRepositorySoftware [
	"heavy import that load all the active project inside the model. Only import the project entities"
	|projects|
	
	projects := self repoApi projects. 
]

{ #category : #'private - parsing' }
GitlabModelImporter >> newParseCommitResult: result [

	generalReader  on: result readStream.

	^ generalReader nextAs: GLHCommit
]

{ #category : #'private - parsing' }
GitlabModelImporter >> newParseDiffResult: result [

	generalReader on: result readStream.
	^ generalReader nextAs: #ArrayOfDiff
]

{ #category : #'private - parsing' }
GitlabModelImporter >> parseArrayOfProject: arrayOfProjects [

	| reader |
	reader := generalReader on: arrayOfProjects readStream.
	
	^ reader nextAs: #ArrayOfProject
]

{ #category : #'private - parsing' }
GitlabModelImporter >> parseBranchesResult: result [

	| reader |
	reader := generalReader on: result readStream.

	^ reader nextAs: #ArrayOfBranch
]

{ #category : #'private - parsing' }
GitlabModelImporter >> parseBranchesResult: result ofProject: aGLHProject [

	| reader |
	self flag: 'WARNING: do not use the importer inside a parsing process. do it after using a object cached on the sub elemnt id'.
	self
		deprecated: 'Use parseBranchesResult: instead of current one'
		on: '23 September 2025'
		in:
		'Pharo-12.0.0+SNAPSHOT.build.1571.sha.cf5fcd22e66957962c97dffc58b0393b7f368147 (64 Bit)'.


	reader := NeoJSONReader on: result readStream.
	reader mapInstVarsFor: GLHBranch.

	reader for: GLHBranch do: [ :mapping |
		mapping
			mapProperty: #commit
			getter: [  ]
			setter: [ :branch :rawCommit |
				branch sha: (rawCommit at: #id)
				"commit := self
					          importCommit: (rawCommit at: #id)
					          ofProject: aGLHProject.
				branch commits add: commit unless: self blockOnIdEquality " ] ].

	reader
		for: #ArrayOfBranch
		customDo: [ :customMappting |
		customMappting listOfElementSchema: GLHBranch ].

	^ reader nextAs: #ArrayOfBranch
]

{ #category : #'private - parsing' }
GitlabModelImporter >> parseCommitResult: result [

	| reader |
	reader := generalReader on: result readStream.

	^ reader nextAs: GLHCommit
]

{ #category : #'private - parsing' }
GitlabModelImporter >> parseCommitsResult: result [

	| reader |
	reader := generalReader on: result readStream.

	^ reader nextAs: #ArrayOfCommit
]

{ #category : #private }
GitlabModelImporter >> parseDiffResult: result [

	| reader |
	self
		deprecated: 'Use #newParseDiffResult: instead'
		on: '28 June 2024'
		in:
		'Pharo-11.0.0+build.726.sha.aece1b5473acf3830a0e082c1bc3a15d4ff3522b (64 Bit)'.
	reader := NeoJSONReader on: result readStream.
	reader for: GLHDiff do: [ :mapping |
		mapping mapInstVars:
			#( deleted_file new_file new_path old_path renamed_file ).
		mapping mapInstVar: #diffString to: #diff ].

	reader
		for: #ArrayOfDiffs
		customDo: [ :customMappting |
		customMappting listOfElementSchema: GLHDiff ].
	^ reader nextAs: #ArrayOfDiffs
]

{ #category : #'private - parsing' }
GitlabModelImporter >> parseFileTreeResult: aResult [

	| reader |
	reader := NeoJSONReader on: aResult readStream.
	reader mapInstVarsFor: GLHApiFile.
	reader
		for: #ArrayOfFile
		customDo: [ :customMappting | 
		customMappting listOfElementSchema: GLHApiFile ].
	^ reader nextAs: #ArrayOfFile
]

{ #category : #'private - parsing' }
GitlabModelImporter >> parseGroupResult: aResult [

	| reader |
	reader := generalReader on: aResult readStream.

	^ reader nextAs: GLHGroup
]

{ #category : #'private - parsing' }
GitlabModelImporter >> parseJobsResult: result [ 
	| reader |
	reader := generalReader on: result readStream.

	^ reader nextAs: #ArrayOfJob
]

{ #category : #'private - parsing' }
GitlabModelImporter >> parseJobsResult: result ofProject: aProject [

	| reader |
	self
		deprecated: 'Use parseJobsResult: instead of current one'
		on: '23 September 2025'
		in:
		'Pharo-12.0.0+SNAPSHOT.build.1571.sha.cf5fcd22e66957962c97dffc58b0393b7f368147 (64 Bit)'.
		
	reader := generalReader on: result readStream.
	reader for: GLHJob do: [ :mapping |
		mapping
			mapProperty: #commit
			getter: [ :object | #ignore ]
			setter: [ :object :value |
				value ifNotNil: [
					object commit:
						(self importCommit: (value at: #id) ofProject: aProject) ] ] ].


	^ reader nextAs: #ArrayOfJob
]

{ #category : #'private - parsing' }
GitlabModelImporter >> parseMergeRequestsResult: result [

	generalReader on: result readStream.
	^ generalReader nextAs: #ArrayOfMergeRequest
]

{ #category : #'private - parsing' }
GitlabModelImporter >> parseNoteJson: results [

	| reader |
	"Créer un lecteur JSON"
	
	reader := generalReader on: results readStream.

	"Corriger la conversion des dates"
	"reader for: DateAndTime customDo: [ :mapping |
		mapping decoder: [ :string |
			DateAndTime readFrom: string readStream ] ]."


	^ reader nextAs: #ArrayOfNote
]

{ #category : #'private - parsing' }
GitlabModelImporter >> parsePipelineResult: result [

	| reader |
	
	(result includesSubstring: '{"message":"40' )ifTrue: [ ^ {  } ].
	
	reader := generalReader on: result readStream.
	
	^ reader nextAs: GLHPipeline
]

{ #category : #'private - parsing' }
GitlabModelImporter >> parsePipelinesResult: result [

	| reader |
	(result includesSubstring: '{"message":"40') ifTrue: [ ^ {  } ].

	reader := generalReader on: result readStream.

	^ reader nextAs: #ArrayOfPipeline
]

{ #category : #'private - parsing' }
GitlabModelImporter >> parseProjectResult: aResult [

	| reader |
	reader := generalReader on: aResult readStream.

	^ reader nextAs: GLHProject
]

{ #category : #'private - parsing' }
GitlabModelImporter >> parseReleaseResult: result [
	|reader|
	reader := generalReader on: result readStream.
	
	^ reader nextAs: GLHRelease 
]

{ #category : #'private - parsing' }
GitlabModelImporter >> parseReleasesResult: result [

	| reader |
	reader := generalReader on: result readStream.

	^ reader nextAs: #ArrayOfRelease
]

{ #category : #'private - parsing' }
GitlabModelImporter >> parseSubGroupResult: aResult [

	| reader |
	reader := generalReader on: aResult readStream.
	
	^ reader nextAs: #ArrayOfGroup
]

{ #category : #'private - parsing' }
GitlabModelImporter >> parseTagsResult: result [
	|reader|
	reader := generalReader on: result readStream.
	
	^ reader nextAs: #ArrayOfTags
]

{ #category : #'private - parsing' }
GitlabModelImporter >> parseUserResult: result [

	| reader |
	
	reader := generalReader on: result readStream.
	
	^ reader nextAs: GLHUser

	

]

{ #category : #'private - parsing' }
GitlabModelImporter >> parseUsersResult: result [

	| reader |
	
	reader := generalReader on: result readStream.
	
	^ reader nextAs: #ArrayOfUser
	
]

{ #category : #'import - projects' }
GitlabModelImporter >> partiallyImportProject: aProjectID [

	| result projectResult |
	('Import project with id:  ' , aProjectID printString) recordInfo.

	(glhModel allWithType: GLHProject)
		detect: [ :project | project id = aProjectID ]
		ifFound: [ :project | ^ project ].

	result := self repoApi projects get: aProjectID.
	projectResult := self parseProjectResult: result.

	projectResult repository: GLHRepository new.
	self glhModel add: projectResult repository.
	self completeImportsOfRepository: projectResult repository.

	^ projectResult
]

{ #category : #'import - pipelines' }
GitlabModelImporter >> pipelinesOf: aProjectID after: after andBefore: before [

	| result |
	('Search pipelines of: ' , aProjectID printString) recordInfo.
	
	result := self repoApi pipelines getAllInProject: aProjectID 
												withParams: {	#updated_before -> before.
																	#updated_after -> after} asDictionary .
	result isString ifTrue: [ ^ self parsePipelinesResult: result ].

	^ (result collect: [ :pipelinesJson |
			   self parsePipelinesResult: pipelinesJson ]) flattened
]

{ #category : #'import - pipelines' }
GitlabModelImporter >> pipelinesOf: aProjectID withLimit: aLimit [

	| result |
	('Search pipelines of: ' , aProjectID printString) recordInfo.
	result := self repoApi pipelines getByPage: 1 perPage: aLimit inProject: aProjectID.
	result isString ifTrue: [ ^ self parsePipelinesResult: result ].

	^ (result collect: [ :pipelinesJson |
			   self parsePipelinesResult: pipelinesJson ]) flattened
]

{ #category : #accessing }
GitlabModelImporter >> repoApi: anObject [
	super repoApi: anObject.
	self repoApi output: 'json'
]

{ #category : #'search - merge request' }
GitlabModelImporter >> searchMergeRequestMentionning: aString [ 
	|mergeRequests results|
	results := repoApi mergeRequests search: aString.
	mergeRequests := self parseMergeRequestsResult: results.
	mergeRequests :=	mergeRequests collect: [ :mr |
		mr project: (self importProject: mr project_id).
		mr
		 ].
	
	^ glhModel addAll: mergeRequests unless: self blockOnIdEquality. 
]

{ #category : #private }
GitlabModelImporter >> selectEntityType: aType overAttribut: aSelector equalTo: value [

	^ (self glhModel allWithType: aType)
		select: [ :entity | (entity perform: aSelector) = value ]
]

{ #category : #'import - groups' }
GitlabModelImporter >> subGroupsOf: aGroupID [

	| results subgroups |
	('Search subgroup of: ' , aGroupID printString) recordInfo.
	results := self repoApi groups subgroupsOf: aGroupID.
	subgroups := (results collect: [ :subgroupsJson | self parseSubGroupResult: subgroupsJson ]) flattened.
	
	^ subgroups
]

{ #category : #accessing }
GitlabModelImporter >> withInitialCommits: boolean [
	withInitialCommits := boolean 
]
