Class {
	#name : #UserAnalysisReport,
	#superclass : #AnalysisReport,
	#instVars : [
		'username',
		'email'
	],
	#category : #'GitLabHealth-Model-Analysis'
}

{ #category : #accessing }
UserAnalysisReport >> email [

	^ email
]

{ #category : #accessing }
UserAnalysisReport >> email: anObject [

	email := anObject
]

{ #category : #accessing }
UserAnalysisReport >> username [

	^ username
]

{ #category : #accessing }
UserAnalysisReport >> username: anObject [

	username := anObject
]
