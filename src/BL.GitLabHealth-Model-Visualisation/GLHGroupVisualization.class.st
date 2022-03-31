Class {
	#name : #GLHGroupVisualization,
	#superclass : #MiAbstractVisualization,
	#category : #'BL.GitLabHealth-Model-Visualisation'
}

{ #category : #running }
GLHGroupVisualization >> forGroup: aGLHGroup [

	| c shapes |
	c := RSCanvas new.

	shapes := (aGLHGroup allToScope: GLHGroup) collect: [ :group | 
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
	c zoomToFit.
	^ c
]
