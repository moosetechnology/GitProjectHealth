Extension { #name : #GLHRelease }

{ #category : #'*GitLabHealth-Model-Extension' }
GLHRelease >> name [

	<FMProperty: #name type: #String>
	<generated>
	^ name ifNil: [ tag_name ]
]
