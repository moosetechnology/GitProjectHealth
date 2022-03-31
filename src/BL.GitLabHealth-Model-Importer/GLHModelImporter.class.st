Class {
	#name : #GLHModelImporter,
	#superclass : #Object,
	#instVars : [
		'glhModel',
		'baseAPIUrl',
		'privateToken'
	],
	#category : #'BL.GitLabHealth-Model-Importer'
}

{ #category : #private }
GLHModelImporter >> addGroupResultToModel: groupResult [

	self glhModel add: groupResult.
	self glhModel addAll: groupResult projects
]

{ #category : #accessing }
GLHModelImporter >> baseAPIUrl [

	^ baseAPIUrl
]

{ #category : #accessing }
GLHModelImporter >> baseAPIUrl: anObject [

	baseAPIUrl := anObject
]

{ #category : #api }
GLHModelImporter >> completeImportProject: aGLHProject [

	('Complete import project: ' , aGLHProject id printString) recordInfo.
	(self pipelinesOf: aGLHProject id) do: [ :pipeline | 
		aGLHProject addPipeline: pipeline ]
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
GLHModelImporter >> importGroup: aGroupID [

	| result groupResult |
	('Import group: ' , aGroupID printString) recordInfo.
	result := ZnClient new
		          accept: ZnMimeType applicationJson;
		          headerAt: #'PRIVATE-TOKEN' add: self privateToken;
		          get: self baseAPIUrl , '/groups/' , aGroupID printString.
	groupResult := self parseGroupResult: result.
	groupResult projects do: [ :project | self completeImportProject: project ].
	self addGroupResultToModel: groupResult.
	(self subGroupsOf: aGroupID) do: [ :subGroup | 
		groupResult addSubGroup: (self importGroup: subGroup id) ].
	^ groupResult
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

{ #category : #api }
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

{ #category : #api }
GLHModelImporter >> pipelinesOf: aProjectID [

	| result |
	('Search pipelines of: ' , aProjectID printString) recordInfo.
	result := ZnClient new
		          accept: ZnMimeType applicationJson;
		          headerAt: #'PRIVATE-TOKEN' add: self privateToken;
		          get:
			          self baseAPIUrl , '/projects/' , aProjectID printString
			          , '/pipelines'.
	^ self parsePipelinesResult: result
]

{ #category : #accessing }
GLHModelImporter >> privateToken [

	^ privateToken
]

{ #category : #accessing }
GLHModelImporter >> privateToken: anObject [

	privateToken := anObject
]

{ #category : #api }
GLHModelImporter >> subGroupsOf: aGroupID [

	| result |
	('Search subgroup of: ' , aGroupID printString) recordInfo.
	result := ZnClient new
		          accept: ZnMimeType applicationJson;
		          headerAt: #'PRIVATE-TOKEN' add: self privateToken;
		          get:
			          self baseAPIUrl , '/groups/' , aGroupID printString
			          , '/subgroups'.
	^ self parseSubGroupResult: result
]
