Class {
	#name : #GLPHImporterMock,
	#superclass : #Object,
	#instVars : [
		'commits',
		'commitDiffs'
	],
	#category : #'GitLabHealth-Model-Analysis-Tests'
}

{ #category : #commit }
GLPHImporterMock >> chainsCommitsFrom: fromCommits [
	^self
	 
]

{ #category : #accessing }
GLPHImporterMock >> commits [

	^ commits
]

{ #category : #accessing }
GLPHImporterMock >> commits: anObject [

	commits := anObject
]

{ #category : #'as yet unclassified' }
GLPHImporterMock >> completeImportedCommit: commit [
	^self
]

{ #category : #commit }
GLPHImporterMock >> importCommitsOProject: project since: since until: until [

	^commits
]

{ #category : #'as yet unclassified' }
GLPHImporterMock >> importCreatorOfCommit: commit [

	^self
]

{ #category : #initialization }
GLPHImporterMock >> initialize [ 
	commits := OrderedCollection new
]

{ #category : #accessing }
GLPHImporterMock >> withCommitDiffs: aCommitDiffs [
	commitDiffs := aCommitDiffs 
]
