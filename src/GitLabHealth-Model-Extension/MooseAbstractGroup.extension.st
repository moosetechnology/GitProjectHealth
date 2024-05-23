Extension { #name : #MooseAbstractGroup }

{ #category : #'*GitLabHealth-Model-Extension' }
MooseAbstractGroup >> add: anElmt unless: aConditionAsBlock [
	"()>>>"

	^ (self addAll: { anElmt } unless: aConditionAsBlock) first
]

{ #category : #'*GitLabHealth-Model-Extension' }
MooseAbstractGroup >> addAll: anElmtCollection ofType: aType unless: aConditionAsBlock [
	"()>>>"

	| addedElement |
	addedElement := anElmtCollection reject: [ :anElmt |
		                (self allWithType: aType) anySatisfy: [
			                :existingElmt |
			                aConditionAsBlock value: existingElmt value: anElmt ] ].

	self addAll: addedElement.
	
	^ (self allWithType: aType) select: [ :existingElmt |
		  anElmtCollection anySatisfy: [ :anElmt |
			  aConditionAsBlock value: anElmt value: existingElmt ] ]
]

{ #category : #'*GitLabHealth-Model-Extension' }
MooseAbstractGroup >> addAll: anElmtCollection unless: aConditionAsBlock [
	"()>>>"

	anElmtCollection ifEmpty: [ ^ self ].
	^ self
		addAll: anElmtCollection
		ofType: anElmtCollection first class
		unless: aConditionAsBlock
]
