Extension { #name : #OrderedCollection }

{ #category : #'*GitLabHealth-Model-Extension' }
OrderedCollection >> add: anElmt unless: aConditionAsBlock [
	"()>>>"

	self addAll: { anElmt } unless: aConditionAsBlock 
]

{ #category : #'*GitLabHealth-Model-Extension' }
OrderedCollection >> addAll: anElmtCollection unless: aConditionAsBlock [
	"()>>>"

	self addAll: (anElmtCollection reject: [ :anElmt |
			 self anySatisfy: [
				 :existingElmt | aConditionAsBlock value: existingElmt value: anElmt ] ])
]
