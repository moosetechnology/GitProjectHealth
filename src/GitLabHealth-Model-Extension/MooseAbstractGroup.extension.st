Extension { #name : #MooseAbstractGroup }

{ #category : #'*GitLabHealth-Model-Extension' }
MooseAbstractGroup >> add: anElmt unless: aConditionAsBlock [
	"()>>>"

	self addAll: { anElmt } unless: aConditionAsBlock
	
	
]

{ #category : #'*GitLabHealth-Model-Extension' }
MooseAbstractGroup >> addAll: anElmtCollection ofType: aType unless: aConditionAsBlock [
	"()>>>"

	self addAll: (anElmtCollection reject: [ :anElmt |
			 (self allWithType: aType) anySatisfy: [ :existingElmt |
				 aConditionAsBlock value: existingElmt value: anElmt ] ])
]

{ #category : #'*GitLabHealth-Model-Extension' }
MooseAbstractGroup >> addAll: anElmtCollection unless: aConditionAsBlock [
	"()>>>"

	anElmtCollection ifEmpty: [ ^ self ].
	self
		addAll: anElmtCollection
		ofType: anElmtCollection first class
		unless: aConditionAsBlock.	
]
