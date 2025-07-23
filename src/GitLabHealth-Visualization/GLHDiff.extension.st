Extension { #name : #GLHDiff }

{ #category : #'*GitLabHealth-Visualization' }
GLHDiff >> diffView: aBuilder [

	<inspectorPresentationOrder: 100 title: 'Diff View'>
	^ GLHSpDiffView on: self
]

{ #category : #'*GitLabHealth-Visualization' }
GLHDiff >> inspectionGLHDiff [

	<inspectorPresentationOrder: 3 title: 'Files Impacted'>
	| canvas |
	canvas := RSCommitDiff canvasFor: self.

	^ canvas asPresenter
]
