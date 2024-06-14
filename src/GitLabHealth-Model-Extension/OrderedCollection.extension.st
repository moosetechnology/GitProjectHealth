Extension { #name : #OrderedCollection }

{ #category : #'*GitLabHealth-Model-Extension' }
OrderedCollection >> add: anElmt unless: aConditionAsBlock [
	"()>>>"

	^ (self addAll: { anElmt } unless: aConditionAsBlock) first
]

{ #category : #'*GitLabHealth-Model-Extension' }
OrderedCollection >> addAll: anElmtCollection unless: aConditionAsBlock [
	"()>>>"
	|addedElements|
	
	addedElements := (anElmtCollection reject: [ :anElmt |
			 self anySatisfy: [ :existingElmt |
				 aConditionAsBlock value: existingElmt value: anElmt ] ]).
	
	self addAll: addedElements. 
	
	^ (self select: [ :existingElmt |
			 anElmtCollection anySatisfy: [ :anElmt |
				 aConditionAsBlock value: anElmt  value: existingElmt ] ]).
]
