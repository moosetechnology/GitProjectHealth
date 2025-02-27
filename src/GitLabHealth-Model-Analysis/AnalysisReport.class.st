Class {
	#name : #AnalysisReport,
	#superclass : #Object,
	#instVars : [
		'period',
		'over',
		'metrics'
	],
	#category : #'GitLabHealth-Model-Analysis'
}

{ #category : #initialization }
AnalysisReport >> initialize [

	metrics := Dictionary new
]

{ #category : #accessing }
AnalysisReport >> metrics [

	^ metrics
]

{ #category : #accessing }
AnalysisReport >> over [

	^ over
]

{ #category : #accessing }
AnalysisReport >> over: anObject [

	over := anObject
]

{ #category : #accessing }
AnalysisReport >> period [

	^ period
]

{ #category : #accessing }
AnalysisReport >> period: anObject [

	period := anObject
]
