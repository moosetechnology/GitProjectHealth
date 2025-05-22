Extension { #name : #GLHPipeline }

{ #category : #'*GitLabHealth-Model-Extension' }
GLHPipeline >> mooseNameOn: aStream [
	aStream nextPutAll: (id asString, ' ', status asString)
]
