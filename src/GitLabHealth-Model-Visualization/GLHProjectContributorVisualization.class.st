Class {
	#name : #GLHProjectContributorVisualization,
	#superclass : #MiAbstractVisualization,
	#instVars : [
		'fakeUserColor',
		'userColor'
	],
	#category : #'GitLabHealth-Model-Visualization'
}

{ #category : #private }
GLHProjectContributorVisualization >> createLegend [

	| legend |
	legend := RSLegend new.
	legend
		text: 'fake user'
		withBoxColor: self fakeUserColor .
	legend
		text: 'real user'
		withBoxColor: self userColor .
	

	legend legendDo: [ :l |
		l
			draggable;
			withBorder;
			padding: 20 ].
	legend location right middle.

	^ legend
]

{ #category : #'as yet unclassified' }
GLHProjectContributorVisualization >> createShapeForProject: aProject [
	
		| box inspect |

	box := RSBox new
		       size: 5;
		       model: aProject;
		       yourself.
	box color: Color lightBlue .

	inspect := RSInspectableInteraction new.
	inspect inspectShapeBlock: [ :user |
		user inspect.
		"block must return a Window :-("
		SystemWindow  new
	].
	box @ inspect.

	box @ (RSPopup text: [ :user |
		String streamContents: [ :st | 
			 ] ]).

	^ box
]

{ #category : #'as yet unclassified' }
GLHProjectContributorVisualization >> createShapeForUser: aUser [
	
		| box inspect rsGroup|
		
	box := RSBox new
		       size: 10;
		       model: aUser;
		       yourself.
	box color: (aUser id
		ifNil: [ self fakeUserColor  ]
		ifNotNil: [ self userColor.]).
		

	inspect := RSInspectableInteraction new.
	inspect inspectShapeBlock: [ :user |
		user inspect.
		"block must return a Window :-("
		SystemWindow  new
	].
	box @ inspect.

	box @ (RSPopup text: [ :user |
		String streamContents: [ :st | 
			st << user name"; << 'id: ' ; << (user id ifNil: ['-'])".
			 ] ]).

	rsGroup := RSGroup new add: box; yourself.
		rsGroup add: (RSLabel new text: aUser name; yourself ). 
		
	RSHorizontalLineLayout new alignMiddle  on: rsGroup.

	^ RSComposite new
		  shapes: rsGroup;
		  model: aUser;

		  yourself
]

{ #category : #accessing }
GLHProjectContributorVisualization >> fakeUserColor [
	^ Color lightGray
]

{ #category : #'as yet unclassified' }
GLHProjectContributorVisualization >> forProject: aGLHProject [
	
	| c shapes legend |
	c := RSCanvas new.

	shapes := ((aGLHProject toScope: GLHCommit) collect: #commitCreator) asSet collect: [:author | self createShapeForUser: author ].
"	shapes add: (self createShapeForProject: aGLHProject )."

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
		connectFrom: [  ].
	RSHorizontalVanDerPloegTreeLayout new on: c nodes.

	legend := self createLegend.
	legend container: c.
	legend build.

	^ c
]

{ #category : #initialization }
GLHProjectContributorVisualization >> initialize [

	super initialize.

	fakeUserColor := Color purple lighter.
	userColor  := Color green.

]

{ #category : #accessing }
GLHProjectContributorVisualization >> userColor [
	^ Color lightGreen 
]
