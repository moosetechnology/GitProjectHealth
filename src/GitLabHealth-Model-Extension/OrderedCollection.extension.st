Extension { #name : #OrderedCollection }

{ #category : #'*GitLabHealth-Model-Extension' }
OrderedCollection >> add: anElmt unless: aConditionAsBlock [
	"()>>>"

	^ (self addAll: { anElmt } unless: aConditionAsBlock) first
]

{ #category : #'*GitLabHealth-Model-Extension' }
OrderedCollection >> addAll: anElmtCollection keyedBy: aKeyBlock [

	| elementByKey result |
	elementByKey := Dictionary new: self size + anElmtCollection size.

	result := self class new: anElmtCollection size.

	"Indexe les éléments déjà présents.
    En cas de doublon existant, conserve le premier."
	self do: [ :existing |
		elementByKey
			at: (aKeyBlock value: existing)
			ifAbsentPut: [ existing ] ].

	anElmtCollection do: [ :candidate |
		| canonicalElement |
		canonicalElement := elementByKey
			                    at: (aKeyBlock value: candidate)
			                    ifAbsentPut: [
				                    self add: candidate.
				                    candidate ].

		result add: canonicalElement ].

	^ result
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
