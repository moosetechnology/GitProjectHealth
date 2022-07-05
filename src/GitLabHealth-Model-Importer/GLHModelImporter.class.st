Class {
	#name : #GLHModelImporter,
	#superclass : #Object,
	#instVars : [
		'glhModel',
		'glhApi',
		'withFiles'
	],
	#category : #'GitLabHealth-Model-Importer'
}

{ #category : #private }
GLHModelImporter >> addGroupResultToModel: groupResult [

	self glhModel add: groupResult.
	self glhModel addAll: groupResult projects
]

{ #category : #accessing }
GLHModelImporter >> beWithFiles [
	withFiles := true
]

{ #category : #accessing }
GLHModelImporter >> beWithouFiles [
	withFiles := false
]

{ #category : #api }
GLHModelImporter >> completeImportProject: aGLHProject [

	('Complete import project: ' , aGLHProject id printString) recordInfo.
	(self pipelinesOf: aGLHProject id) do: [ :pipeline | 
		self glhModel add: pipeline.
		aGLHProject addPipeline: pipeline ].
	aGLHProject creator: (self importUser: aGLHProject creator_id).
	aGLHProject repository: GLHRepository new.
	self glhModel add: aGLHProject repository.
	self importRepository: aGLHProject repository.
	self importCommits: aGLHProject
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

{ #category : #api }
GLHModelImporter >> importCommits: aGLHProject [

	| results parsedResults |
	results := self glhApi commitsOfProject: aGLHProject id.
	parsedResults := self parseCommitsResult: results.
	aGLHProject repository commits addAll: parsedResults
]

{ #category : #api }
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

{ #category : #api }
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
	groupResult projects do: [ :project | 
		self completeImportProject: project ].
	self addGroupResultToModel: groupResult.
	(self subGroupsOf: aGroupID) do: [ :subGroup | 
		groupResult addSubGroup: (self importGroup: subGroup id) ].
	^ groupResult
]

{ #category : #api }
GLHModelImporter >> importRepository: aGLHRepository [

	| resultBranches branches |
	[ 
	resultBranches := self glhApi branchesOfRepository:
		                  aGLHRepository project id.
	branches := self parseBranchesResult: resultBranches.
	branches do: [ :branch | aGLHRepository addBranch: branch ].
	self withFiles ifTrue: [ 
		branches do: [ :branch | self importFilesOfBranch: branch ] ] ]
		on: NeoJSONParseError
		do: [ 
		self inform: aGLHRepository project name , ' has no repository' ]
]

{ #category : #api }
GLHModelImporter >> importUser: aUserID [

	| result userResult |
	(glhModel allWithType: GLHUser) detect: [ :user | user id = aUserID ] ifFound: [ :user | ^ user ].
	('Import user: ' , aUserID printString) recordInfo.
	result := self glhApi user: aUserID.
	userResult := self parseUserResult: result.
	glhModel add: userResult.
	^ userResult
]

{ #category : #api }
GLHModelImporter >> initialize [
	withFiles := false
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
GLHModelImporter >> parseCommitsResult: result [

	| reader |
	reader := NeoJSONReader on: result readStream.
	reader for: GLHCommit do: [ :mapping | 
		mapping mapInstVars:
			#( id short_id title author_name author_email committer_name
			   committer_email message web_url ).
		(mapping mapInstVar: #authored_date) valueSchema: DateAndTime.
		(mapping mapInstVar: #committed_date) valueSchema: DateAndTime.
		(mapping mapInstVar: #created_at) valueSchema: DateAndTime ].

	reader for: DateAndTime customDo: [ :mapping | 
		mapping decoder: [ :string | DateAndTime fromString: string ] ].
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
GLHModelImporter >> parsePipelinesResult: result [

	| reader |
	reader := NeoJSONReader on: result readStream.
	reader mapInstVarsFor: GLHPipeline.
	reader
		for: #ArrayOfPipelines
		customDo: [ :customMappting | 
		customMappting listOfElementSchema: GLHPipeline ].
	^ reader nextAs: #ArrayOfPipelines
]

{ #category : #private }
GLHModelImporter >> parseSubGroupResult: aResult [

	| reader |
	reader := NeoJSONReader on: aResult readStream.
	reader mapInstVarsFor: GLHGroup.
	reader
		for: #ArrayOfGroups
		customDo: [ :customMappting | 
		customMappting listOfElementSchema: GLHGroup ].
	^ reader nextAs: #ArrayOfGroups
]

{ #category : #private }
GLHModelImporter >> parseUserResult: result [

	| reader |
	reader := NeoJSONReader on: result readStream.
	reader mapInstVarsFor: GLHUser.
	^ reader nextAs: GLHUser
]

{ #category : #api }
GLHModelImporter >> pipelinesOf: aProjectID [

	| result |
	('Search pipelines of: ' , aProjectID printString) recordInfo.
	result := self glhApi pipelinesOfProject: aProjectID.
	^ self parsePipelinesResult: result
]

{ #category : #api }
GLHModelImporter >> subGroupsOf: aGroupID [

	| results parsedResult result page |
	('Search subgroup of: ' , aGroupID printString) recordInfo.
	results := OrderedCollection new.
	page := 1.
	result := self glhApi subgroupsOfGroup: aGroupID page: page.
	parsedResult := self parseSubGroupResult: result.
	results addAll: parsedResult.
	[ parsedResult size = 20 ] whileTrue: [ 
		page := page + 1.
		result := self glhApi subgroupsOfGroup: aGroupID page: page.
		parsedResult := self parseSubGroupResult: result.
		results addAll: parsedResult ].
	^ results
]

{ #category : #accessing }
GLHModelImporter >> withFiles [
	^ withFiles
]

{ #category : #accessing }
GLHModelImporter >> withFiles: aBoolean [
	withFiles := aBoolean
]
