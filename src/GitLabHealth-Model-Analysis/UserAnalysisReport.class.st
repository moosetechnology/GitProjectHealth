Class {
	#name : 'UserAnalysisReport',
	#superclass : 'AnalysisReport',
	#instVars : [
		'username'
	],
	#category : 'GitLabHealth-Model-Analysis',
	#package : 'GitLabHealth-Model-Analysis'
}

{ #category : 'accessing' }
UserAnalysisReport >> username [

	^ username
]

{ #category : 'accessing' }
UserAnalysisReport >> username: anObject [

	username := anObject
]
