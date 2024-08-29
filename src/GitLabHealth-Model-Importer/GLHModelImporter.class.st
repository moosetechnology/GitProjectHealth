Class {
	#name : #GLHModelImporter,
	#superclass : #Object,
	#instVars : [
		'glhModel',
		'glhApi',
		'withFiles',
		'withCommitDiffs',
		'withCommitsSince',
		'withInitialCommits',
		'withInitialMergeRequest',
		'generalReader',
		'userCatalogue'
	],
	#classVars : [
		'currentImporter'
	],
	#category : #'GitLabHealth-Model-Importer'
}

{ #category : #accessing }
GLHModelImporter class >> current [

	^ currentImporter
]

{ #category : #'private - api' }
GLHModelImporter >> addCommits: commitsList toRepository: aProjectRepository [
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
GLHModelImporter >> addGroupResultToModel: groupResult [
	|group|
	group := self glhModel add: groupResult unless: self blockOnIdEquality.
	self glhModel
		addAll: group projects
		unless: self blockOnIdEquality.
	^ group 
]

{ #category : #accessing }
GLHModelImporter >> beWithFiles [
	withFiles := true
]

{ #category : #accessing }
GLHModelImporter >> beWithouFiles [
	withFiles := false
]

{ #category : #'as yet unclassified' }
GLHModelImporter >> blockEqualityOn: aSymbol [
	^ [ :existing :new |
	  (existing perform: aSymbol) = (new perform: aSymbol) ]
]

{ #category : #equality }
GLHModelImporter >> blockForDiffEquality [
	^ [ :existing :new |
			existing diffString size = new diffString size and: [
				existing diffString = new diffString ] ]
]

{ #category : #equality }
GLHModelImporter >> blockOnIdEquality [

	^ [ :existing :new |
	  existing id = new id ]
]

{ #category : #equality }
GLHModelImporter >> blockOnNameEquality [

	^ self blockEqualityOn: #name
]

{ #category : #commit }
GLHModelImporter >> chainsCommitsFrom: commitsCollection [

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

{ #category : #'private - api' }
GLHModelImporter >> completeImportProject: aGLHProject [

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

	^ importedProject
]

{ #category : #'as yet unclassified' }
GLHModelImporter >> completeImportedCommit: aCommit [

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
GLHModelImporter >> configureReaderForCommit: reader [

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
GLHModelImporter >> configureReaderForDiffs: reader [

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
GLHModelImporter >> configureReaderForGroup: reader [

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

{ #category : #private }
GLHModelImporter >> convertApiFileAsFile: aAPIFile [

	aAPIFile type = 'tree' ifTrue: [ 
		^ GLHFileDirectory new
			  name: aAPIFile name;
			  yourself ].
	^ GLHFileBlob new
		  name: aAPIFile name;
		  yourself
]

{ #category : #'as yet unclassified' }
GLHModelImporter >> detectEntityType: aType overAttribut: aSelector equalTo: value [

	^ (self glhModel allWithType: aType) detect: [ :entity |
		  (entity perform: aSelector) = value ] ifNone: [ nil ]. 
]

{ #category : #'as yet unclassified' }
GLHModelImporter >> filterCommitChanges: aCollection [

	^ aCollection reject: [ :line |
		  | trimmedLine |
		  trimmedLine := line trimLeft.
		  (trimmedLine beginsWith: '---') or: [
			  (trimmedLine beginsWith: '+++') or: [
				  trimmedLine beginsWith: '\ No newline at end of file' ] ] ]
]

{ #category : #accessing }
GLHModelImporter >> glhApi [

	^ glhApi
]

{ #category : #accessing }
GLHModelImporter >> glhApi: anObject [

	glhApi := anObject
]

{ #category : #accessing }
GLHModelImporter >> glhModel [

	^ glhModel
]

{ #category : #accessing }
GLHModelImporter >> glhModel: anObject [

	glhModel := anObject
]

{ #category : #'as yet unclassified' }
GLHModelImporter >> importActiveHumanUsers [

	| newlyFoundUser page foundUsers |
	page := 0.
	foundUsers := OrderedCollection new.
	newlyFoundUser := { true }.
	[ newlyFoundUser isNotEmpty ] whileTrue: [
		| results |
		page := page + 1.
		('import users page ' , page printString) recordInfo.
		results := self glhApi
			           usersHuman: true
			           active: true
			           withoutProjectBots: true
			           perPage: 100
			           page: page.

		newlyFoundUser := self parseUsersResult: results.
		"newlyFoundCommit do: [ :c | c repository: aProject repository ]."

		foundUsers addAll:
			(self glhModel
				 addAll: newlyFoundUser
				 unless: self blockOnIdEquality) ].


	^ foundUsers
]

{ #category : #api }
GLHModelImporter >> importAllGroups [

	| page foundGroups newlyFoundGroups |
	page := 0.
	foundGroups := OrderedCollection new.
	newlyFoundGroups := { true }.
	[ newlyFoundGroups isNotEmpty ] whileTrue: [
		| results |
		page := page + 1.
		results := self glhApi listGroupsWithTopLevelOnly: true page: page.

		newlyFoundGroups := generalReader
			                    on: results readStream;
			                    nextAs: #ArrayOfGroups.
		foundGroups addAll: newlyFoundGroups ].
	^ foundGroups
]

{ #category : #'as yet unclassified' }
GLHModelImporter >> importAndLoadLatestsCommitsOfProject: aGLHProject [

	| commits |
	self completeImportProject: aGLHProject.
	commits := self importLastestCommitsOfProject: aGLHProject.
	commits do: [ :commit | self completeImportedCommit: commit ].
	self chainsCommitsFrom: commits.
	^ commits
]

{ #category : #'private - api' }
GLHModelImporter >> importCommit: aCommitID ofProject: aGLHProject [

	| result parsedResult |
	(self glhModel allWithType: GLHCommit) asOrderedCollection
		detect: [ :commit | commit id = aCommitID ]
		ifFound: [ :commit | ^ commit ].
	result := self glhApi
		          commit: aCommitID
		          ofProject: aGLHProject id
		          withStat: false.
	parsedResult := self parseCommitResult: result.
	self
		addCommits: { parsedResult }
		toRepository: aGLHProject repository.
	^ parsedResult
]

{ #category : #'as yet unclassified' }
GLHModelImporter >> importCommitOfProject: anProject withId: anID [

	| commit result |
	anID ifNil: [ ^ nil ].

	('looking for commit ' , anID printString , ' in project : '
	 , anProject id printString) recordInfo.

	commit := (self
		           detectEntityType: GLHCommit
		           overAttribut: #id
		           equalTo: anID) ifNil: [
		          result := self glhApi commit: anID ofProject: anProject id.
		          commit := (self parseCommitsResult: '[' , result , ']')
			                    first.

		          self glhModel add: commit unless: self blockOnIdEquality.
		          commit repository: anProject repository.

		          commit ].

	self withCommitDiffs ifTrue: [ self importDiffOfCommit: commit ].

	^ commit
]

{ #category : #'as yet unclassified' }
GLHModelImporter >> importCommitsFollowing: aCommit upToDays: aNumberOfDay [
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
GLHModelImporter >> importCommitsOProject: aProject since: fromDate until: toDate [

	| newlyFoundCommit page foundCommit |
	page := 0.
	foundCommit := OrderedCollection new.
	newlyFoundCommit := { true }.
	[ newlyFoundCommit isNotEmpty ] whileTrue: [
		| results |
		page := page + 1.
		('import commit page ' , page printString) recordInfo.
		results := self glhApi
			           commitsOfProject: aProject id
			           forRefName: nil
			           since:
			           (fromDate ifNotNil: [ fromDate asDateAndTime asString ])
			           until:
			           (toDate ifNotNil: [ toDate asDateAndTime asString ])
			           path: nil
			           author: nil
			           all: true
			           with_stats: true
			           firstParent: nil
			           order: nil
			           trailers: nil
			           perPage: 100
			           page: page.

		newlyFoundCommit := self parseCommitsResult: results.
		"newlyFoundCommit do: [ :c | c repository: aProject repository ]."

		foundCommit addAll: (aProject repository commits
			addAll: newlyFoundCommit
			unless: self blockOnIdEquality). ].


	^ self glhModel addAll: foundCommit unless: self blockOnIdEquality
]

{ #category : #commit }
GLHModelImporter >> importCommitsOfBranch: aGLHBranch forRefName: refName since: fromDate [

	^ self
		  importCommitsOfBranch: aGLHBranch
		  forRefName: aGLHBranch name
		  since: fromDate
		  until: nil
]

{ #category : #commit }
GLHModelImporter >> importCommitsOfBranch: aGLHBranch forRefName: refName since: fromDate until: toDate [

	| newlyFoundCommit page foundCommit|
	page := 0.
	foundCommit := OrderedCollection new. 
	newlyFoundCommit := { true }.
	[ newlyFoundCommit isNotEmpty ] whileTrue: [
		| results |
		page := page + 1.
		('import commit page ' , page printString) recordInfo.
		results := self glhApi
			           commitsOfProject: aGLHBranch repository project id
			           forRefName: aGLHBranch name
			           since:
			           (fromDate ifNotNil: [ fromDate asDateAndTime asString ])
			           until:
			           (toDate ifNotNil: [ toDate asDateAndTime asString ])
			           path: nil
			           author: nil
			           all: nil
			           with_stats: nil
			           firstParent: nil
			           order: nil
			           trailers: nil
			           perPage: 100
			           page: page.

		newlyFoundCommit := self parseCommitsResult: results.
	aGLHBranch commits
			addAll: newlyFoundCommit
			unless: self blockOnIdEquality.
	foundCommit addAll: newlyFoundCommit.  
			].

	self glhModel
		addAll: aGLHBranch commits
		unless: self blockOnIdEquality.

	"self withCommitDiffs ifTrue: [
		aGLHBranch commits: [ :commit | self importDiffOfCommit: commit ] ]."

	^ foundCommit
]

{ #category : #commit }
GLHModelImporter >> importCommitsOfBranch: aGLHBranch forRefName: refName until: toDate [

	^ self
		  importCommitsOfBranch: aGLHBranch
		  forRefName: aGLHBranch name
		  since: nil
		  until: toDate
]

{ #category : #'as yet unclassified' }
GLHModelImporter >> importContributedProjectsOfUser: aGLHUser [

	| newlyFoundElmts page foundElmts |
	page := 0.
	foundElmts := OrderedCollection new.
	newlyFoundElmts := { true }.
	[ newlyFoundElmts isNotEmpty ] whileTrue: [
		| results |
		page := page + 1.
		('import contributed project of user ' , aGLHUser name , ' page '
		 , page printString) recordInfo.
		results := self glhApi 
			           contributedProjectsOfUserId: aGLHUser id
			           orderBy: 'last_activity_at'
			           simple: true
			           sort: 'desc'
			           perPage: 100
			           page: page.

		newlyFoundElmts := self parseArrayOfProject: results.

		foundElmts addAll:
			(self glhModel
				 addAll: newlyFoundElmts
				 unless: self blockOnIdEquality) ].


	aGLHUser contributedProjects
		addAll: foundElmts
		unless: self blockOnIdEquality.

	^ foundElmts
]

{ #category : #'as yet unclassified' }
GLHModelImporter >> importCreatorOfCommit: aCommit [

	aCommit commitCreator ifNil: [
				
		aCommit commitCreator:
		
			(self importUserByUsername: aCommit author_name) ]
]

{ #category : #api }
GLHModelImporter >> importDiffOfCommit: aCommit [

	| result diffsResult |
	aCommit diffs ifNotEmpty: [
		'Diff already importer: ' , aCommit short_id printString recordInfo.
		^ aCommit diffs ].
	('Import diff of commit: ' , aCommit short_id printString) recordInfo.
	result := self glhApi
		          commitDiff: aCommit id
		          ofProject: aCommit repository project id
		          unidiff: true.
	diffsResult := self newParseDiffResult: result.

	^ aCommit diffs addAll: diffsResult unless: self blockForDiffEquality.

]

{ #category : #'private - api' }
GLHModelImporter >> importDirectoryFiles: aDirectoryFile OfBranch: aBranch [

	| result files apiFiles |
	result := self glhApi
		          treeOfRepository: aBranch repository project id
		          ofBranch: aBranch name
		          andPath: aDirectoryFile path , '/'.
	apiFiles := self parseFileTreeResult: result.
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

{ #category : #'private - api' }
GLHModelImporter >> importFilesOfBranch: aBranch [

	| result files apiFiles |
	result := self glhApi
		          treeOfRepository: aBranch repository project id
		          ofBranch: aBranch name
		          andPath: nil.
	apiFiles := self parseFileTreeResult: result.
	files := apiFiles collect: [ :apiFile | 
		         self convertApiFileAsFile: apiFile ].
	files do: [ :file | 
		self glhModel add: file.
		aBranch addFile: file ].
	files
		select: [ :file | file isKindOf: GLHFileDirectory ]
		thenCollect: [ :file | 
		self importDirectoryFiles: file OfBranch: aBranch ]
]

{ #category : #api }
GLHModelImporter >> importGroup: aGroupID [

	| result groupResult |
	('Import group: ' , aGroupID printString) recordInfo.

	result := self glhApi group: aGroupID.
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

{ #category : #api }
GLHModelImporter >> importJobsOf: aPipeline [

	| result jobs |
	result := self glhApi
		          jobsOfProject: aPipeline project id
		          ofPipelines: aPipeline id.
	jobs := self parseJobsResult: result ofProject: aPipeline project.
	jobs do: [ :job | aPipeline addJob: job ].
	self glhModel addAll: jobs

]

{ #category : #'private - api' }
GLHModelImporter >> importLastestCommitsOfProject: aGLHProject [
	"limited to the last 50 commits"

	| results parsedResults |
	results := self glhApi
		           commitsOfProject: aGLHProject id
		           forRefName: nil
		           since: nil
		           until: nil
		           path: nil
		           author: nil
		           all: nil
		           with_stats: true
		           firstParent: nil
		           order: nil
		           trailers: nil
		           perPage: 50
		           page: nil.
	parsedResults := self parseCommitsResult: results.
	parsedResults := self glhModel addAll: parsedResults unless: self blockOnIdEquality.

	aGLHProject repository commits addAll: parsedResults unless: self blockOnIdEquality.
	"parsedResults do: [ :commit |
		commit repository: aGLHProject repository ]."

	self withCommitDiffs ifTrue: [
		parsedResults do: [ :commit | self importDiffOfCommit: commit ] ].

	^ parsedResults
]

{ #category : #commit }
GLHModelImporter >> importParentCommitsOfCommit: aGLHCommit since: aDate [

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

{ #category : #'private - api' }
GLHModelImporter >> importPipelinesOfProject: aGLHProject [

	(self pipelinesOf: aGLHProject id) do: [ :pipeline |
		self glhModel add: pipeline unless: self blockOnIdEquality .
		aGLHProject pipelines add: pipeline unless: self blockOnIdEquality]
]

{ #category : #projects }
GLHModelImporter >> importProject: aProjectID [

	| result projectResult |
	('Import project with id: ' , aProjectID printString) recordInfo.

	result := self glhApi project: aProjectID.
	projectResult := self parseProjectResult: result.

	^ self completeImportProject: projectResult
]

{ #category : #imports }
GLHModelImporter >> importProjects [

	^ self importProjectsSince: nil
]

{ #category : #projects }
GLHModelImporter >> importProjects: aCollectionOfProjectID [

	^ aCollectionOfProjectID collect: [ :id | self importProject: id ]
]

{ #category : #imports }
GLHModelImporter >> importProjectsSince: since [
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

		results := self glhApi projects: amount since: since page: page.

		newlyFoundProjects := self glhModel
			                      addAll: (self parseArrayOfProject: results)
			                      unless: self blockOnIdEquality.
		foundProject addAll: newlyFoundProjects ].

	^ foundProject
]

{ #category : #'private - api' }
GLHModelImporter >> importRepository: aGLHRepository [

	| resultBranches branches |
	[
	('import the repository of project ' , aGLHRepository project name)
		recordInfo.

	resultBranches := self glhApi branchesOfRepository:
		                  aGLHRepository project id.
	branches := self parseBranchesResult: resultBranches.

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
		self inform: aGLHRepository project name , ' has no repository' ]
]

{ #category : #'private - api' }
GLHModelImporter >> importUser: aUserID [

	| result userResult |
	(self glhModel allWithType: GLHUser)
		detect: [ :user | user id = aUserID ]
		ifFound: [ :user | ^ user ].
	('Import user: ' , aUserID printString) recordInfo.
	result := self glhApi user: aUserID.
	userResult := self parseUserResult: result.
	^ self glhModel add: userResult unless: self blockOnIdEquality
]

{ #category : #user }
GLHModelImporter >> importUserByUsername: anUsername [

	| dicUsername resultUser |
	dicUsername := ((self glhModel allWithType: GLHUser) collect: [ :user |
		                user username -> user ]) asSet asDictionary.

	dicUsername addAll: self userCatalogue collectUsernames.


	resultUser := dicUsername
		              at: anUsername
		              ifAbsent: [ "thus we have to import this new user"
			              | result userId searchResult |
			              ('Import user with username: '
			               , anUsername printString) recordInfo.
			              result := self glhApi usersSearchByUsername:
				                        anUsername.
			              searchResult := NeoJSONReader fromString: result.

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
GLHModelImporter >> initReader [

	generalReader := NeoJSONReader new.
	self configureReaderForCommit: generalReader.
	self configureReaderForGroup: generalReader.
	self configureReaderForDiffs: generalReader. 
]

{ #category : #initialization }
GLHModelImporter >> initialize [

	withFiles := false.
	withCommitDiffs := false.
	withInitialCommits := false.
	withInitialMergeRequest := false.
	withCommitsSince := (Date today - 1 week) asDateAndTime.
	userCatalogue := GLHUserCatalogueV2 new
		                 anImporter: self;
		                 yourself.
	self initReader
]

{ #category : #importer }
GLHModelImporter >> loadAllProjectsFromRepositorySoftware [
	"heavy import that load all the active project inside the model. Only import the project entities"
	|projects|
	
	projects := self glhApi projects. 
]

{ #category : #'as yet unclassified' }
GLHModelImporter >> makeGlobal [
	currentImporter := self
]

{ #category : #private }
GLHModelImporter >> newParseCommitResult: result [

	generalReader  on: result readStream.

	^ generalReader nextAs: GLHCommit
]

{ #category : #private }
GLHModelImporter >> newParseDiffResult: result [

	generalReader on: result readStream.
	^ generalReader nextAs: #ArrayOfDiffs
]

{ #category : #parsing }
GLHModelImporter >> parseArrayOfProject: arrayOfProjects [

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

{ #category : #private }
GLHModelImporter >> parseBranchesResult: result [

	| reader |
	reader := NeoJSONReader on: result readStream.
	reader mapInstVarsFor: GLHBranch.
	reader
		for: #ArrayOfBranch
		customDo: [ :customMappting | 
		customMappting listOfElementSchema: GLHBranch ].
	^ reader nextAs: #ArrayOfBranch
]

{ #category : #private }
GLHModelImporter >> parseCommitResult: result [

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

{ #category : #private }
GLHModelImporter >> parseCommitsResult: result [

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
GLHModelImporter >> parseFileTreeResult: aResult [

	| reader |
	reader := NeoJSONReader on: aResult readStream.
	reader mapInstVarsFor: GLHApiFile.
	reader
		for: #ArrayOfFile
		customDo: [ :customMappting | 
		customMappting listOfElementSchema: GLHApiFile ].
	^ reader nextAs: #ArrayOfFile
]

{ #category : #private }
GLHModelImporter >> parseGroupResult: aResult [

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

{ #category : #private }
GLHModelImporter >> parseJobsResult: result ofProject: aProject [

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

{ #category : #private }
GLHModelImporter >> parsePipelinesResult: result [

	| reader |
	
	result = '{"message":"403 Forbidden"}' ifTrue: [ ^ {  } ].
	
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

{ #category : #parsing }
GLHModelImporter >> parseProjectResult: aResult [ 
		| reader |
	reader := NeoJSONReader on: aResult readStream.
	reader for: GLHProject do: [ :mapping |
		mapping mapInstVars. ].
"	reader mapInstVarsFor: GLHProject."

	^ reader nextAs: GLHProject
]

{ #category : #private }
GLHModelImporter >> parseSubGroupResult: aResult [

	| reader |
	reader := NeoJSONReader on: aResult readStream.
	self configureReaderForGroup: reader.
	^ reader nextAs: #ArrayOfGroups
]

{ #category : #private }
GLHModelImporter >> parseUserResult: result [

	| reader |
	reader := NeoJSONReader on: result readStream.
	reader mapInstVarsFor: GLHUser.
	^ reader nextAs: GLHUser
]

{ #category : #private }
GLHModelImporter >> parseUsersResult: result [

	| reader |
	reader := NeoJSONReader on: result readStream.

	reader mapInstVarsFor: GLHUser.

	reader
		for: #ArrayOfUser
		customDo: [ :customMappting |
		customMappting listOfElementSchema: GLHUser ].

	^ reader nextAs: #ArrayOfUser
]

{ #category : #'private - api' }
GLHModelImporter >> pipelinesOf: aProjectID [

	| result |
	('Search pipelines of: ' , aProjectID printString) recordInfo.
	result := self glhApi pipelinesOfProject: aProjectID.
	^ self parsePipelinesResult: result .
]

{ #category : #'private - api' }
GLHModelImporter >> subGroupsOf: aGroupID [

	| results parsedResult result page |
	('Search subgroup of: ' , aGroupID printString) recordInfo.
	results := OrderedCollection new.
	page := 0.
	
	parsedResult := { true }.
	[ parsedResult size > 0 ] whileTrue: [ 
		result := self glhApi subgroupsOfGroup: aGroupID page: page.
		parsedResult := self parseSubGroupResult: result.
		results addAll: parsedResult.
				page := page + 1. ].
	
	^ results
]

{ #category : #accessing }
GLHModelImporter >> userCatalogue [
	^ userCatalogue 
]

{ #category : #accessing }
GLHModelImporter >> userCatalogue: aGLHUserCatalogue [

	userCatalogue := aGLHUserCatalogue.
	aGLHUserCatalogue anImporter: self. 
]

{ #category : #accessing }
GLHModelImporter >> withCommitDiffs [

	^ withCommitDiffs
]

{ #category : #accessing }
GLHModelImporter >> withCommitDiffs: anObject [

	withCommitDiffs := anObject
]

{ #category : #accessing }
GLHModelImporter >> withFiles [
	^ withFiles
]

{ #category : #accessing }
GLHModelImporter >> withFiles: aBoolean [
	withFiles := aBoolean
]

{ #category : #accessing }
GLHModelImporter >> withInitialCommits: boolean [
	withInitialCommits := boolean 
]
