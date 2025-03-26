Class {
	#name : #UserCommitsMetric,
	#superclass : #UserMetric,
	#category : #'GitLabHealth-Model-Analysis'
}

{ #category : #testing }
UserCommitsMetric class >> isAbstract [

	^ self == UserCommitsMetric
]

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
		               loadUserCommitsSince: (period at: #since)
		               until: (period at: #until)
]
