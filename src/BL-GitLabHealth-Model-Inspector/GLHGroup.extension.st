Extension { #name : #GLHGroup }

{ #category : #'*BL-GitLabHealth-Model-Inspector' }
GLHGroup >> groupQuality: aBuilder [
	<inspectorPresentationOrder: 100 title: 'Group Quality'>
	^ SpRoassal3InspectorPresenter new
		canvas: (GLHGroupVisualization new forGroup: self);
		yourself
]
