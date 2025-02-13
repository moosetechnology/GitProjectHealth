Extension { #name : #GLHProject }

{ #category : #'*GitLabHealth-Model-Extension' }
GLHProject >> projectContributorsInspector: aBuilder [

	<inspectorPresentationOrder: 100 title: 'Contributors'>
	^ SpRoassalInspectorPresenter new
		  canvas: (GLHProjectContributorVisualization  new forProject: self );
		  yourself
]
