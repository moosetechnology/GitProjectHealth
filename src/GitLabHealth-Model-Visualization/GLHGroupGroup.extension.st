Extension { #name : #GLHGroupGroup }

{ #category : #'*GitLabHealth-Model-Visualization' }
GLHGroupGroup >> groupQuality: aBuilder [

	<inspectorPresentationOrder: 100 title: 'Groups Quality'>
	^ SpRoassalInspectorPresenter new
		  canvas: (GLHGroupVisualization new forGroup: self);
		  yourself
]
