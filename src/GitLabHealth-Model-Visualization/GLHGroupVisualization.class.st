Class {
	#name : #GLHGroupVisualization,
	#superclass : #MiAbstractVisualization,
	#instVars : [
		'noPipelineColor',
		'passingPipelineColor',
		'failingPipelinecolor'
	],
	#category : #'GitLabHealth-Model-Visualization'
}

{ #category : #running }
GLHGroupVisualization >> createLegend [

	| legend |
	legend := RSLegend new.
	legend
		text: 'Repository with last Green Pipeline'
		withBoxColor: Color green.
	legend
		text: 'Repository without Pipeline or last red Pipeline'
		withBoxColor: Color red.
	legend legendDo: [ :l |
		l
			draggable;
			withBorder;
			padding: 20 ].
	legend location right middle.

	^ legend
]

{ #category : #running }
GLHGroupVisualization >> createShapeFor: project [

	| box |
	box := RSBox new
		       size: 5;
		       model: project;
		       yourself.
	(project pipelines isNotEmpty and: [
		 project pipelines last status = #success ])
		ifTrue: [ box color: Color green ]
		ifFalse: [ box color: Color red ].
	^ box
]

{ #category : #running }
GLHGroupVisualization >> createShapes: aGLHGroup [

	^(aGLHGroup allToScope: GLHGroup) collect: [ :group || lbl projects composite |
		projects := group projects
			collect: [ :project | self createShapeFor: project ]
			as: RSGroup.

		projects @ (RSPopup text: #name).
		RSGridLayout on: projects.
		lbl := RSLabel new
			         text: group name;
			         color: Color white;
			         yourself.

		RSLocation new
			above;
			move: lbl on: projects.
		composite := RSComposite new.
		composite @ RSAnimatedPopup @ RSDraggable.

		composite
			color: Color gray;
			model: group;
			shapes: projects , { lbl }.
		composite padding: 10.
		composite
	]
]

{ #category : #accessing }
GLHGroupVisualization >> failingPipelinecolor [

	^ failingPipelinecolor
]

{ #category : #accessing }
GLHGroupVisualization >> failingPipelinecolor: anObject [

	failingPipelinecolor := anObject
]

{ #category : #running }
GLHGroupVisualization >> forGroup: aGLHGroup [

	| c shapes legend |
	c := RSCanvas new.

	shapes := self createShapes: aGLHGroup.
	c addAll: shapes.

	c @ RSCanvasController.
	RSLineBuilder orthoHorizontal
		markerEnd: (RSMarker new
				 offset: 2;
				 shape: (RSShapeFactory triangle
						  color: Color black;
						  size: 5;
						  yourself));
		attachPoint: RSHorizontalAttachPoint new;
		canvas: c;
		shapes: c nodes;
		connectFrom: #group.
	RSHorizontalVanDerPloegTreeLayout new on: c nodes.

	legend := self createLegend.
	legend container: c.
	legend build.

	^ c
]

{ #category : #initialization }
GLHGroupVisualization >> initialize [

	super initialize.

	noPipelineColor := Color purple.
	passingPipelineColor := Color green.
	failingPipelinecolor := Color red
]

{ #category : #accessing }
GLHGroupVisualization >> noPipelineColor [

	^ noPipelineColor
]

{ #category : #accessing }
GLHGroupVisualization >> noPipelineColor: anObject [

	noPipelineColor := anObject
]

{ #category : #accessing }
GLHGroupVisualization >> passingPipelineColor [

	^ passingPipelineColor
]

{ #category : #accessing }
GLHGroupVisualization >> passingPipelineColor: anObject [

	passingPipelineColor := anObject
]
