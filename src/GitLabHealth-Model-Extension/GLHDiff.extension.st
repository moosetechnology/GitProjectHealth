Extension { #name : #GLHDiff }

{ #category : #'*GitLabHealth-Model-Extension' }
GLHDiff >> name [

	<FMProperty: #name type: #String>
	^ new_path ifNotNil: [:string | string contractTo: 100]
]
