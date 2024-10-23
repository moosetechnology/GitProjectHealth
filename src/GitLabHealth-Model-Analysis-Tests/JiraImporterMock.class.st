Class {
	#name : 'JiraImporterMock',
	#superclass : 'Object',
	#instVars : [
		'issues',
		'model'
	],
	#category : 'GitLabHealth-Model-Analysis-Tests',
	#package : 'GitLabHealth-Model-Analysis-Tests'
}

{ #category : 'api - import' }
JiraImporterMock >> importAllCurrentAndPastIssuesOf: email [

	model addAll: issues.
	^ issues
]

{ #category : 'initialization' }
JiraImporterMock >> initialize [

	model := GLPHEModel new name: 'model'.
	issues := {  }.
]

{ #category : 'accessing' }
JiraImporterMock >> issues [

	^ issues
]

{ #category : 'accessing' }
JiraImporterMock >> issues: anObject [

	issues := anObject
]

{ #category : 'accessing' }
JiraImporterMock >> model [

	^ model
]

{ #category : 'accessing' }
JiraImporterMock >> model: anObject [

	model := anObject
]
