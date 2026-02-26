Extension { #name : #GLHNoteSuggestion }

{ #category : #'*GitLabHealth-Model-Extension' }
GLHNoteSuggestion >> mooseNameOn: aStream [

	aStream nextPutAll: '[from:', from_line asString, ' to:', to_line asString, '] ', to_content.
]
