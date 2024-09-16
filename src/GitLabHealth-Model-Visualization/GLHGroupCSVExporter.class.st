Class {
	#name : 'GLHGroupCSVExporter',
	#superclass : 'MiAbstractVisualization',
	#category : 'GitLabHealth-Model-Visualization',
	#package : 'GitLabHealth-Model-Visualization'
}

{ #category : 'running' }
GLHGroupCSVExporter >> forGroup: aGLHGroup [
	^String streamContents: [ :output |
		self headerLineOn: output.
		self forGroup: aGLHGroup on: output ]
]

{ #category : 'running' }
GLHGroupCSVExporter >> forGroup: aGLHGroup on: outputStream [

	(aGLHGroup allToScope: GLHGroup) do: [ :group |
			group projects do: [ :project |
				self forProject: project inGroup: aGLHGroup onStream: outputStream ]
	]
]

{ #category : 'running' }
GLHGroupCSVExporter >> forProject: aGHLProject inGroup: aGLHGroup onStream: outputStream [

	outputStream
		<< $" ;
		<< aGLHGroup name ;
		<< '","' ;
		<< aGHLProject name ;
		<< '","' ;
		<< (self pipelineResult: aGHLProject) ;
		<< '",' ;
		<< aGHLProject lastPipelineDate asDate ddmmyyyy ;
		cr
]

{ #category : 'running' }
GLHGroupCSVExporter >> headerLineOn: outputStream [

	outputStream
		<< '"Group","Project","CI result","Date"' ;
		cr
]

{ #category : 'running' }
GLHGroupCSVExporter >> pipelineResult: aGHLProject [

	^aGHLProject lastPipeline
		ifNil: [ #noCI ]
		ifNotNil: [ :lastPipeline |
			(lastPipeline status = #success)
				ifTrue: [ #passed ]
				ifFalse: [ #failed ]
		]

]
