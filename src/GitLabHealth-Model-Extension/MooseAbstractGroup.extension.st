Extension { #name : #MooseAbstractGroup }

{ #category : #'*GitLabHealth-Model-Extension' }
MooseAbstractGroup >> add: anElmt unless: aConditionAsBlock [
	"()>>>"

	^ (self addAll: { anElmt } unless: aConditionAsBlock) first
]

{ #category : #'*GitLabHealth-Model-Extension' }
MooseAbstractGroup >> addAll: anElmtCollection keyedBy: aConditionAsBlock [
	"()>>>"

	anElmtCollection ifEmpty: [ ^ {} ].
	^ self
		addAll: anElmtCollection
		ofType: anElmtCollection first class
		keyedBy: aConditionAsBlock
]

{ #category : #'*GitLabHealth-Model-Extension' }
MooseAbstractGroup >> addAll: anElmtCollection ofType: aType keyedBy: aKeyBlock [

    | existingElements elementByKey result |

    existingElements := self allWithType: aType.

    elementByKey := Dictionary new:
        existingElements size + anElmtCollection size.

    result := OrderedCollection new: anElmtCollection size.

    "Indexe les éléments déjà présents.
    En cas de doublon existant, conserve le premier."
    existingElements do: [ :existing |
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
MooseAbstractGroup >> addAll: anElmtCollection ofType: aType unless: aConditionAsBlock [

	| originalCollection returnCollection |
	"you should use addAll: anElmtCollection ofType: aType keyedBy: aKeyBlock if possible"
	originalCollection := (self allWithType: aType).
	"Create same kind of collection"
	returnCollection := OrderedCollection new.
	
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

{ #category : #'*GitLabHealth-Model-Extension' }
MooseAbstractGroup >> addAll: anElmtCollection unless: aConditionAsBlock [
	"()>>>"

	anElmtCollection ifEmpty: [ ^ {} ].
	^ self
		addAll: anElmtCollection
		ofType: anElmtCollection first class
		unless: aConditionAsBlock
]
