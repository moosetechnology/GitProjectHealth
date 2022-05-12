Class {
	#name : #GLHModelImporter,
	#superclass : #Object,
	#instVars : [
		'glhModel',
		'glhApi'
	],
	#category : #'BL-GitLabHealth-Model-Importer'
}

{ #category : #private }
GLHModelImporter >> addGroupResultToModel: groupResult [

	self glhModel add: groupResult.
	self glhModel addAll: groupResult projects
]

{ #category : #api }
GLHModelImporter >> completeImportProject: aGLHProject [

	('Complete import project: ' , aGLHProject id printString) recordInfo.
	(self pipelinesOf: aGLHProject id) do: [ :pipeline | 
		aGLHProject addPipeline: pipeline ].
	aGLHProject creator: (self importUser: aGLHProject creator_id)
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
GLHModelImporter >> importUser: aUserID [

	| result userResult |
	(glhModel allWithType: GLHUser) detect: [ :user | user id = aUserID ] ifFound: [ :user | ^ user ].
	('Import user: ' , aUserID printString) recordInfo.
	result := self glhApi user: aUserID.
	userResult := self parseUserResult: result.
	glhModel add: userResult.
	^ userResult
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

	| result |
	('Search subgroup of: ' , aGroupID printString) recordInfo.
	result := self glhApi subgroupsOfGroup: aGroupID.
	^ self parseSubGroupResult: result
]
