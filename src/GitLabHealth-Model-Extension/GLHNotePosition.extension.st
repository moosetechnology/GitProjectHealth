Extension { #name : #GLHNotePosition }

{ #category : #'*GitLabHealth-Model-Extension' }
GLHNotePosition >> mooseNameOn: aStream [

	aStream nextPutAll: file_path
]
