Class {
	#name : #UserMetric,
	#superclass : #Metric,
	#instVars : [
		'user',
		'userProjects',
		'userCommits',
		'userMergeRequests'
	],
	#category : #'GitLabHealth-Model-Analysis'
}

{ #category : #utils }
UserMetric >> cacheSymbolFor: anEntityType since: since until: until [

	^ (anEntityType printString , ' since ' , since printString , ' to '
	   , until printString) asSymbol
]

{ #category : #calculating }
UserMetric >> calculate [

	^ self subclassResponsibility
]

{ #category : #accessing }
UserMetric >> description [

	^ self subclassResponsibility
]

{ #category : #initialization }
UserMetric >> initialize [
	over := Date
]

{ #category : #loading }
UserMetric >> load [

	^ self subclassResponsibility
]

{ #category : #accessing }
UserMetric >> name [

	^ self subclassResponsibility
]

{ #category : #accessing }
UserMetric >> user: anObject [

	user := anObject
]
