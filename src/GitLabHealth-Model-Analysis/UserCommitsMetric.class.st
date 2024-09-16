Class {
	#name : #UserCommitsMetric,
	#superclass : #UserMetric,
	#category : #'GitLabHealth-Model-Analysis'
}

{ #category : #calculating }
UserCommitsMetric >> calculate [

	^ self subclassResponsibility
]

{ #category : #accessing }
UserCommitsMetric >> description [

	^ self subclassResponsibility
]

{ #category : #loading }
UserCommitsMetric >> load [

	userCommits := self
		               loadCommitsSince: (period at: #since)
		               until: (period at: #until)
]

{ #category : #accessing }
UserCommitsMetric >> name [

	^ self subclassResponsibility
]
