Extension { #name : 'GLHProject' }

{ #category : '*GitLabHealth-Model-Visualization' }
GLHProject >> lastPipeline [

	^self
		attributeAt: #lastPipeline
		ifAbsentPut: [ pipelines
			ifEmpty: [ nil ]
			ifNotEmpty: [
				(pipelines asOrderedCollection sort: [ :a :b | a runDate > b runDate])
				first
			]
		]
]

{ #category : '*GitLabHealth-Model-Visualization' }
GLHProject >> lastPipelineDate [

	^self
		attributeAt: #lastPipelineDate
		ifAbsentPut: [
			self lastPipeline
				ifNil: [ DateAndTime now ]
				ifNotNil: [ :lastPipeline |
					lastPipeline runDate
						ifNil: [ DateAndTime now ]
						ifNotNil: [ :date | date ]
			]
		]
]
