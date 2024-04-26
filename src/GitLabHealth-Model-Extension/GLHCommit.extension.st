Extension { #name : #GLHCommit }

{ #category : #'*GitLabHealth-Model-Extension' }
GLHCommit >> inspectionGLHCommit [

	<inspectorPresentationOrder: 3 title: 'Commit Hierarchy'>
	| canvas |
	canvas := RSCommit canvasHierarchyFor:  self.

	^ canvas asPresenter
]

{ #category : #'*GitLabHealth-Model-Extension' }
GLHCommit >> inspectionGLHCommitChildren [

	<inspectorPresentationOrder: 3 title: 'Commit Children'>
	| canvas |
	canvas := RSCommit canvasCompleteHierachyFor: self.

	^ canvas asPresenter
]

{ #category : #'*GitLabHealth-Model-Extension' }
GLHCommit >> inspectionGLHCommitFileImpacts [

	<inspectorPresentationOrder: 3 title: 'File Impact'>
	| canvas |
	canvas := RSCommit canvasDiffImpactFor: self.

	^ canvas asPresenter
]

{ #category : #'*GitLabHealth-Model-Extension' }
GLHCommit >> name [
	^ message ifNil: [ 'Commit#' , short_id ]
]

{ #category : #'*GitLabHealth-Model-Extension' }
GLHCommit >> parent_ids [
	
	^ parent_ids 
]
