Extension { #name : #GLHNote }

{ #category : #'*GitLabHealth-Model-Extension' }
GLHNote >> name [

	<FMProperty: #name type: #String>
	<generated>
	<FMComment: 'Basic name of the entity, not full reference.'>
	^'[' , id asString , '] ' , body
]
