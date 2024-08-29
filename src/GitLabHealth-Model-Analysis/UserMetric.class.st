Class {
	#name : #UserMetric,
	#superclass : #Metric,
	#instVars : [
		'user',
		'userProjects',
		'userCommits',
		'userMergeRequests'
	],
	#category : #'GitLabHealth-Model-Analysis'
}

{ #category : #utils }
UserMetric >> cacheSymbolFor: anEntityType since: since until: until [

	^ (anEntityType printString , ' since ' , since printString , ' to '
	   , until printString) asSymbol
]

{ #category : #calculating }
UserMetric >> calculate [

	^ self subclassResponsibility
]

{ #category : #accessing }
UserMetric >> description [

	^ self subclassResponsibility
]

{ #category : #initialization }
UserMetric >> initialize [
	over := Date
]

{ #category : #loading }
UserMetric >> load [

	^ self subclassResponsibility
]

{ #category : #loading }
UserMetric >> loadUserCommits [
	
	userCommits := user loadCommitsSince: (period at: #since) until: (period at: #until) 
]

{ #category : #loading }
UserMetric >> loadUserMergeRequests [

	| mergeRequests cacheSymbol |
	glhImporter withCommitDiffs: false.
	cacheSymbol := self
		          cacheSymbolFor: GLPHEMergeRequest
		          since: (period at: #since)
		          until: (period at: #until).

	mergeRequests := userProjects collect: [ :project |
		                 | mr |
		                 project cacheAt: cacheSymbol ifAbsentPut: [
			                 mr := glhImporter
				                       importMergeRequests: project
				                       since: (period at: #since)
				                       until: (period at: #until).
			                 mr ] ].

	mergeRequests := mergeRequests flattened.
	glhImporter withCommitDiffs: true.

	mergeRequests do: [ :mr | glhImporter importMergeResquestAuthor: mr ].

	userMergeRequests := mergeRequests select: [ :mergeRequest |
		                     mergeRequest author = user ].
	^ userMergeRequests
]

{ #category : #loading }
UserMetric >> loadUserProjects [

	userProjects := glhImporter importContributedProjectsOfUser: user.
	
	userProjects do: [ :project | glhImporter completeImportProject: project]
]

{ #category : #accessing }
UserMetric >> name [

	^ self subclassResponsibility
]

{ #category : #accessing }
UserMetric >> user: anObject [

	user := anObject
]
