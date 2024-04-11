Extension { #name : #GLHCommit }

{ #category : #'*GitLabHealth-Model-Extension' }
GLHCommit >> inspectionGLHCommit [

	<inspectorPresentationOrder: 3 title: 'Commit Hierachie'>
	| canvas |
	canvas := RSCommit canvasFor: self .

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
