Extension { #name : #GLHDiff }

{ #category : #'*GitLabHealth-Visualization' }
GLHDiff >> inspectionGLHDiff [

	<inspectorPresentationOrder: 3 title: 'Files Impacted'>
	| canvas |
	canvas := RSCommitDiff canvasFor: self.

	^ canvas asPresenter
]
