Class {
	#name : #UserAnalysisReport,
	#superclass : #Object,
	#instVars : [
		'username',
		'period',
		'over',
		'metrics'
	],
	#category : #'GitLabHealth-Model-Analysis'
}

{ #category : #initialization }
UserAnalysisReport >> initialize [ 
	metrics  := Dictionary new.
]

{ #category : #accessing }
UserAnalysisReport >> metrics [

	^ metrics
]

{ #category : #accessing }
UserAnalysisReport >> over [

	^ over
]

{ #category : #accessing }
UserAnalysisReport >> over: anObject [

	over := anObject
]

{ #category : #accessing }
UserAnalysisReport >> period [

	^ period
]

{ #category : #accessing }
UserAnalysisReport >> period: anObject [

	period := anObject
]

{ #category : #accessing }
UserAnalysisReport >> username [

	^ username
]

{ #category : #accessing }
UserAnalysisReport >> username: anObject [

	username := anObject
]
