Extension { #name : #OrderedCollection }

{ #category : #'*GitLabHealth-Model-Extension' }
OrderedCollection >> add: anElmt unless: aConditionAsBlock [
	"()>>>"

	^ (self addAll: { anElmt } unless: aConditionAsBlock) first
]

{ #category : #'*GitLabHealth-Model-Extension' }
OrderedCollection >> addAll: anElmtCollection unless: aConditionAsBlock [

	| returnCollection |
	"Create same kind of collection"
	returnCollection := self species new.
	"For each element of this collection"

	anElmtCollection do: [ :anElmt |
		self
			detect: [ :existingElmt |
			aConditionAsBlock value: existingElmt value: anElmt ]
			ifFound: [ :el | returnCollection add: el ]
			ifNone: [
				returnCollection add: anElmt.
				self add: anElmt ] ].

	^ returnCollection
]
