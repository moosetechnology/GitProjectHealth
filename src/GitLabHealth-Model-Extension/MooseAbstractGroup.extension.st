Extension { #name : 'MooseAbstractGroup' }

{ #category : '*GitLabHealth-Model-Extension' }
MooseAbstractGroup >> add: anElmt unless: aConditionAsBlock [
	"()>>>"

	^ (self addAll: { anElmt } unless: aConditionAsBlock) first
]

{ #category : '*GitLabHealth-Model-Extension' }
MooseAbstractGroup >> addAll: anElmtCollection ofType: aType unless: aConditionAsBlock [

	| originalCollection returnCollection |
	originalCollection := (self allWithType: aType).
	"Create same kind of collection"
	returnCollection := self species new.
	
	anElmtCollection do: [ :anElmt |
		originalCollection
			detect: [ :existingElmt |
			aConditionAsBlock value: existingElmt value: anElmt ]
			ifFound: [ :el | returnCollection add: el ]
			ifNone: [
				returnCollection add: anElmt.
				self add: anElmt ] ].

	^ returnCollection
]

{ #category : '*GitLabHealth-Model-Extension' }
MooseAbstractGroup >> addAll: anElmtCollection unless: aConditionAsBlock [
	"()>>>"

	anElmtCollection ifEmpty: [ ^ {} ].
	^ self
		addAll: anElmtCollection
		ofType: anElmtCollection first class
		unless: aConditionAsBlock
]
