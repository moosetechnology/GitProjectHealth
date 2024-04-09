Extension { #name : #FMSlotMultivalueLink }

{ #category : #'*GitLabHealth-Model-Extension' }
FMSlotMultivalueLink >> add: anElmt unless: aConditionAsBlock [
	"()>>>"

	self addAll: { anElmt } unless: aConditionAsBlock 
]

{ #category : #'*GitLabHealth-Model-Extension' }
FMSlotMultivalueLink >> addAll: anElmtCollection unless: aConditionAsBlock [
	"()>>>"

	self addAll: (anElmtCollection reject: [ :anElmt |
			 self anySatisfy: [
				 :existingElmt | aConditionAsBlock value: existingElmt value: anElmt ] ])
]
