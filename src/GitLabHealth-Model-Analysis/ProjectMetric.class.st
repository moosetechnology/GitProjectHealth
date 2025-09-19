Class {
	#name : #ProjectMetric,
	#superclass : #Metric,
	#instVars : [
		'project',
		'projectCommits',
		'projectMergeRequests',
		'projectBranches',
		'projectTags',
		'filteredTags'
	],
	#category : #'GitLabHealth-Model-Analysis'
}

{ #category : #testing }
ProjectMetric class >> isAbstract [

	^ self == ProjectMetric
]

{ #category : #loading }
ProjectMetric >> loadAllTags [

	^ glhImporter importTagsForProject: project
]

{ #category : #load }
ProjectMetric >> loadBranchesSince: since until: until [ 


	^	glhImporter importBranchesOf: project.
	
]

{ #category : #loading }
ProjectMetric >> loadCommitsSince: since until: until [

	| cacheSymbol allCommits |
	glhImporter withCommitDiffs: false.

	cacheSymbol := self
		               cacheSymbolFor: GLHCommit
		               since: since
		               until: until.

	"download commits unless project cache is not empty"
	allCommits := project repository
			              cacheAt: cacheSymbol
			              ifAbsentPut: [
				              | foundCommits |
				              foundCommits := glhImporter
					                              importCommitsOfProject: project
					                              since: since
					                              until: until.
				              foundCommits ].

	allCommits do: [ :commit | glhImporter importCreatorOfCommit: commit ].
	glhImporter chainsCommitsFrom: allCommits.
	glhImporter withCommitDiffs: true.

	^ allCommits
]

{ #category : #loading }
ProjectMetric >> loadMergeRequestsSince: since until: until [

	| cacheSymbol allMergeRequests |
	glhImporter withCommitDiffs: false.

	cacheSymbol := self
		               cacheSymbolFor: GLHMergeRequest 
		               since: since
		               until: until.

	"download mergerequest unless project cache is not empty"
	allMergeRequests := project repository
		                    cacheAt: cacheSymbol
		                    ifAbsentPut: [
			                    | foundMergeRequests |
			                    foundMergeRequests := glhImporter
				                                          importMergeRequestsOfProject:
				                                          project
				                                          since: since
				                                          until: until.
			                    foundMergeRequests ].

	glhImporter withCommitDiffs: true.

	^ allMergeRequests
	

]

{ #category : #loading }
ProjectMetric >> loadProjectCompleteMergeRequestsSince: since until: until [

	| mergeRequests |
    mergeRequests := self loadProjectMergeRequestsSince:  since until: until.

	mergeRequests do: [ :mergeRequest |
		glhImporter importMergeResquestMerger: mergeRequest.
		glhImporter importMergeRequestCommits: mergeRequest ].

	^ mergeRequests
]

{ #category : #loading }
ProjectMetric >> loadProjectMergeRequestsSince: since until: until [

	| mergeRequests |
	 mergeRequests := self loadMergeRequestsSince: since until: until.

	^ mergeRequests select: [ :mergeRequest | mergeRequest project = project  ]
]

{ #category : #accessing }
ProjectMetric >> project [

	^ project
]

{ #category : #accessing }
ProjectMetric >> project: anObject [

	project := anObject
]
