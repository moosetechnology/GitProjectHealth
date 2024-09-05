Class {
	#name : #GLPHImporterMock,
	#superclass : #Object,
	#instVars : [
		'commits',
		'commitDiffs',
		'mergeRequests'
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

{ #category : #'import - merge request' }
GLPHImporterMock >> importMergeRequests: project since: since until: until [
	^mergeRequests
	
]

{ #category : #'import - merge request' }
GLPHImporterMock >> importMergeResquestAuthor: mr [
	^self
]

{ #category : #'import - merge request' }
GLPHImporterMock >> importMergeResquestMerger: mergeRequest [
	^self
]

{ #category : #initialization }
GLPHImporterMock >> initialize [

	commits := OrderedCollection new.
	mergeRequests := OrderedCollection new.
]

{ #category : #accessing }
GLPHImporterMock >> mergeRequests [

	^ mergeRequests
]

{ #category : #accessing }
GLPHImporterMock >> mergeRequests: anObject [

	mergeRequests := anObject
]

{ #category : #accessing }
GLPHImporterMock >> withCommitDiffs: aCommitDiffs [
	commitDiffs := aCommitDiffs 
]
