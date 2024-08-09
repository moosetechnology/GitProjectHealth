Class {
	#name : #AnalysisReport,
	#superclass : #Object,
	#instVars : [
		'username',
		'period',
		'codeAddition',
		'codeDeletion',
		'commitFrequency',
		'commentContribution',
		'mergeRequestDuration',
		'codeChurn',
		'delayUntilFirstChurn'
	],
	#category : #'GitLabHealth-Model-Analysis'
}

{ #category : #testing }
AnalysisReport class >> isVoyageRoot [
	^true
]

{ #category : #accessing }
AnalysisReport >> codeAddition [

	^ codeAddition
]

{ #category : #accessing }
AnalysisReport >> codeAddition: anObject [

	codeAddition := anObject
]

{ #category : #accessing }
AnalysisReport >> codeChurn [

	^ codeChurn
]

{ #category : #accessing }
AnalysisReport >> codeChurn: anObject [

	codeChurn := anObject
]

{ #category : #accessing }
AnalysisReport >> codeDeletion [

	^ codeDeletion
]

{ #category : #accessing }
AnalysisReport >> codeDeletion: anObject [

	codeDeletion := anObject
]

{ #category : #accessing }
AnalysisReport >> commentContribution [

	^ commentContribution
]

{ #category : #accessing }
AnalysisReport >> commentContribution: anObject [

	commentContribution := anObject
]

{ #category : #accessing }
AnalysisReport >> commitFrequency [

	^ commitFrequency
]

{ #category : #accessing }
AnalysisReport >> commitFrequency: anObject [

	commitFrequency := anObject
]

{ #category : #accessing }
AnalysisReport >> delayUntilFirstChurn [

	^ delayUntilFirstChurn
]

{ #category : #accessing }
AnalysisReport >> delayUntilFirstChurn: anObject [

	delayUntilFirstChurn := anObject
]

{ #category : #accessing }
AnalysisReport >> mergeRequestDuration [

	^ mergeRequestDuration
]

{ #category : #accessing }
AnalysisReport >> mergeRequestDuration: anObject [

	mergeRequestDuration := anObject
]

{ #category : #accessing }
AnalysisReport >> period [

	^ period
]

{ #category : #accessing }
AnalysisReport >> period: anObject [

	period := anObject
]

{ #category : #accessing }
AnalysisReport >> username [

	^ username
]

{ #category : #accessing }
AnalysisReport >> username: anObject [

	username := anObject
]
