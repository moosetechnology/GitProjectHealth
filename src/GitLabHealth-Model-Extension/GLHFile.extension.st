Extension { #name : #GLHFile }

{ #category : #'*GitLabHealth-Model-Extension' }
GLHFile >> path [

	^ (self directoryOwner
		   ifNotNil: [ :owner | owner path , '/' ]
		   ifNil: [ '' ]) , self name
]
