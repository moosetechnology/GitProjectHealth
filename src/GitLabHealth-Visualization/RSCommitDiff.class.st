Class {
	#name : #RSCommitDiff,
	#superclass : #Object,
	#instVars : [
		'aDiff',
		'canvas'
	],
	#category : #'GitLabHealth-Visualization'
}

{ #category : #'as yet unclassified' }
RSCommitDiff class >> canvasFor: aGLHDiff [

	^ self new
		  diffCommit: aGLHDiff;
		  buildCanvas
]

{ #category : #hooks }
RSCommitDiff class >> shapeFor: aCommitDiff [
	^ self new
		  diffCommit: aCommitDiff;
		  shapeForDiff: aCommitDiff  withColor: Color gray. 

	
]

{ #category : #canvas }
RSCommitDiff >> buildCanvas [

	| shapes |
	self
		deprecated: 'Use #build instead'
		on: '2 May 2024'
		in:
		'Pharo-11.0.0+build.726.sha.aece1b5473acf3830a0e082c1bc3a15d4ff3522b (64 Bit)'.
	canvas := RSCanvas new.
	shapes := RSGroup new.

	aDiff diffRanges collect: [ :diffRange |
		self shapeForDiff: diffRange withColor: Color gray ].


	canvas @ RSCanvasController.

	^ canvas
]

{ #category : #shape }
RSCommitDiff >> buildCompositeLayer: shapes withName: name withColor: color [

	| shapesCompo label boxGroup |
	boxGroup := RSGroup new.
	label := RSLabel new
		         text: name;
		         fontSize: 20;
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
		  " model: shapes;"color: (color alpha: 0.1);
		  popup;
		  yourself
]

{ #category : #lines }
RSCommitDiff >> createLinesBetweenCommits: shapes [

	(RSLineBuilder arrowedLine
		 withBorderAttachPoint;
		 color: Color black;
		 canvas: canvas;
		 shapes: shapes;
		 beDirectional;
		 connectToAll: [ :diff | diff childCommits ]) pushFront
]

{ #category : #setter }
RSCommitDiff >> diffCommit: aGLHDiff [ 
	aDiff := aGLHDiff
]

{ #category : #shape }
RSCommitDiff >> shapeForDiff: aGLHDiff withColor: color [

	| box group label |
	group := RSGroup new.
	label := RSLabel new
		         text:
			         (aGLHDiff new_path asPath segments last
				          truncateWithElipsisTo: 50);
		         yourself.
	box := RSBox new
		       height: label height;
		       width: label width;
		       color: color.
	group
		add: label;
		add: box.
	"RSVerticalLineLayout new alignCenter on: group."

	^ RSComposite new
		  shapes: group;
		  model: aGLHDiff;
		  popup;
		  draggable;
		  yourself
]

{ #category : #shape }
RSCommitDiff >> shapeForDiffRange: aGLPHEDiffRange withColor: aColor [

	| box group label |
	group := RSGroup new.
	label := RSLabel new
		         text: aGLPHEDiffRange new_path asPath segments last;
		         yourself.
	box := RSBox new
		       height: label height + 5;
		       width: label width + 10;
		       color: aColor.
	group
		add: box;
		add: label.
	"RSVerticalLineLayout new alignCenter on: group."

	^ RSComposite new
		  shapes: group;
		  model: aGLPHEDiffRange;
		  popup;
		  draggable;
		  yourself
]

{ #category : #shape }
RSCommitDiff >> shapeForRange: aGLHDiff withColor: color [

	| box group label |
	group := RSGroup new.
	label := RSLabel new
		         text: (aGLHDiff new_path truncateWithElipsisTo: 30);
		         yourself.
	box := RSBox new
		       height: 50;
		       width: 50;
		       color: color.
	group
		add: label;
		add: box.
	RSVerticalLineLayout new alignCenter on: group.

	^ RSComposite new
		  shapes: group;
		  model: aGLHDiff;
		  popup;
		  draggable;
		  yourself
]
