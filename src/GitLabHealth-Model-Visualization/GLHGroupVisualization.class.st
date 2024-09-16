Class {
	#name : 'GLHGroupVisualization',
	#superclass : 'MiAbstractVisualization',
	#instVars : [
		'noPipelineColor',
		'passingPipelineColor',
		'failingPipelinecolor'
	],
	#category : 'GitLabHealth-Model-Visualization',
	#package : 'GitLabHealth-Model-Visualization'
}

{ #category : 'running' }
GLHGroupVisualization >> createLegend [

	| legend |
	legend := RSLegend new.
	legend
		text: 'Repository with last pipeline passing'
		withBoxColor: self passingPipelineColor.
	legend
		text: 'Repository with last Pipeline failing'
		withBoxColor: self failingPipelinecolor.
	legend
		text: 'Repository without pipeline'
		withBoxColor: self noPipelineColor.

	legend legendDo: [ :l |
		l
			draggable;
			withBorder;
			padding: 20 ].
	legend location right middle.

	^ legend
]

{ #category : 'running' }
GLHGroupVisualization >> createShapeFor: project [

	| box inspect |

	box := RSBox new
		       size: 5;
		       model: project;
		       yourself.
	box color: (project lastPipeline
		ifNil: [ self noPipelineColor ]
		ifNotNil: [ :lastPipeline |
			(lastPipeline status = #success)
				ifTrue: [ Color green ]
				ifFalse: [ Color red ]
		]).

	inspect := RSInspectableInteraction new.
	inspect inspectShapeBlock: [ :proj |
		proj inspect.
		"block must return a Window :-("
		SystemWindow  new
	].
	box @ inspect.

	box @ (RSPopup text: [ :proj |
		String streamContents: [ :st | 
			st << proj name ;  cr ; << 'on: '.
			BasicDatePrinter default printYMD: proj lastPipelineDate withLeadingSpace: false on: st.
			st space.
			BasicDatePrinter default printHMS: proj lastPipelineDate separatedBy: $: on: st ] ]).

	^ box
]

{ #category : 'running' }
GLHGroupVisualization >> createShapes: aGLHGroup [

	^(aGLHGroup allToScope: GLHGroup) collect: [ :group || lbl projects composite |
		projects := (group projects sorted: [:a :b | a lastPipelineDate > b lastPipelineDate])
			collect: [ :project | self createShapeFor: project ]
			as: RSGroup.

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

{ #category : 'accessing' }
GLHGroupVisualization >> failingPipelinecolor [

	^ failingPipelinecolor
]

{ #category : 'accessing' }
GLHGroupVisualization >> failingPipelinecolor: anObject [

	failingPipelinecolor := anObject
]

{ #category : 'running' }
GLHGroupVisualization >> forGroup: aGLHGroups [

	| c shapes legend |
	c := RSCanvas new.

	shapes := aGLHGroups flatCollect: [ :group |
		          self createShapes: group ].
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

{ #category : 'initialization' }
GLHGroupVisualization >> initialize [

	super initialize.

	noPipelineColor := Color purple lighter.
	passingPipelineColor := Color green.
	failingPipelinecolor := Color red
]

{ #category : 'accessing' }
GLHGroupVisualization >> noPipelineColor [

	^ noPipelineColor
]

{ #category : 'accessing' }
GLHGroupVisualization >> noPipelineColor: anObject [

	noPipelineColor := anObject
]

{ #category : 'accessing' }
GLHGroupVisualization >> passingPipelineColor [

	^ passingPipelineColor
]

{ #category : 'accessing' }
GLHGroupVisualization >> passingPipelineColor: anObject [

	passingPipelineColor := anObject
]
