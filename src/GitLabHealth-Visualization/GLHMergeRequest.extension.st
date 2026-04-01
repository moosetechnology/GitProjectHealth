Extension { #name : #GLHMergeRequest }

{ #category : #'*GitLabHealth-Visualization' }
GLHMergeRequest >> mergeRequestView: aBuilder [

	<inspectorPresentationOrder: 0 title: 'Merge Request View'>
	^ GLHSpMergeRequestView on: self
]
