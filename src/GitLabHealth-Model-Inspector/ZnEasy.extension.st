Extension { #name : #ZnEasy }

{ #category : #'*GitLabHealth-Model-Inspector' }
ZnEasy class >> getImg: urlObject [

	| response |
	response := self get: urlObject.
	^ ImageReadWriter formFromStream: response entity readStream
]
