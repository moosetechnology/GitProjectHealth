Extension { #name : #GLHCommit }

{ #category : #'*GitLabHealth-Model-Extension' }
GLHCommit >> inspectionGLHCommit [

	<inspectorPresentationOrder: 3 title: 'Commit Hierachy'>
	| canvas |
	canvas := RSCommit canvasHierarchyFor: self.

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

	<FMProperty: #name type: #String>
	<generated>
	<FMComment: 'Basic name of the entity, not full reference.'>
	^ message ifNil: [ 'Commit#' , short_id ]
]

{ #category : #'*GitLabHealth-Model-Extension' }
GLHCommit >> parent_ids [
	
	^ parent_ids 
]
