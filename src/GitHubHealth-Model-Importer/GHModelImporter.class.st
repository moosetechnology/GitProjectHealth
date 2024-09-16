Class {
	#name : #GHModelImporter,
	#superclass : #GPModelImporter,
	#instVars : [
		'api'
	],
	#category : 'GitHubHealth-Model-Importer'
}

{ #category : #accessing }
GHModelImporter >> api [

	^ api
]

{ #category : #accessing }
GHModelImporter >> api: anObject [

	api := anObject
]

{ #category : #api }
GHModelImporter >> completeImportProject: aGLHProject [

	self importPipelinesOf: aGLHProject.
	self importBranchesOf: aGLHProject.
	self withCommitsSince ifNotNil: [ :withCommitSince | "If not nil, it means we have to import commit"
		| commits |
		commits := self importCommitsOfProject: aGLHProject.
		self chainsCommitsFrom: commits ]
]

{ #category : #private }
GHModelImporter >> convertApiFileAsFile: aAPIFile [

	aAPIFile type = 'dir' ifTrue: [ 
		^ GLHFileDirectory new
			  name: aAPIFile name;
			  yourself ].
	^ GLHFileBlob new
		  name: aAPIFile name;
		  yourself
]

{ #category : #api }
GHModelImporter >> importBranchesOf: project [

	"add the pipeline (actions runs) in the project"

	| branchesResult branches repository |
	branchesResult := self api
		                  branchesOfRepo: project name
		                  ofOrganization: project group name.
	branches := self parseBranchesResult: branchesResult.
	self glhModel addAll: branches.
	repository := GLHRepository new.
	self glhModel add: repository.
	project repository: repository.
	branches do: [ :branch | 
		repository addBranch: branch.
		self withFiles ifTrue: [ self importFilesOfBranch: branch ] ]
]

{ #category : #api }
GHModelImporter >> importCommitsOfProject: aGLHProject [

	| itemByPage foundCommits tmp pageNumber |
	itemByPage := 100.
	pageNumber := 1.
	('Extract all commits of ' , aGLHProject name) recordInfo.
	foundCommits := OrderedCollection new.
	('Extract commits from ' , foundCommits size printString , ' to '
	 , (foundCommits size + itemByPage) printString) recordInfo.
	"also check that there is at least one commit with the error handling"
	[
	tmp := self parseCommitsResult: (self api
			        commitsOfProject: aGLHProject name
			        ofOrganization: aGLHProject group name
			        since: self withCommitsSince
			        perPage: itemByPage
			        page: pageNumber) ]
		on: GHRepositoryEmptyError
		do: [ ^ {  } ].

	foundCommits addAll: tmp.
	[ tmp size = itemByPage ] whileTrue: [
		pageNumber := pageNumber + 1.
		('Extract issues from ' , foundCommits size printString , ' to '
		 , (foundCommits size + itemByPage) printString) recordInfo.
		tmp := self parseCommitsResult: (self api
				        commitsOfProject: aGLHProject name
				        ofOrganization: aGLHProject group name
				        since: self withCommitsSince
				        perPage: itemByPage
				        page: pageNumber).
		foundCommits addAll: tmp ].

	"add the imported commits (unless they are already added to this repository)"
	aGLHProject repository commits
		addAll: foundCommits
		unless: [ :existing :new | existing id = new id ].
	"add the imported commits to the model unles they are already added to the model"
	^ self glhModel
		  addAll: foundCommits
		  unless: [ :existing :new | existing id = new id ]
]

{ #category : #api }
GHModelImporter >> importDirectoryFiles: aDirectoryFile OfBranch: aBranch [

	| result files apiFiles |
	('Explore ' , aDirectoryFile name) recordInfo.
	result := self api
		          contentsOfRepo: aBranch repository project name
		          ofOrganization: aBranch repository project group name
		          inBranch: aBranch name
		          withPath: aDirectoryFile path.
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

{ #category : #api }
GHModelImporter >> importFilesOfBranch: aBranch [

	| result files apiFiles |
	result := self api
		          contentsOfRepo: aBranch repository project name
		          ofOrganization: aBranch repository project group name
		          inBranch: aBranch name
		          withPath: nil.
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
GHModelImporter >> importGroup: aGroupName [

	| result groupResult |
	result := self api organization: aGroupName.
	groupResult := self parseGroupResult: result.
	self glhModel add: groupResult.
	self importRepositoriesOfGroup: groupResult.
	^ groupResult
]

{ #category : #api }
GHModelImporter >> importPipelinesOf: project [

	"add the pipeline (actions runs) in the project"

	| pipelinesResult ghApiPipelineOverview |
	pipelinesResult := self api
		                   actionsRunOfRepo: project name
		                   ofOrganization: project group name.
	ghApiPipelineOverview := self parsePipelinesResult: pipelinesResult.
	ghApiPipelineOverview workflow_runs do: [ :pipeline | 
		project addPipeline: pipeline ]
]

{ #category : #api }
GHModelImporter >> importRepositoriesOfGroup: groupResult [

	| reposResult itemByPage pageNumber reposFound tmp |
	itemByPage := 100.
	pageNumber := 1.
	('Extract all repository of ' , groupResult name) recordInfo.
	reposFound := OrderedCollection new.
	('Extract commits from ' , reposFound size printString , ' to '
	 , (reposFound size + itemByPage) printString) recordInfo.
	tmp := self parseArrayOfProject: (self api
			        reposOfOrganization: groupResult name
			        perPage: itemByPage
			        page: pageNumber).

	reposFound addAll: tmp.
	[ tmp size = itemByPage ] whileTrue: [
		pageNumber := pageNumber + 1.
		('Extract issues from ' , reposFound size printString , ' to '
		 , (reposFound size + itemByPage) printString) recordInfo.
		tmp := self parseArrayOfProject: (self api
				        reposOfOrganization: groupResult name
				        perPage: itemByPage
				        page: pageNumber).
		reposFound addAll: tmp ].

	reposResult := self api reposOfOrganization: groupResult name.
	groupResult projects addAll: reposFound.
	self glhModel addAll: groupResult projects.
	groupResult projects do: [ :project |
		self completeImportProject: project ].
	^ groupResult
]

{ #category : #api }
GHModelImporter >> importUser: userID [

	| result userResult |
	(glhModel allWithType: GLHUser)
		detect: [ :user | user id = userID ]
		ifFound: [ :user | ^ user ].
	('Import user: ' , userID printString) recordInfo.
	result := self api user: userID.
	userResult := self parseUserResult: result.
	^ glhModel
		  add: userResult
		  unless: [ :current :new | current id = new id ]
]

{ #category : #initialization }
GHModelImporter >> initialize [

	super initialize.
	self api: GHApi new.
	withFiles := false
]

{ #category : #private }
GHModelImporter >> parseArrayOfProject: arrayOfProjects [

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
GHModelImporter >> parseBranchesResult: arrayOfBranch [

	| reader |
	reader := NeoJSONReader on: arrayOfBranch readStream.
	reader mapInstVarsFor: GLHBranch.
	reader
		for: #ArrayOfBranch
		customDo: [ :customMappting | 
		customMappting listOfElementSchema: GLHBranch ].
	^ reader nextAs: #ArrayOfBranch
]

{ #category : #parsing }
GHModelImporter >> parseCommitsResult: result [

	| reader |
	(result includesSubstring: '"status":"409"') ifTrue: [
		GHRepositoryEmptyError signal: 'Git Repository is empty' ].
	reader := NeoJSONReader on: result readStream.

	reader for: GLHCommit do: [ :mapping |
		mapping mapInstVar: #id to: #sha.
		mapping mapInstVar: #web_url to: #html_url.
		mapping
			mapProperty: #commit
			getter: [ :object | #ignore ]
			setter: [ :glhCommit :value |
				glhCommit message: (value at: #message).
				glhCommit authored_date:
					(DateAndTime fromString: (value at: #author at: #date)).
				glhCommit committed_date:
					(DateAndTime fromString: (value at: #committer at: #date)) ].

		mapping
			mapProperty: #author
			getter: [ :object | #ignore ]
			setter: [ :glhCommit :value |
				value ifNotNil: [
					glhCommit author_name: (value at: #login).
					value
						at: #id
						ifPresent: [ :authorId |
						glhCommit commitCreator: (self importUser: authorId) ] ] ].

		mapping
			mapProperty: #committer
			getter: [ :object | #ignore ]
			setter: [ :glhCommit :value |
				value ifNotNil: [ glhCommit committer_name: (value at: #login) ] ].

		(mapping mapInstVar: #parent_ids to: #parents) valueSchema:
			#ArrayOfIds ].

	reader for: DateAndTime customDo: [ :mapping |
		mapping decoder: [ :string | DateAndTime fromString: string ] ].

	reader for: #ArrayOfIds customDo: [ :mapping |
		mapping decoder: [ :parents |
			parents collect: [ :parent | parent at: #sha ] ] ].

	reader
		for: #ArrayOfCommit
		customDo: [ :customMappting |
		customMappting listOfElementSchema: GLHCommit ].

	^ reader nextAs: #ArrayOfCommit
]

{ #category : #private }
GHModelImporter >> parseFileTreeResult: aResult [

	| reader |
	reader := NeoJSONReader on: aResult readStream.
	reader mapInstVarsFor: GHApiFile.
	reader
		for: #ArrayOfFile
		customDo: [ :customMappting | 
		customMappting listOfElementSchema: GHApiFile ].
	^ reader nextAs: #ArrayOfFile
]

{ #category : #private }
GHModelImporter >> parseGroupResult: aResult [

	| reader |
	reader := NeoJSONReader on: aResult readStream.
	reader for: GLHGroup do: [ :mapping | 
		mapping mapInstVar: #name to: #login.
		mapping mapInstVar: #description to: #description.
		mapping mapInstVar: #id to: #id.
		mapping mapInstVar: #web_url to: #html_url ].
	^ reader nextAs: GLHGroup
]

{ #category : #private }
GHModelImporter >> parsePipelinesResult: pipelineOverview [

	| reader |
	reader := NeoJSONReader on: pipelineOverview readStream.
	reader for: GHAPIPipelineOverview do: [ :mapping |
		mapping mapInstVar: #total_count to: #total_count.
		(mapping mapInstVar: #workflow_runs) valueSchema: #ArrayOfPipelines ].
	reader
		for: #ArrayOfPipelines
		customDo: [ :customMappting |
		customMappting listOfElementSchema: GLHPipeline ].
	reader for: GLHPipeline do: [ :mapping |
		mapping
			mapInstVar: #status to: #conclusion;
			mapProperty: #run_started_at
			getter: [ :object | #ignore ]
			setter: [ :object :value |
				object runDate: (DateAndTime fromString: value) ] ].
	^ reader nextAs: GHAPIPipelineOverview
]

{ #category : #parsing }
GHModelImporter >> parseUserResult: result [

	| reader |
	reader := NeoJSONReader on: result readStream.
	reader for: GLHUser do: [ :mapping |
		mapping mapInstVar: #id to: #id.
		mapping mapInstVar: #public_email to: #email.
		mapping mapInstVar: #username to: #login.
		mapping mapInstVar: #bio to: #bio.
		mapping mapInstVar: #organization to: #company.
		mapping mapInstVar: #followers to: #followers.
		mapping mapInstVar: #following to: #following.
		mapping mapInstVar: #web_url to: #html_url.
		mapping mapInstVar: #name to: #name.
		mapping mapInstVar: #avatar_url to: #avatar_url ].
	^ reader nextAs: GLHUser
]

{ #category : #api }
GHModelImporter >> privateToken [
	^ self api privateToken
]

{ #category : #api }
GHModelImporter >> privateToken: aTokenString [
	^ self api privateToken: aTokenString
]
