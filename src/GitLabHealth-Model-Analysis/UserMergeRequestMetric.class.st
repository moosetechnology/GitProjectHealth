Class {
	#name : #UserMergeRequestMetric,
	#superclass : #UserMetric,
	#category : #'GitLabHealth-Model-Analysis'
}

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

{ #category : #accessing }
UserMergeRequestMetric >> name [

	^ self class name asString
]
