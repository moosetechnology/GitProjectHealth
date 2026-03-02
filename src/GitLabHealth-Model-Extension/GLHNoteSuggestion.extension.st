Extension { #name : #GLHNoteSuggestion }

{ #category : #'*GitLabHealth-Model-Extension' }
GLHNoteSuggestion >> mooseNameOn: aStream [

	aStream nextPutAll: '[from:';
		nextPutAll: from_line asString;
		nextPutAll: ' to:';
		nextPutAll: to_line asString;
		nextPutAll: '] ';
		nextPutAll: to_content.
]
