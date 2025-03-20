Class {
	#name : #UserMergeRequestMetric,
	#superclass : #UserMetric,
	#category : #'GitLabHealth-Model-Analysis'
}

{ #category : #testing }
UserMergeRequestMetric class >> isAbstract [

	^ self == UserMergeRequestMetric
]

{ #category : #calculating }
UserMergeRequestMetric >> calculate [

	^ self subclassResponsibility
]

{ #category : #accessing }
UserMergeRequestMetric >> description [

	^ self subclassResponsibility
]

{ #category : #loading }
UserMergeRequestMetric >> load [

	userMergeRequests := self
		                     loadUserMergeRequestsSince: (period at: #since)
		                     until: (period at: #until).
]
