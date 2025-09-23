Class {
	#name : #GLPHImporterMock,
	#superclass : #Object,
	#instVars : [
		'commits',
		'commitDiffs',
		'mergeRequests',
		'glhModel',
		'notes',
		'tags',
		'branches',
		'tags2Commit'
	],
	#category : #'GitLabHealth-Model-Analysis-Tests'
}

{ #category : #equality }
GLPHImporterMock >> blockOnIdEquality [

	^ [ :existing :new | existing id = new id ].
]

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

{ #category : #accessing }
GLPHImporterMock >> glhModel [

	^ glhModel
]

{ #category : #accessing }
GLPHImporterMock >> glhModel: anObject [

	glhModel := anObject
]

{ #category : #'import - repositories' }
GLPHImporterMock >> importBranchesOf: aGLHProject [ 
	^ aGLHProject repository branches . 
]

{ #category : #'import - commits' }
GLPHImporterMock >> importCommit: aString ofProject: aGLHProject [ 
	^ self commits detect: [ :c | c id = aString ] ifNone: [nil].
]

{ #category : #'import - commits' }
GLPHImporterMock >> importCommitsFromTag: fromTag toTag: toTag [ 
	(fromTag isNil or: [toTag isNil]) ifTrue: [ ^ OrderedCollection new ]. 
	^ (tags2Commit at: toTag name) difference: (tags2Commit at: fromTag name)
	

]

{ #category : #commit }
GLPHImporterMock >> importCommitsOfProject: project since: since until: until [

	self flag: 'Adds commits regardless of their creation date !'.
	glhModel addAll: commits.
	^ commits select: [ :commit | commit repository project = project ].
]

{ #category : #'as yet unclassified' }
GLPHImporterMock >> importCreatorOfCommit: commit [

	^self
]

{ #category : #'import - merge request' }
GLPHImporterMock >> importMergeRequestCommits: mergeRequest [

	mergeRequest commits: self commits
]

{ #category : #'import - merge request' }
GLPHImporterMock >> importMergeRequestMergeCommits: aGLHMergeRequest [ 
	^ {aGLHMergeRequest mergedCommit . aGLHMergeRequest squashCommit . aGLHMergeRequest mergeRequestCommit } .
]

{ #category : #'import - merge request' }
GLPHImporterMock >> importMergeRequestsOfProject: project since: since until: until [

	self flag: 'Adds MR regardless of their creation date !'.
	glhModel addAll: mergeRequests .
	
	^ (mergeRequests select: [ :mr | mr project = project  ]) 
]

{ #category : #'import - merge request' }
GLPHImporterMock >> importMergeResquestAuthor: mr [
	^self
]

{ #category : #'import - merge request' }
GLPHImporterMock >> importMergeResquestMerger: mergeRequest [
	^self
]

{ #category : #'import - notes' }
GLPHImporterMock >> importNotesOfMergeRequest: mriid [

	^OrderedCollection with: (notes select: [ :note | (note noteable_iid == mriid) ]) 
]

{ #category : #'as yet unclassified' }
GLPHImporterMock >> importRefCommitOfBranch: aGLHBranch [ 
	^ aGLHBranch 
]

{ #category : #'import - tag' }
GLPHImporterMock >> importTagsForProject: aGLHProject [ 
	^ tags.
]

{ #category : #initialization }
GLPHImporterMock >> initialize [

	commits := OrderedCollection new.
	mergeRequests := OrderedCollection new.

	glhModel := GLHModel new name: 'model'
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
GLPHImporterMock >> notes [

	^notes
]

{ #category : #accessing }
GLPHImporterMock >> notes: anObject [

	notes := anObject 
]

{ #category : #tag }
GLPHImporterMock >> tag2Commit [
	^tags2Commit .
]

{ #category : #tags }
GLPHImporterMock >> tag2Commit: aCollection [ 
	tags2Commit := aCollection.
]

{ #category : #accessing }
GLPHImporterMock >> tags: aCollection [ 
	tags := aCollection .
]

{ #category : #accessing }
GLPHImporterMock >> withCommitDiffs: aCommitDiffs [
	commitDiffs := aCommitDiffs 
]
