Class {
	#name : #GitModelMixedImporter,
	#superclass : #GitModelImporter,
	#instVars : [
		'apiImporter',
		'localImporter'
	],
	#category : #'GitProjectHealth-Model-MixedImporter'
}

{ #category : #accessing }
GitModelMixedImporter >> apiImporter [

	^ apiImporter
]

{ #category : #accessing }
GitModelMixedImporter >> apiImporter: anObject [

	apiImporter := anObject.
	apiImporter factoryImporter: self
]

{ #category : #accessing }
GitModelMixedImporter >> glhModel: anObject [

	glhModel := anObject.
	self apiImporter ifNotNil: [ :importer | importer glhModel: anObject ].
	self localImporter ifNotNil: [ :importer | importer glhModel: anObject ]
]

{ #category : #'import - branches' }
GitModelMixedImporter >> importBranchesOfProject: aGLHProject [

	^ self localImporter importBranchesOfProject: aGLHProject
]

{ #category : #'import - branches' }
GitModelMixedImporter >> importBranchesOfRepository: aGLHRepository [

	^ self localImporter importBranchesOfRepository: aGLHRepository
]

{ #category : #'import - commits' }
GitModelMixedImporter >> importCommit: aCommitID ofProject: aGLHProject [

	^ self localImporter importCommit: aCommitID ofProject: aGLHProject
]

{ #category : #'import - commits' }
GitModelMixedImporter >> importCommitsOfProject: aGLHProject since: since until: until [

	^ self localImporter importCommitsOfProject: aGLHProject since: since until: until
]

{ #category : #'import - diffs' }
GitModelMixedImporter >> importDiffOfCommit: aCommit [

	^ [ self localImporter importDiffOfCommit: aCommit ]
		  on: LGit_GIT_ENOTFOUND
		  do: [ self apiImporter importDiffOfCommit: aCommit ]
]

{ #category : #'import - pipelines' }
GitModelMixedImporter >> importLatestPipelinesOfProject: aGLHProject [

	^ self apiImporter importLatestPipelinesOfProject: aGLHProject
]

{ #category : #'import - merge-requests' }
GitModelMixedImporter >> importMergeRequestCommits: mergeRequest [

	^ self apiImporter importMergeRequestCommits: mergeRequest
]

{ #category : #'import - merge-requests' }
GitModelMixedImporter >> importMergeRequestMergeCommits: aGLHMergeRequest [

	^ self apiImporter importMergeRequestMergeCommits: aGLHMergeRequest
]

{ #category : #'import - merge-requests' }
GitModelMixedImporter >> importMergeRequestsOfProject: aGLHProject since: fromDate until: toDate [

	^ self apiImporter importMergeRequestsOfProject: aGLHProject since: fromDate until: toDate
]

{ #category : #'import - notes' }
GitModelMixedImporter >> importNotesOfMergeRequest: mergeRequest [

	^ self apiImporter importNotesOfMergeRequest: mergeRequest
]

{ #category : #'import - projects' }
GitModelMixedImporter >> importProject: id [

	^ self apiImporter importProject: id
]

{ #category : #'import - tags' }
GitModelMixedImporter >> importTagsForProject: aGLHProject [

	^ self apiImporter importTagsForProject: aGLHProject
]

{ #category : #'import - users' }
GitModelMixedImporter >> importUser: aUserID [

	^ self apiImporter importUser: aUserID
]

{ #category : #'import - users' }
GitModelMixedImporter >> importUserByUsername: username [

	^ self apiImporter importUserByUsername: username
]

{ #category : #accessing }
GitModelMixedImporter >> localImporter [

	^ localImporter
]

{ #category : #accessing }
GitModelMixedImporter >> localImporter: anObject [

	localImporter := anObject.
	localImporter factoryImporter: self
]

{ #category : #accessing }
GitModelMixedImporter >> withCommitDiffs: aBoolean [

	super withCommitDiffs: aBoolean.
	self localImporter withCommitDiffs: aBoolean.
	self apiImporter withCommitDiffs: aBoolean.
]

{ #category : #accessing }
GitModelMixedImporter >> withDiffRanges: aBoolean [

	super withDiffRanges: aBoolean.
	self localImporter ifNotNil: [ :importer | importer withDiffRanges: aBoolean ].
	self apiImporter ifNotNil: [ :importer | importer withDiffRanges: aBoolean ].
]
