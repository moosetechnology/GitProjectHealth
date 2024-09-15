Class {
	#name : 'GHModelImporter',
	#superclass : 'GPModelImporter',
	#instVars : [
		'api',
		'glhModel'
	],
	#category : 'GitHubHealth-Model-Importer',
	#package : 'GitHubHealth-Model-Importer'
}

{ #category : 'accessing' }
GHModelImporter >> api [

	^ api
]

{ #category : 'accessing' }
GHModelImporter >> api: anObject [

	api := anObject
]

{ #category : 'api' }
GHModelImporter >> completeImportProject: aGLHProject [

	self importPipelinesOf: aGLHProject.
	self importBranchesOf: aGLHProject.
	self withCommitsSince ifNotNil: [ :withCommitSince | "If not nil, it means we have to import commit"
		self importCommitsOfProject: aGLHProject ]
]

{ #category : 'private' }
GHModelImporter >> convertApiFileAsFile: aAPIFile [

	aAPIFile type = 'dir' ifTrue: [ 
		^ GLHFileDirectory new
			  name: aAPIFile name;
			  yourself ].
	^ GLHFileBlob new
		  name: aAPIFile name;
		  yourself
]

{ #category : 'accessing' }
GHModelImporter >> glhModel [

	^ glhModel
]

{ #category : 'accessing' }
GHModelImporter >> glhModel: anObject [

	glhModel := anObject
]

{ #category : 'api' }
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

{ #category : 'api' }
GHModelImporter >> importCommitsOfProject: aGLHProject [

	| commitsResult commits |
	commitsResult := self api
		                 commitsOfProject: aGLHProject name
		                 ofOrganization: aGLHProject group name.
	commits := self parseCommitsResult: commitsResult.
	"add the imported commits (unless they are already added to this repository)"
	aGLHProject repository commits
		addAll: commits
		unless: [ :existing :new | existing id = new id ].
	"add the imported commits to the model unles they are already added to the model"
	^ self glhModel
		  addAll: commits
		  unless: [ :existing :new | existing id = new id ]
]

{ #category : 'api' }
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

{ #category : 'api' }
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

{ #category : 'api' }
GHModelImporter >> importGroup: aGroupName [

	| result groupResult |
	result := self api organization: aGroupName.
	groupResult := self parseGroupResult: result.
	self glhModel add: groupResult.
	self importRepositoriesOfGroup: groupResult.
	^ groupResult
]

{ #category : 'api' }
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

{ #category : 'api' }
GHModelImporter >> importRepositoriesOfGroup: groupResult [

	| reposResult |
	reposResult := self api reposOfOrganization: groupResult name.
	groupResult projects addAll: (self parseArrayOfProject: reposResult).
	self glhModel addAll: groupResult projects.
	groupResult projects do: [ :project |
		self completeImportProject: project ].
	^ groupResult
]

{ #category : 'initialization' }
GHModelImporter >> initialize [

	super initialize.
	self api: GHApi new.
	withFiles := false
]

{ #category : 'private' }
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

{ #category : 'private' }
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

{ #category : 'parsing' }
GHModelImporter >> parseCommitsResult: result [

	| reader |
	reader := NeoJSONReader on: result readStream.

	reader for: GLHCommit do: [ :mapping |
		mapping mapInstVar: #id to: #sha.
		mapping mapInstVar: #web_url to: #html_url.
		mapping
			mapProperty: #commit
			getter: [ :object | #ignore ]
			setter: [ :glhCommit :value |
			glhCommit message: (value at: #message) ].
		(mapping mapInstVar: #parent_ids) valueSchema: #ArrayOfIds ].

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

{ #category : 'private' }
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

{ #category : 'private' }
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

{ #category : 'private' }
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

{ #category : 'api' }
GHModelImporter >> privateToken [
	^ self api privateToken
]

{ #category : 'api' }
GHModelImporter >> privateToken: aTokenString [
	^ self api privateToken: aTokenString
]
