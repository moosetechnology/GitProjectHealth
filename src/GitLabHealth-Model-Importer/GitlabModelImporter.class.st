Class {
	#name : #GitlabModelImporter,
	#superclass : #GitModelImporter,
	#instVars : [
		'withInitialCommits',
		'withInitialMergeRequest',
		'generalReader'
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

{ #category : #private }
GitlabModelImporter >> chainsCommitsFrom: commitsCollection [

	| dic |
	
	('Chains ', commitsCollection size printString , ' commits') recordInfo.
	
	dic := ((self glhModel allWithType: GLHCommit) collect: [ :commit |
		        commit id -> commit ]) asSet asDictionary.

	commitsCollection do: [ :commit |
		commit parent_ids do: [ :parentId | 
			dic
				at: parentId
				ifPresent: [ :parentCommit |
					parentCommit childCommits
						add: commit
						unless: self blockOnIdEquality ]
				ifAbsent: [  ] ] ].
	^ commitsCollection
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

	self importPipelinesOfProject: importedProject.

	"aGLHProject creator: (self importUser: aGLHProject creator_id)."

	(self importUser: importedProject creator_id) addCreatedProject:
		importedProject.


	importedProject repository: GLHRepository new.
	self glhModel add: importedProject repository.
	self importRepository: importedProject repository.


	withInitialMergeRequest ifTrue: [
		self
			importMergeRequests: importedProject
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

{ #category : #'private - configure reader' }
GitlabModelImporter >> configureReaderForCommit: reader [

  	reader for: GLHCommit do: [ :mapping |
		mapping mapInstVars:
			#( id short_id title author_name author_email committer_name
			   committer_email message web_url ).
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

	reader for: DateAndTime customDo: [ :mapping |
		mapping decoder: [ :string | DateAndTime fromString: string ] ].

	reader
		for: #ArrayOfIds
		customDo: [ :mapping | mapping decoder: [ :string | string ] ].
  
	reader
		for: #ArrayOfCommit
		customDo: [ :customMappting |
		customMappting listOfElementSchema: GLHCommit ].

]

{ #category : #'private - configure reader' }
GitlabModelImporter >> configureReaderForDiffs: reader [

	reader for: GLHDiff do: [ :mapping |
		mapping mapInstVars:
			#( deleted_file new_file new_path old_path renamed_file ).
		mapping mapInstVar: #diffString to: #diff ].

	reader
		for: #ArrayOfDiffs
		customDo: [ :customMappting |
		customMappting listOfElementSchema: GLHDiff ].
	^ reader
]

{ #category : #'private - configure reader' }
GitlabModelImporter >> configureReaderForGroup: reader [

	reader for: GLHGroup do: [ :mapping |
		mapping mapInstVars.
		(mapping mapInstVar: #projects) valueSchema: #ArrayOfProjects ].
	reader mapInstVarsFor: GLHProject.
	reader
		for: #ArrayOfProjects
		customDo: [ :customMappting |
		customMappting listOfElementSchema: GLHProject ].
	reader
		for: #ArrayOfGroups
		customDo: [ :customMappting |
		customMappting listOfElementSchema: GLHGroup ]
]

{ #category : #'private - configure reader' }
GitlabModelImporter >> configureReaderForMergeRequest: reader [
	"declare quil y a un array a mapper"

	reader for: #ArrayOfMergeRequest customDo: [ :customMappting |
		customMappting listOfElementSchema: GLHMergeRequest ].

	"declare la liste des properties"
	reader for: GLHMergeRequest do: [ :mapping |
		mapping mapInstVars:
			#( blocking_discussions_resolved changes_count description
			   detailed_merge_status discussion_locked downvotes draft first_deployed_to_production_at
			   force_remove_source_branch has_conflicts id iid labels latest_build_finished_at
			   latest_build_started_at merge_commit_sha merge_status
			   merge_when_pipeline_succeeds merged_at milestone project_id
			   reference references_full references_relative
			   references_short sha should_remove_source_branch
			   source_branch source_project_id squash squash_commit_sha
			   squash_on_merge state subscribed target_branch target_project_id
			   task_completion_status_completed_count
			   task_completion_status_count time_stats_human_time_estimate
			   time_stats_human_total_time_spent
			   time_stats_time_estimate time_stats_total_time_spent
			   title updated_at upvotes user_notes_count web_url work_in_progress ).
		(mapping mapInstVar: #created_at) valueSchema: DateAndTime.
		(mapping mapInstVar: #updated_at) valueSchema: DateAndTime.
		(mapping mapInstVar: #merged_at) valueSchema: DateAndTime.
		(mapping mapInstVar: #closed_at) valueSchema: DateAndTime.
		"(mapping mapInstVar: #assignee) valueSchema: GLHUser."
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
					object cacheAt: #mergeUserID put: (value at: #id) ] ] ].

	"(mapping mapInstVar: #closed_by) valueSchema: GLHUser.
	(mapping mapInstVar: #mergeCommit) valueSchema: GLHCommit."
	"indique ce que doit faire le reader lorsqu'il parse une DateAndTime object"
	reader for: DateAndTime customDo: [ :mapping |
		mapping decoder: [ :string |
			string ifNil: [ nil ] ifNotNil: [ DateAndTime fromString: string ] ] ]
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

{ #category : #'import - commits' }
GitlabModelImporter >> importAndLoadLatestsCommitsOfProject: aGLHProject [

	| commits completedProject |
	completedProject := self completeImportProject: aGLHProject.
	commits := self importLastestCommitsOfProject: completedProject.
	commits do: [ :commit | self completeImportedCommit: commit ].
	self chainsCommitsFrom: commits.
	^ commits
]

{ #category : #'import-gitblame' }
GitlabModelImporter >> importBlame: aGLHFile ofProject: aGLHProject [

	| results  params   |


			params := { 
		    #ref ->  'main'  .
	       } asDictionary.
	  results := self repoApi blames getBlameFile: aGLHFile ofProject: aGLHProject withParams: params      .
	^ results 
	
]

{ #category : #'import-gitblame' }
GitlabModelImporter >> importBlame: aGLHFile ofProject: aGLHProject fromBranch: aGLHBranch [

	| results  params  blameDict   |


			params := { 
		    #ref ->   aGLHBranch  .
	       } asDictionary.
	  results := self repoApi blames getBlameFile: aGLHFile ofProject: aGLHProject withParams: params      .
	  "Créer un dictionnaire avec le fichier en clé et le blâme en valeur"
	^results 
 "     blameDict := Dictionary new.
      blameDict at: aGLHFile put: results.

   ^ blameDict."
	
]

{ #category : #'import - repositories' }
GitlabModelImporter >> importBranches: aGLHProject [ 
	"Fetches all branches of the given project"
	| results parsedResults |

	"Fetch branches from the repository API"
	results := self repoApi branches getAllFromProject: aGLHProject id.

	"Parse the retrieved branches"
	parsedResults := (results collect: [ :branchJson | self parseBranchesResult: branchJson ]) flattened.

	"Add branches to the model (if not blocked by name equality)"
	self glhModel addAll: parsedResults unless: self blockOnNameEquality.

	"Return the list of parsed branches"
	^ parsedResults.

]

{ #category : #'import - commits' }
GitlabModelImporter >> importCommit: aCommitID ofProject: aGLHProject [

	| result parsedResult |
	(self glhModel allWithType: GLHCommit) asOrderedCollection
		detect: [ :commit | commit id = aCommitID ]
		ifFound: [ :commit | ^ commit ].
	result := self repoApi commits get: aCommitID inProject: aGLHProject id.
	
	parsedResult := self parseCommitResult: result.
	
	self
		addCommits: { parsedResult }
		toRepository: aGLHProject repository.
	^ parsedResult
]

{ #category : #'import - commits' }
GitlabModelImporter >> importCommitOfProject: anProject withId: anID [

	| commit result |
	anID ifNil: [ ^ nil ].

	('looking for commit ' , anID printString , ' in project : '
	 , anProject id printString) recordInfo.

	commit := (self
		           detectEntityType: GLHCommit
		           overAttribut: #id
		           equalTo: anID) ifNil: [
		          result := self repoApi commits get: anID inProject: anProject id.
		          commit := (self parseCommitsResult: '[' , result , ']')
			                    first.

		          self glhModel add: commit unless: self blockOnIdEquality.
		          commit repository: anProject repository.

		          commit ].

	self withCommitDiffs ifTrue: [ self importDiffOfCommit: commit ].

	^ commit
]

{ #category : #'import - commits' }
GitlabModelImporter >> importCommits: aGLHProject [
	"limited to the last 20 commits"

	| results parsedResults params |
	params := { 
	 #with_stats -> 'true'
	} asDictionary.
	results := self repoApi commits getByPage: 1 perPage: 20 inProject: aGLHProject id withParams: params.
	
	parsedResults := self parseCommitsResult: results.
	self glhModel addAll: parsedResults unless: self blockOnIdEquality.

	parsedResults do: [ :commit |
		commit repository: aGLHProject repository ].

	self withCommitDiffs ifTrue: [
		parsedResults do: [ :commit | self importDiffOfCommit: commit ] ].
	
	^ parsedResults. 
]

{ #category : #'import - commits' }
GitlabModelImporter >> importCommitsFollowing: aCommit upToDays: aNumberOfDay [
	"import the 'n' commits of a project starting from an initial 'aCommit' commit. 
	Lazy import does not import the entities inside the model"

	| date |
	date := aCommit created_at asDateAndTime.

	^ self
		  importCommitsOfBranch: aCommit branch
		  forRefName: aCommit branch name
		  since: date
		  until: (date + aNumberOfDay day)
]

{ #category : #commit }
GitlabModelImporter >> importCommitsOf: aGLHProject withStats: aBoolean until: toDate [

	| newlyFoundCommit page |
	
	self deprecated: [  ] .
	
	page := 0.
	newlyFoundCommit := { true }.
	[ newlyFoundCommit isNotEmpty ] whileTrue: [
		| results parsedResults existingCommits |
		page := page + 1.
		('import commit page ' , page printString) recordInfo.
		results := self repoApi
			           commitsOfProject: aGLHProject id
			           forRefName: nil
			           since: nil
			           until: nil
			           path: nil
			           author: nil
			           all: nil
			           with_stats: aBoolean
			           firstParent: nil
			           order: nil
			           trailers: nil
			           perPage: 100
			           page: page.
		parsedResults := self parseCommitsResult: results.
		existingCommits := aGLHProject mooseModel allWithType: GLHCommit.

		newlyFoundCommit := parsedResults reject: [ :commitParsed |
			                    (toDate isNil or: [
				                     commitParsed committed_date
				                     < toDate asDateAndTime ]) or: [
				                    existingCommits anySatisfy: [ :existingCommit |
					                    existingCommit id = commitParsed id ] ] ].
		aGLHProject mooseModel addAll: newlyFoundCommit.
		aGLHProject repository commits addAll: newlyFoundCommit ].


	self withCommitDiffs ifTrue: [
		aGLHProject repository commits do: [ :commit |
			self importDiffOfCommit: commit ] ]
]

{ #category : #'import - commits' }
GitlabModelImporter >> importCommitsOfBranch: aGLHBranch [

	| commits |
	"	result := self glhApi
		          commitsOfProject: aGLHBranch repository project id
		          forRefName: aGLHBranch name."
	commits := self
		           importCommitsOfBranch: aGLHBranch
		           forRefName: aGLHBranch name
		           since: withCommitsSince.

	self chainsCommitsFrom: commits.

	commits do: [ :aCommit |
		aCommit repository: aGLHBranch repository.
		self completeImportedCommit: aCommit. 
		 ]
]

{ #category : #'import - commits' }
GitlabModelImporter >> importCommitsOfBranch: aGLHBranch forRefName: refName since: fromDate [

	^ self
		  importCommitsOfBranch: aGLHBranch
		  forRefName: aGLHBranch name
		  since: fromDate
		  until: nil
]

{ #category : #'import - commits' }
GitlabModelImporter >> importCommitsOfBranch: aGLHBranch forRefName: refName since: fromDate until: toDate [

	| params result allCommits |
	params := { 
	  #ref_name -> aGLHBranch name.
	  #since ->  (fromDate ifNotNil: [ fromDate asDate asDateAndTime asString ] ifNil: [ '' ]).
	  #until -> (toDate ifNotNil: [ toDate asDate asDateAndTime asString ] ifNil: [ '' ]). 

	} asDictionary.
	result := self repoApi commits getAllInProject: aGLHBranch repository project id withParams: params.
	
	allCommits := (result collect: [ :commitsJson | self parseCommitsResult: commitsJson ]) flattened.
	
	aGLHBranch commits
			addAll: allCommits
			unless: self blockOnIdEquality.

	self glhModel
		addAll: aGLHBranch commits
		unless: self blockOnIdEquality.

	^ allCommits
]

{ #category : #'import - commits' }
GitlabModelImporter >> importCommitsOfBranch: aGLHBranch forRefName: refName until: toDate [

	^ self
		  importCommitsOfBranch: aGLHBranch
		  forRefName: aGLHBranch name
		  since: nil
		  until: toDate
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
GitlabModelImporter >> importCreatorOfCommit: aCommit [

	aCommit commitCreator ifNil: [
		aCommit commitCreator:
			(self importUserByUsername: aCommit author_name) ].
	self userCatalogue
		addUser: aCommit commitCreator
		withProject: aCommit repository project id.
	^ aCommit commitCreator
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

{ #category : #'import - merge request' }
GitlabModelImporter >> importDiffOfMergeRequest: aMergeRequest [

	| result diffsResult |
	aMergeRequest diffs ifNotEmpty: [
		'Diff of already importer: '
		, aMergeRequest iid printString recordInfo.
		^ aMergeRequest diffs ].
	('Import diff commits of MR ' , aMergeRequest iid printString)
		recordInfo.
	result := self repoApi mergeRequests diffsOf: aMergeRequest iid inProject: aMergeRequest project_id.

	diffsResult := self newParseDiffResult: result.


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
		self importDirectoryFiles: file OfBranch: aBranch ] .
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
		self completeImportProject: project ].

	(self subGroupsOf: aGroupID) do: [ :subGroup |
		
		groupResult subGroups
			add: (self importGroup: subGroup id)
			unless: self blockOnIdEquality ].
	^ groupResult
]

{ #category : #'import - jobs' }
GitlabModelImporter >> importJobsOf: aPipeline [

	| jobs results |
	results := self repoApi jobs allForPipeline: aPipeline id inProject: aPipeline project id.
		          "jobsOfProject: aPipeline project id
		          ofPipelines: aPipeline id."
	jobs := (results collect: [ :jobsJson | self parseJobsResult: jobsJson ofProject: aPipeline project ]) flattened.
	jobs do: [ :job | aPipeline addJob: job ].
	self glhModel addAll: jobs.
	
	^jobs

]

{ #category : #'import - commits' }
GitlabModelImporter >> importLastestCommitsOfProject: aGLHProject [
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

{ #category : #'import - merge request' }
GitlabModelImporter >> importMergeRequestCommits: aGLPHEMergeRequest [

	| commits result |
	aGLPHEMergeRequest commits ifNotNil: [ ^ aGLPHEMergeRequest commits ].
	
	result := self repoApi mergeRequests commitsOf: aGLPHEMergeRequest iid inProject: aGLPHEMergeRequest project id.
	
	commits := (result collect: [ :commitsJson | self parseCommitsResult: commitsJson ]) flattened.
	commits := commits collect: [ :commit | self importCommit: commit id ofProject: aGLPHEMergeRequest project ].
	aGLPHEMergeRequest commits: commits.


	^ commits
]

{ #category : #'import - merge request' }
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

{ #category : #'import - merge request' }
GitlabModelImporter >> importMergeRequests: aGLHProject [

	| results parsedResults mrs |
	('Import merge request of Project: ' , aGLHProject id printString)
		recordInfo.

	results := self repoApi mergeRequests allOfProject: aGLHProject id.
	parsedResults := (results collect: [ :projectsJson | self parseMergeRequestResult: projectsJson ]) flattened. 

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

{ #category : #'import - merge request' }
GitlabModelImporter >> importMergeRequests: aGLHProject since: fromDate until: toDate [

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
		          allOfProject: aGLHProject id
		          withParams: params.
	mergeRequests := (result collect: [ :mergeRequestsJson |
		                  self parseMergeRequestResult: mergeRequestsJson ])
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

	self glhModel
		addAll: mergeRequests
		unless: (self blockEqualityOn: #iid).

	^ mergeRequests
]

{ #category : #'import - merge request' }
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

{ #category : #'import - merge request' }
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

{ #category : #'import - merge request' }
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

{ #category : #'import - commits' }
GitlabModelImporter >> importParentCommitsOfCommit: aGLHCommit since: aDate [

	| parentsIds commits |
	commits := OrderedCollection new.
	aGLHCommit created_at asDateAndTime < aDate asDateAndTime ifTrue: [
		 
		^ commits
			  add: aGLHCommit;
			  yourself ].

	parentsIds := aGLHCommit parent_ids.

	commits addAll: (parentsIds collect: [ :id |
			 self
				 importCommitOfProject: aGLHCommit repository project
				 withId: id ]).


	^ (commits collect: [ :parentCommit |
		   self importParentCommitsOfCommit: parentCommit since: aDate ])
		  flatten
]

{ #category : #'imports - pipelines' }
GitlabModelImporter >> importPipelinesOfProject: aGLHProject [

	(self pipelinesOf: aGLHProject id) do: [ :pipeline |
		self glhModel add: pipeline unless: self blockOnIdEquality .
		aGLHProject pipelines add: pipeline unless: self blockOnIdEquality]
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

	^ self completeImportProject: projectResult
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
GitlabModelImporter >> importProjects: aCollectionOfProjectID [


	^ aCollectionOfProjectID collect: [ :id | self importProject: id ]
]

{ #category : #imports }
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

		results := self repoApi projects: amount since: since page: page.

		newlyFoundProjects := self glhModel
			                      addAll: (self parseArrayOfProject: results)
			                      unless: self blockOnIdEquality.
		foundProject addAll: newlyFoundProjects ].
]

{ #category : #'import - repositories' }
GitlabModelImporter >> importRepository: aGLHRepository [

	| resultBranches branches |
	[
	('import the repository of project ' , aGLHRepository project name)
		recordInfo.

	resultBranches := self repoApi branches getAllFromProject:
		                  aGLHRepository project id.

	branches := (resultBranches collect: [ :branchesJson |
		             self parseBranchesResult: branchesJson ]) flattened.

	'import the branches of project ' recordInfo.

	branches := aGLHRepository branches
		            addAll: branches
		            unless: self blockOnNameEquality.
	branches := self glhModel
		            addAll: branches
		            unless: self blockOnNameEquality.


	self withFiles ifTrue: [
		branches do: [ :branch | self importFilesOfBranch: branch ] ] ]
		on: NeoJSONParseError
		do: [
		self inform: aGLHRepository project name , ' has no repository' ].
	
	withInitialCommits ifTrue: [
		aGLHRepository branches do: [ :branch |
			self importCommitsOfBranch: branch ] ]
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

	generalReader := NeoJSONReader new.
	self configureReaderForCommit: generalReader.
	self configureReaderForGroup: generalReader.
	self configureReaderForDiffs: generalReader.
	self configureReaderForMergeRequest: generalReader
]

{ #category : #initialization }
GitlabModelImporter >> initialize [

	super initialize.
	withCommitDiffs := true.
	withInitialCommits := false.
	withInitialMergeRequest := false.

	self withCommitsSince: 1 week.

	self initReader
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
	^ generalReader nextAs: #ArrayOfDiffs
]

{ #category : #'private - parsing' }
GitlabModelImporter >> parseArrayOfProject: arrayOfProjects [

	| reader |
	reader := NeoJSONReader on: arrayOfProjects readStream.
	reader
		for: #ArrayOfProjects
		customDo: [ :customMappting |
		customMappting listOfElementSchema: GLHProject ].
	reader for: GLHProject do: [ :mapping |
		mapping mapInstVar: #name to: #name.
		mapping mapInstVar: #description to: #description.
		mapping mapInstVar: #id to: #id.
		mapping mapInstVar: #archived to: #archived.
		mapping mapInstVar: #web_url to: #html_url.
		mapping mapInstVar: #topics to: #topics ].
	^ reader nextAs: #ArrayOfProjects
]

{ #category : #'private - parsing' }
GitlabModelImporter >> parseBranchesResult: result [

	| reader |
	reader := NeoJSONReader on: result readStream.
	reader mapInstVarsFor: GLHBranch.
	reader
		for: #ArrayOfBranch
		customDo: [ :customMappting | 
		customMappting listOfElementSchema: GLHBranch ].
	^ reader nextAs: #ArrayOfBranch
]

{ #category : #'private - parsing' }
GitlabModelImporter >> parseCommitResult: result [

	| reader |
	reader := NeoJSONReader on: result readStream.

	reader for: GLHCommit do: [ :mapping |
		mapping mapInstVars:
			#( id short_id title author_name author_email committer_name
			   committer_email message web_url ).
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

	reader for: DateAndTime customDo: [ :mapping |
		mapping decoder: [ :string | DateAndTime fromString: string ] ].

	reader
		for: #ArrayOfIds
		customDo: [ :mapping | mapping decoder: [ :string | string ] ].


	^ reader nextAs: GLHCommit
]

{ #category : #'private - parsing' }
GitlabModelImporter >> parseCommitsResult: result [

	| reader |
	reader := NeoJSONReader on: result readStream.

  	reader for: GLHCommit do: [ :mapping |
		mapping mapInstVars:
			#( id short_id title author_name author_email committer_name
			   committer_email message web_url ).
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

	reader for: DateAndTime customDo: [ :mapping |
		mapping decoder: [ :string | DateAndTime fromString: string ] ].

	reader
		for: #ArrayOfIds
		customDo: [ :mapping | mapping decoder: [ :string | string ] ].
  
	reader
		for: #ArrayOfCommit
		customDo: [ :customMappting |
		customMappting listOfElementSchema: GLHCommit ].

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

	reader := NeoJSONReader on: aResult readStream.
	reader for: GLHGroup do: [ :mapping |
		mapping mapInstVars.
		(mapping mapInstVar: #projects) valueSchema: #ArrayOfProjects ].
	reader mapInstVarsFor: GLHProject.
	reader
		for: #ArrayOfProjects
		customDo: [ :customMappting |
		customMappting listOfElementSchema: GLHProject ].
	^ reader nextAs: GLHGroup
]

{ #category : #'private - parsing' }
GitlabModelImporter >> parseJobsResult: result ofProject: aProject [

	| reader |
	reader := NeoJSONReader on: result readStream.
	reader for: GLHJob do: [ :mapping |
		mapping mapInstVars: #( id allow_failure web_url name ).

		mapping
			mapProperty: #user
			getter: [ :object | #ignore ]
			setter: [ :object :value |
			object user: (self importUser: (value at: #id)) ].

		mapping
			mapProperty: #commit
			getter: [ :object | #ignore ]
			setter: [ :object :value |
				value ifNotNil: [
					object commit:
						(self importCommit: (value at: #id) ofProject: aProject) ] ].

		mapping
			mapProperty: #duration
			getter: [ :object | #ignore ]
			setter: [ :object :value |
			value ifNotNil: [ object duration: value seconds ] ] ].

	reader
		for: #ArrayOfGLHJob
		customDo: [ :customMappting |
		customMappting listOfElementSchema: GLHJob ].
	^ reader nextAs: #ArrayOfGLHJob
]

{ #category : #'private - parsing' }
GitlabModelImporter >> parseMergeRequestResult: result [

	generalReader on: result readStream.
	^ generalReader nextAs: #ArrayOfMergeRequest
]

{ #category : #'private - parsing' }
GitlabModelImporter >> parsePipelinesResult: result [

	| reader |
	
	(result includesSubstring: '{"message":"40' )ifTrue: [ ^ {  } ].
	
	reader := NeoJSONReader on: result readStream.
	reader mapInstVarsFor: GLHPipeline.
	reader for: GLHPipeline do: [ :mapping |
		mapping
			mapProperty: #created_at
			getter: [ :object | #ignore ]
			setter: [ :object :value |
			object runDate: (DateAndTime fromString: value) ] ].
	reader
		for: #ArrayOfPipelines
		customDo: [ :customMappting |
		customMappting listOfElementSchema: GLHPipeline ].
	^ reader nextAs: #ArrayOfPipelines
]

{ #category : #'private - parsing' }
GitlabModelImporter >> parseProjectResult: aResult [ 
		| reader |
	reader := NeoJSONReader on: aResult readStream.
	reader for: GLHProject do: [ :mapping |
		mapping mapInstVars. ].
"	reader mapInstVarsFor: GLHProject."

	^ reader nextAs: GLHProject
]

{ #category : #'private - parsing' }
GitlabModelImporter >> parseSubGroupResult: aResult [

	| reader |
	reader := NeoJSONReader on: aResult readStream.
	self configureReaderForGroup: reader.
	^ reader nextAs: #ArrayOfGroups
]

{ #category : #'private - parsing' }
GitlabModelImporter >> parseUserResult: result [

	| reader |
	reader := NeoJSONReader on: result readStream.
	reader mapInstVarsFor: GLHUser.
	^ reader nextAs: GLHUser
]

{ #category : #'private - parsing' }
GitlabModelImporter >> parseUsersResult: result [

	| reader |
	reader := NeoJSONReader on: result readStream.

	reader mapInstVarsFor: GLHUser.

	reader
		for: #ArrayOfUser
		customDo: [ :customMappting |
		customMappting listOfElementSchema: GLHUser ].

	^ reader nextAs: #ArrayOfUser
]

{ #category : #'imports - pipelines' }
GitlabModelImporter >> pipelinesOf: aProjectID [

	| result |
	('Search pipelines of: ' , aProjectID printString) recordInfo.
	result := self repoApi pipelines getAllInProject: aProjectID.
	result isString ifTrue: [ ^ self parsePipelinesResult: result ].

	^ (result collect: [ :pipelinesJson |
			   self parsePipelinesResult: pipelinesJson ]) flattened
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
