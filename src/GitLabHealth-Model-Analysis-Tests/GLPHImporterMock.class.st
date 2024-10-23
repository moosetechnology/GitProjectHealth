Class {
	#name : 'GLPHImporterMock',
	#superclass : 'Object',
	#instVars : [
		'commits',
		'commitDiffs',
		'mergeRequests',
		'glhModel'
	],
	#category : 'GitLabHealth-Model-Analysis-Tests',
	#package : 'GitLabHealth-Model-Analysis-Tests'
}

{ #category : 'commit' }
GLPHImporterMock >> chainsCommitsFrom: fromCommits [
	^self
	 
]

{ #category : 'accessing' }
GLPHImporterMock >> commits [

	^ commits
]

{ #category : 'accessing' }
GLPHImporterMock >> commits: anObject [

	commits := anObject
]

{ #category : 'as yet unclassified' }
GLPHImporterMock >> completeImportedCommit: commit [
	^self
]

{ #category : 'accessing' }
GLPHImporterMock >> glhModel [

	^ glhModel
]

{ #category : 'accessing' }
GLPHImporterMock >> glhModel: anObject [

	glhModel := anObject
]

{ #category : 'commit' }
GLPHImporterMock >> importCommitsOfProject: project since: since until: until [

	glhModel addAll: commits.
	^ commits
]

{ #category : 'as yet unclassified' }
GLPHImporterMock >> importCreatorOfCommit: commit [

	^self
]

{ #category : 'import - merge request' }
GLPHImporterMock >> importMergeRequestCommits: mergeRequest [

	mergeRequest commits: self commits
]

{ #category : 'import - merge request' }
GLPHImporterMock >> importMergeRequests: project since: since until: until [

	glhModel addAll: mergeRequests.
	^ mergeRequests
]

{ #category : 'import - merge request' }
GLPHImporterMock >> importMergeResquestAuthor: mr [
	^self
]

{ #category : 'import - merge request' }
GLPHImporterMock >> importMergeResquestMerger: mergeRequest [
	^self
]

{ #category : 'initialization' }
GLPHImporterMock >> initialize [

	commits := OrderedCollection new.
	mergeRequests := OrderedCollection new.

	glhModel := GLHModel new name: 'model'
]

{ #category : 'accessing' }
GLPHImporterMock >> mergeRequests [

	^ mergeRequests
]

{ #category : 'accessing' }
GLPHImporterMock >> mergeRequests: anObject [

	mergeRequests := anObject
]

{ #category : 'accessing' }
GLPHImporterMock >> withCommitDiffs: aCommitDiffs [
	commitDiffs := aCommitDiffs 
]
