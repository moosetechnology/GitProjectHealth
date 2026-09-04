Extension { #name : #LGitReference }

{ #category : #'*GitProjectHealth-Model-LocalImporter' }
LGitReference >> gitName [

	^ self isLocal
		  ifTrue: [ self name withoutPrefix: 'refs/heads/' ]
		  ifFalse: [ self name withoutPrefix: 'refs/remotes/' ]
]
