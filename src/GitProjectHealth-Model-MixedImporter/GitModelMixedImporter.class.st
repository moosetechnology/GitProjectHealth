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

{ #category : #'import - pipelines' }
GitModelMixedImporter >> importAllPipelinesOfProject: aGLHProject [
	
	^ self apiImporter importAllPipelinesOfProject: aGLHProject
]

{ #category : #'import - commits' }
GitModelMixedImporter >> importAndLoadLatestsCommitsOfProject: aGLHProject [

	^ self localImporter importAndLoadLatestsCommitsOfProject: aGLHProject
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

	^ [
	  self localImporter importCommit: aCommitID ofProject: aGLHProject ]
		  on: LGit_GIT_ENOTFOUND
		  do: [
		  self apiImporter importCommit: aCommitID ofProject: aGLHProject ]
]

{ #category : #'import - commits' }
GitModelMixedImporter >> importCommitsOfBranch: aGLHBranch [

	^ self localImporter importCommitsOfBranch: aGLHBranch
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

{ #category : #'import - files' }
GitModelMixedImporter >> importFilesOfBranch: aGLHBranch [

	^ self localImporter importFilesOfBranch: aGLHBranch
]

{ #category : #'import - groups' }
GitModelMixedImporter >> importGroup: aGroupID [

	^ self apiImporter importGroup: aGroupID
]

{ #category : #'import - issues' }
GitModelMixedImporter >> importIssuesOfProject: aGLHProject [

	^ self apiImporter importIssuesOfProject: aGLHProject
]

{ #category : #'import - jobs' }
GitModelMixedImporter >> importJobsOfPipeline: aGLHPipeline [

	^ self apiImporter importJobsOfPipeline: aGLHPipeline
]

{ #category : #'import - commits' }
GitModelMixedImporter >> importLatestCommitsOfProject: aGLHProject [

	^ self localImporter importLatestCommitsOfProject: aGLHProject
]

{ #category : #'import - merge-requests' }
GitModelMixedImporter >> importLatestMergeRequestsOfProject: aGLHProject [

	^ self apiImporter importLatestMergeRequestsOfProject: aGLHProject
]

{ #category : #'import - pipelines' }
GitModelMixedImporter >> importLatestPipelinesOfProject: aGLHProject [

	^ self apiImporter importLatestPipelinesOfProject: aGLHProject
]

{ #category : #'import - releases' }
GitModelMixedImporter >> importLatestReleaseOfProject: aGLHProject [
	
	^ self apiImporter importLatestReleaseOfProject: aGLHProject
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
GitModelMixedImporter >> importMergeRequestsOfProject: aGLHProject [

	^ self apiImporter importMergeRequestsOfProject: aGLHProject
]

{ #category : #'import - merge-requests' }
GitModelMixedImporter >> importMergeRequestsOfProject: aGLHProject since: fromDate until: toDate [

	^ self apiImporter importMergeRequestsOfProject: aGLHProject since: fromDate until: toDate
]

{ #category : #'import - milestones' }
GitModelMixedImporter >> importMilestonesOfProject: aGLHProject [

	^ self apiImporter importMilestonesOfProject: aGLHProject
]

{ #category : #'import - notes' }
GitModelMixedImporter >> importNotesOfMergeRequest: mergeRequest [

	^ self apiImporter importNotesOfMergeRequest: mergeRequest
]

{ #category : #'import - pipelines' }
GitModelMixedImporter >> importPipeline: aPipelineId OfProject: aGLHProject [

	^ self apiImporter importPipeline: aPipelineId OfProject: aGLHProject

]

{ #category : #'import - merge-requests' }
GitModelMixedImporter >> importPipelinesOfProject: aGLHProject [

	^ self apiImporter importPipelinesOfProject: aGLHProject
]

{ #category : #'import - projects' }
GitModelMixedImporter >> importProject: id [

	^ self apiImporter importProject: id
]

{ #category : #'import - projects' }
GitModelMixedImporter >> importProjectsOfUser: aGLHUser [

	^ self apiImporter importProjectsOfUser: aGLHUser
]

{ #category : #'import - releases' }
GitModelMixedImporter >> importRelease: aReleaseID ofProject: aGLHProject [

	^ self apiImporter importRelease: aReleaseID ofProject: aGLHProject
]

{ #category : #'import - repositories' }
GitModelMixedImporter >> importRepository: aGLHRepository [

	^ self localImporter importRepository: aGLHRepository
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
