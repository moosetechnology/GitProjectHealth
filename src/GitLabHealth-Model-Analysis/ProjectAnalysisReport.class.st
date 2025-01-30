Class {
	#name : #ProjectAnalysisReport,
	#superclass : #AnalysisReport,
	#instVars : [
		'projectName'
	],
	#category : #'GitLabHealth-Model-Analysis'
}

{ #category : #accessing }
ProjectAnalysisReport >> projectName [

	^ projectName
]

{ #category : #accessing }
ProjectAnalysisReport >> projectName: anObject [

	projectName := anObject
]
