Class {
	#name : #UserMetric,
	#superclass : #Metric,
	#instVars : [
		'user',
		'userProjects',
		'userCommits'
	],
	#category : #'GitLabHealth-Model-Analysis'
}

{ #category : #'as yet unclassified' }
UserMetric >> cacheSymbolFor: anEntityType since: since until: until [

	^ (anEntityType printString , ' since ' , since printString , ' to '
	   , until printString) asSymbol
]

{ #category : #'as yet unclassified' }
UserMetric >> calculate [

	^ self subclassResponsibility
]

{ #category : #loading }
UserMetric >> load [

	^ self subclassResponsibility
]

{ #category : #'as yet unclassified' }
UserMetric >> loadUserCommits [

	| allCommits cacheSymbol |
	userProjects ifNil: [ self loadUserProjects ].
	glhImporter withCommitDiffs: false.

	cacheSymbol := self
		               cacheSymbolFor: GLHCommit
		               since: (period at: #since)
		               until: (period at: #until).

	"download commits unless project cache is not empty"
	allCommits := userProjects collect: [ :project |
									
				              glhImporter
					                              importCommitsOProject: project
					                              since: (period at: #since)
					                              until: (period at: #until).
				              ].

	allCommits := allCommits flatten.
	allCommits do: [ :commit | glhImporter importCreatorOfCommit: commit ].
	glhImporter chainsCommitsFrom: allCommits.
	glhImporter withCommitDiffs: true.

	^ userCommits := allCommits reject: [ :commit |
		                 commit commitCreator ~= user ]
]

{ #category : #'as yet unclassified' }
UserMetric >> loadUserProjects [

	userProjects := glhImporter importContributedProjectsOfUser: user.
	
	userProjects do: [ :project | glhImporter completeImportProject: project]
]

{ #category : #accessing }
UserMetric >> user: anObject [

	user := anObject
]
