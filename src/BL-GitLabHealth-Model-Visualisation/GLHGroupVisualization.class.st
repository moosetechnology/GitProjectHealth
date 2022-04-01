Class {
	#name : #GLHGroupVisualization,
	#superclass : #MiAbstractVisualization,
	#category : #'BL-GitLabHealth-Model-Visualisation'
}

{ #category : #running }
GLHGroupVisualization >> forGroup: aGLHGroup [

	| c shapes legend |
	c := RSCanvas new.

	shapes := (aGLHGroup allToScope: GLHGroup) collect: [ :group | 
		          | lbl projects composite |
		          projects := group projects
			                      collect: [ :project | 
				                      | box |
				                      box := RSBox new
					                             size: 5;
					                             model: project;
					                             yourself.
				                      (project pipelines isNotEmpty and: [ 
					                       project pipelines last status = #success ])
					                      ifTrue: [ box color: Color green ]
					                      ifFalse: [ box color: Color red ].
				                      box ]
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
		          composite ].
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
	legend := RSLegend new.
	legend container: c.
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
	legend build.

	^ c
]
