Class {
	#name : #ProjectMetric,
	#superclass : #Metric,
	#instVars : [
		'project',
		'projectCommits',
		'projectMergeRequests'
	],
	#category : #'GitLabHealth-Model-Analysis'
}

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

	| cacheSymbol allCommits |
	glhImporter withCommitDiffs: false.

	cacheSymbol := self
		               cacheSymbolFor: GLHMergeRequest 
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

{ #category : #accessing }
ProjectMetric >> project [

	^ project
]

{ #category : #accessing }
ProjectMetric >> project: anObject [

	project := anObject
]
