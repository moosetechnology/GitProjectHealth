Class {
	#name : #GHModelImporter,
	#superclass : #Object,
	#instVars : [
		'api',
		'glhModel'
	],
	#category : #'BL-GitHubHealth-Model-Importer'
}

{ #category : #accessing }
GHModelImporter >> api [

	^ api
]

{ #category : #accessing }
GHModelImporter >> api: anObject [

	api := anObject
]

{ #category : #accessing }
GHModelImporter >> glhModel [

	^ glhModel
]

{ #category : #accessing }
GHModelImporter >> glhModel: anObject [

	glhModel := anObject
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

	| reposResult |
	reposResult := self api reposOfOrganization: groupResult name.
	groupResult projects addAll: (self parseArrayOfProject: reposResult).
	self glhModel addAll: groupResult projects.
	groupResult projects do: [ :project | 
		self importPipelinesOf: project ].
	^ groupResult
]

{ #category : #initialization }
GHModelImporter >> initialize [
	super initialize.
	self api: GHApi new.
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
	reader
		for: GLHPipeline
		do: [ :mapping | mapping mapInstVar: #status to: #conclusion ].
	^ reader nextAs: GHAPIPipelineOverview
]

{ #category : #api }
GHModelImporter >> privateToken [
	^ self api privateToken
]

{ #category : #api }
GHModelImporter >> privateToken: aTokenString [
	^ self api privateToken: aTokenString
]
