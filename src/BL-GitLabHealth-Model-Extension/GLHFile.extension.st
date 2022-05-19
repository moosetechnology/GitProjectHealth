Extension { #name : #GLHFile }

{ #category : #'*BL-GitLabHealth-Model-Extension' }
GLHFile >> path [

	^ (self directoryOwner
		   ifNotNil: [ :owner | owner path , '/' ]
		   ifNil: [ '' ]) , self name
]
