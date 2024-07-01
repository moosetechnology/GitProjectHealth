Extension { #name : #GLHGroup }

{ #category : #'*GitLabHealth-Model-Inspector' }
GLHGroup >> groupQuality: aBuilder [

	<inspectorPresentationOrder: 100 title: 'Group Quality'>
	^ SpRoassalInspectorPresenter new
		  canvas: (GLHGroupVisualization new forGroup: { self });
		  yourself
]
