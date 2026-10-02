Extension { #name : #LGitReference }

{ #category : #'*GitProjectHealth-Model-LocalImporter' }
LGitReference >> gitName [

	^ self isLocal
		  ifTrue: [ self name withoutPrefix: 'refs/heads/' ]
		  ifFalse: [ "removing the refs/remote and the name of the remote"
			  (self name withoutPrefix: 'refs/remotes/') copyAfter: $/ ]
]
