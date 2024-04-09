Class {
	#name : #CodeChurnAnalyzer,
	#superclass : #Object,
	#instVars : [
		'glModel',
		'fromCommit'
	],
	#category : #'GitLabHealth-Model-Analysis'
}

{ #category : #initialization }
CodeChurnAnalyzer >> initialize [ 
	glModel := GLPHEModel new.
	fromCommit := GLHCommit new. 
]
