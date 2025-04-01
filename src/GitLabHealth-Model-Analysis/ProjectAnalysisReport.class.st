Class {
	#name : #ProjectAnalysisReport,
	#superclass : #AnalysisReport,
	#instVars : [
		'projectName',
		'projectID'
	],
	#category : #'GitLabHealth-Model-Analysis'
}

{ #category : #accessing }
ProjectAnalysisReport >> projectID [

	^ projectID
]

{ #category : #accessing }
ProjectAnalysisReport >> projectID: anObject [

	projectID := anObject
]

{ #category : #accessing }
ProjectAnalysisReport >> projectName [

	^ projectName
]

{ #category : #accessing }
ProjectAnalysisReport >> projectName: anObject [

	projectName := anObject
]
