Class {
	#name : #UserJiraMetric,
	#superclass : #UserMetric,
	#category : #'GitLabHealth-Model-Analysis'
}

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
		                     loadMergeRequestsWithJiraIssueSince:
		                     (period at: #since)
		                     until: (period at: #until)
]

{ #category : #accessing }
UserJiraMetric >> name [

	^ self subclassResponsibility
]
