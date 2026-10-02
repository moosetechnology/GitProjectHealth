Extension { #name : #LGitRefSpec }

{ #category : #'*GitProjectHealth-Model-LocalImporter' }
LGitRefSpec >> initializeFromString: aString [
	<todo: 'use exceptions instead of assertions'>
	| stream |

	"self assert: ('(\+?\w(\w|\-|\.|/)*)?\:\w(\w|\-|\.|/)*' asRegex matches: aString)."
	"this is wrong, for example ''+refs/merge-requests/*/head:refs/remotes/origin/mr/*' should work"
		
	stream := aString readStream.
	[
		(stream peek = $+) ifTrue: [ 
			self beForced.
			stream next ].
		self source: (stream upTo: $:).
		self destination: stream upToEnd ] ensure: [ stream close ]
]
