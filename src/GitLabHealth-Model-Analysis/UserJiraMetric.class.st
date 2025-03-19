Class {
	#name : #UserJiraMetric,
	#superclass : #UserMetric,
	#category : #'GitLabHealth-Model-Analysis'
}

{ #category : #testing }
UserJiraMetric class >> isAbstract [

	^ self == UserJiraMetric
]

{ #category : #calculating }
UserJiraMetric >> calculate [

	^ self subclassResponsibility
]

{ #category : #accessing }
UserJiraMetric >> description [

	^ self subclassResponsibility
]

{ #category : #loading }
UserJiraMetric >> load [

	userMergeRequests := self
		                     loadUserMergeRequestsWithJiraIssueSince: (period at: #since)
		                     until: (period at: #until)
]
