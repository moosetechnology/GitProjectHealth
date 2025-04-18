Class {
	#name : #JiraImporterMock,
	#superclass : #Object,
	#instVars : [
		'issues',
		'model'
	],
	#category : #'GitLabHealth-Model-Analysis-Tests'
}

{ #category : #'api - import' }
JiraImporterMock >> importAllCurrentAndPastIssuesOf: email [

	model addAll: issues.
	^ issues
]

{ #category : #'api - issue' }
JiraImporterMock >> importIssue: aKeyOrId [ 
	self model addAll: self issues unless: [ :existing :new |
	  existing id = new id ]. 
	^ self issues detect: [ :issue | issue id = aKeyOrId or: [ issue key = aKeyOrId ] ] ifNone: [  nil ].
]

{ #category : #initialization }
JiraImporterMock >> initialize [

	model := GLHModel new name: 'model'.
	issues := {  }.
]

{ #category : #accessing }
JiraImporterMock >> issues [

	^ issues
]

{ #category : #accessing }
JiraImporterMock >> issues: anObject [

	issues := anObject
]

{ #category : #load }
JiraImporterMock >> loadIssues: aCollection [ 
	self model addAll: aCollection.
	^aCollection 
]

{ #category : #accessing }
JiraImporterMock >> model [

	^ model
]

{ #category : #accessing }
JiraImporterMock >> model: anObject [

	model := anObject
]
