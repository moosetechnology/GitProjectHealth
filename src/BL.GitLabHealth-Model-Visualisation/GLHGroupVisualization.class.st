Class {
	#name : #GLHGroupVisualization,
	#superclass : #MiAbstractVisualization,
	#category : #'BL.GitLabHealth-Model-Visualisation'
}

{ #category : #running }
GLHGroupVisualization >> forGroup: aGLHGroup [

	| c shapes |
	super run.
	c := RSCanvas new.

	shapes := { aGLHGroup } , { (aGLHGroup allToScope: GLHGroup) } flattened 
		          collect: [ :group | 
			          | box lbl |
			          lbl := RSLabel new
				                 text: group name;
				                 yourself.
			          box := RSBox new
				                 withBorder;
				                 extent: lbl extent + 10.
			          RSComposite new
				          draggable;
				          model: group;
				          shapes: (RSGroup with: box with: lbl);
				          yourself ].
	c addAll: shapes.
	c @ RSCanvasController.
	RSLineBuilder orthoVertical
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
	RSHorizontalTreeLayout new on: c nodes.
	c zoomToFit.
	^ c
]
