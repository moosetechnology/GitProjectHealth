Class {
	#name : #RSCommit,
	#superclass : #Object,
	#instVars : [
		'aCommit',
		'canvas'
	],
	#category : #'GitLabHealth-Visualization'
}

{ #category : #'as yet unclassified' }
RSCommit class >> canvasCompleteHierachyFor: aGLHCommit [

	^ self new
		  commit: aGLHCommit;
		  buildCommitCompleteHierachyCanvas 
]

{ #category : #'as yet unclassified' }
RSCommit class >> canvasDiffImpactFor: aGLHCommit [

	^ self new
		  commit: aGLHCommit;
		  buildCommitDiffFileImpact
]

{ #category : #'as yet unclassified' }
RSCommit class >> canvasHierarchyFor: aGLHCommit [

	^ self new
		  commit: aGLHCommit;
		  buildCommitHierachyCanvas
]

{ #category : #shape }
RSCommit >> allChildrenShapesFrom: aGLHCommit [

	| children sum |
	children := RSGroup new.
	sum := RSGroup new.

	
	children addAll: (aGLHCommit childCommits collect: [ :child |
			 self shapeForCommit: child ]).

	"^ children
	  ,
		  ((children collect: [ :commit |
			   self allChildrenShapesFrom: commit model ]) flattened)" 
	sum := ((children collect: [ :commit |
			   self allChildrenShapesFrom: commit model ]) flattened).
	
	^ children, sum . 
]

{ #category : #shape }
RSCommit >> allChildrenShapesFrom: aGLHCommit into: dic [

	| children sum |
	children := RSGroup new.
	sum := RSGroup new.

	children addAll: (aGLHCommit childCommits collect: [ :child |
			 dic at: child put: (self shapeForCommit: child withColor: self childColor) ]).

	(children do: [ :commit |
		 self allChildrenShapesFrom: commit model into: dic ]) flattened
]

{ #category : #canvas }
RSCommit >> buildCommitCompleteHierachyCanvas [

	| shapes parents children commitShape dic churnAnalyzer files2Commits shape2change allCommitShps |
	canvas := RSCanvas new.
	shapes := RSGroup new.
	parents := RSGroup new.
	children := RSGroup new.
	commitShape := RSGroup new.
	dic := Dictionary new.


	churnAnalyzer := GitAnalyzer new fromCommit: aCommit; maxChildCommit: 50.
	files2Commits := churnAnalyzer impactedFilesInFollowUpCommitsOf:
		                 aCommit.
	files2Commits := files2Commits select: [ :entry |
		                 entry value isNotNil ].

	commitShape add: (self shapeForCommit: aCommit).

	self allChildrenShapesFrom: aCommit into: dic.
	children addAll: dic values.

	shape2change := (children collect: [ :shape |
		                 ((files2Commits values collect: [ :group |
			                   group asDictionary
				                   at: shape model
				                   ifPresent: [ shape ] ]) reject: #isNil) asSet ])
		                flattened.

	shape2change do: [ :composite |
		(composite children select: [ :b | b class = RSBox ]) color:
			Color red ].

	parents addAll: (aCommit parentCommits collect: [ :c |
			 self shapeForCommit: c withColor: self parentColor ]).

	allCommitShps := parents , commitShape , children.

	allCommitShps do: [ :shp |
		| commit |
		commit := shp model.
		commit commitCreator = commitShape first model commitCreator
			ifTrue: [
				(shp children detect: [ :c | c class = RSBox ]) border:
					(RSBorder new
						 width: 5;
						 color: self defaultColor;
						 yourself) ] ].



	"canvas addAllShapes: commitShape , parents , children."
	self createLinesBetweenCommits: allCommitShps.

	canvas addAll: allCommitShps.
	RSHorizontalTreeLayout new on: canvas nodes.

	canvas @ RSCanvasController.

	^ canvas
]

{ #category : #canvas }
RSCommit >> buildCommitDiffFileImpact [

	| shapes |
	canvas := RSCanvas new.
	shapes := RSGroup new.


	aCommit diffsGroup do: [ :diff |
		shapes add:
			(RSCommitDiff new
				 shapeForDiffRange: diff
				 withColor: Color lightBlue) ].



	RSVerticalLineLayout  new
		gapSize: 5;
		on: shapes.


	canvas addAllShapes: shapes.
	canvas @ RSCanvasController.

	^ canvas
]

{ #category : #canvas }
RSCommit >> buildCommitHierachyCanvas [
	"build the commit graph from a starting root commit toward all of the descendants (children commit). Regardless of branches. Also display in red border the following commits that touch on the same files commited by the root commit. "

	| shapes parents children commitShape group |
	canvas := RSCanvas new.
	shapes := RSGroup new.
	parents := RSGroup new.
	children := RSGroup new.
	commitShape := RSGroup new.


	commitShape add: (self shapeForCommit: aCommit).

	children addAll: (aCommit childCommits collect: [ :c |
			 self shapeForCommit: c withColor: self childColor ]).

	RSVerticalLineLayout new
		alignCenter;
		gapSize: 100;
		on: children.

	parents addAll: (aCommit parentCommits collect: [ :c |
			 self shapeForCommit: c withColor: self parentColor ]).

	RSVerticalLineLayout new
		alignCenter;
		gapSize: 100;
		on: parents.

	"canvas addAllShapes: commitShape , parents , children."
	self createLinesBetweenCommits: commitShape , parents , children.

	group := RSGroup new
		         add: parents;
		         add: commitShape;
		         add: children;
		         yourself.

	RSHorizontalLineLayout new
		gapSize: 100;
		on: group.


	"canvas addShape: (RSComposite new
			 shapes: group;
			 updateConnectedLines;
			 yourself)."

	canvas addAll: commitShape , parents , children.
	self createLinesBetweenCommits: commitShape , parents , children.

	canvas @ RSCanvasController.

	^ canvas
]

{ #category : #shape }
RSCommit >> buildCompositeLayer: shapes withName: name withColor: color [

	| shapesCompo label boxGroup |
	boxGroup := RSGroup new.
	label := RSLabel new
		         text: name;
		         fontSize: 50;
		         bold;
		         yourself.

	RSVerticalLineLayout on: shapes.
	shapesCompo := RSComposite new
		               shapes: shapes;
		               yourself.
	"shapes do: [ :shp | canvas removeShape: shp ]."
	shapesCompo extent: shapesCompo extent + 5.

	"create the group for one class and its method"
	boxGroup
		add: label;
		add: shapesCompo.
	RSVerticalLineLayout new alignCenter on: boxGroup.

	^ RSComposite new
		  shapes: boxGroup;
		 " model: shapes;"
		  color: (color alpha: 0.1);
		  popup;
		  yourself
]

{ #category : #canvas }
RSCommit >> buildDiffCanvas [

	| shapes parents children commitShape group |
	canvas := RSCanvas new.
	shapes := RSGroup new.
	parents := RSGroup new.
	children := RSGroup new.
	commitShape := RSGroup new.

	commitShape add: (self shapeForCommit: aCommit).

	children addAll: (aCommit childCommits collect: [ :c |
			 self shapeForCommit: c withColor: self childColor ]).

	RSVerticalLineLayout new
		alignCenter;
		gapSize: 100;
		on: children.

	parents addAll: (aCommit parentCommits collect: [ :c |
			 self shapeForCommit: c withColor: self parentColor ]).

	RSVerticalLineLayout new
		alignCenter;
		gapSize: 100;
		on: parents.

	"canvas addAllShapes: commitShape , parents , children."
	self createLinesBetweenCommits: commitShape , parents , children.

	group := RSGroup new
		         add: parents;
		         add: commitShape;
		         add: children;
		         yourself.

	RSHorizontalLineLayout new
		gapSize: 100;
		on: group.



	"canvas addShape: (RSComposite new
			 shapes: group;
			 updateConnectedLines;
			 yourself)."

	canvas addAll: commitShape , parents , children.
	self createLinesBetweenCommits: commitShape , parents , children.

	canvas @ RSCanvasController.

	^ canvas
]

{ #category : #color }
RSCommit >> childColor [

	^ Color lightGreen
]

{ #category : #accessing }
RSCommit >> commit: aGLHCommit [
	aCommit := aGLHCommit 

]

{ #category : #color }
RSCommit >> commitColor [

	^ Color blue
]

{ #category : #shape }
RSCommit >> createChildrenGroupFor: aGLHCommit [ 
	|group|
	group := RSGroup new. 
	
	group add: ((aGLHCommit childCommits collect: [ :child |
		|children|
	children := RSGroup new. 
	
	children addAll: (child childCommits collect: [ :c |
			 self shapeForCommit: c withColor: self childColor ]).

	RSVerticalLineLayout new
		alignCenter;
		gapSize: 100;
		on: children.
		
		children 
		
		 ]) reject: #nil).

		
	^ group 
]

{ #category : #lines }
RSCommit >> createLinesBetweenCommits [

	(RSLineBuilder arrowedLine
		 withBorderAttachPoint;
		 color: (Color gray alpha: 0.9);
		 shapes: canvas shapes;
		canvas: canvas;
		 beDirectional;
		 connectToAll: [ :commit | commit childCommits ]) pushBack
]

{ #category : #lines }
RSCommit >> createLinesBetweenCommits: shapes [

	(RSLineBuilder arrowedLine
		withBorderAttachPoint;
		color: Color black;
		canvas: canvas;
		shapes: shapes;
		beDirectional;
		connectToAll: [ :commit | commit childCommits ]) pushFront 
]

{ #category : #color }
RSCommit >> defaultColor [

	^ Color lightOrange 
]

{ #category : #initialization }
RSCommit >> initialize [ 
	canvas := RSCanvas new.
	aCommit := GLHCommit new. 
]

{ #category : #color }
RSCommit >> parentColor [

	^ Color gray
]

{ #category : #shape }
RSCommit >> shapeForCommit: aGLHCommit [

	^ self shapeForCommit: aGLHCommit withColor: self defaultColor.
]

{ #category : #shape }
RSCommit >> shapeForCommit: aGLHCommit withColor: color [

	| box group labelTitle labelCommiter impactedFiles |
	group := RSGroup new.
	impactedFiles := RSGroup new.
	labelTitle := RSLabel new
		              text: (aGLHCommit name truncateWithElipsisTo: 40);
		              yourself.

	labelCommiter := RSLabel new
		                 text: 'by ',
			                 (aGLHCommit author_name truncateWithElipsisTo: 50);
		                 yourself.

	box := RSBox new
		       height: 50;
		       width: 60;
		       color: color.

	group
		add: labelTitle;
		add: box;
		add: labelCommiter.

	RSVerticalLineLayout new alignCenter on: group.

	^ RSComposite new
		  shapes: group;
		  model: aGLHCommit;
		  popup;
		  draggable;
		  yourself
]
