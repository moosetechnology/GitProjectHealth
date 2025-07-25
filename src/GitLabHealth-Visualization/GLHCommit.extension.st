Extension { #name : #GLHCommit }

{ #category : #'*GitLabHealth-Visualization' }
GLHCommit >> commitView: aBuilder [

	<inspectorPresentationOrder: 0 title: 'Commit View'>
	^ GLHSpCommitView on: self
]
