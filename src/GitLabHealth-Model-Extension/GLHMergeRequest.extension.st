Extension { #name : #GLHMergeRequest }

{ #category : #'*GitLabHealth-Model-Extension' }
GLHMergeRequest >> name [

	<FMProperty: #name type: #String>
	<FMComment: 'Basic name of the entity, not full reference.'>
	^ title
]
