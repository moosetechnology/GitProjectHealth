Class {
	#name : #ClosedMergeRequestMetric,
	#superclass : #UserMetric,
	#category : #'GitLabHealth-Model-Analysis'
}

{ #category : #calculating }
ClosedMergeRequestMetric >> calculate [

	| groupedByDate userClosedMergeRequests dateOver |
	groupedByDate := self setupGroupedDate.

	userClosedMergeRequests := userMergeRequests select: [
		                           :userMergeRequest |
		                           userMergeRequest merged_at isNil and:
			                           userMergeRequest state = 'closed' ].

	userClosedMergeRequests do: [ :userMergeRequest |
		dateOver := self transformDate: userMergeRequest created_at to: over.

		groupedByDate
			at: dateOver printString
			ifPresent: [ :value | value add: userMergeRequest ] ].


	groupedByDate := groupedByDate collect: [ :group | group size ].
 

	^ groupedByDate average asFloat
]

{ #category : #accessing }
ClosedMergeRequestMetric >> description [

	^ 'number of merge requests closed and not merged'
]

{ #category : #loading }
ClosedMergeRequestMetric >> load [

	self loadUserProjects.
	self loadUserMergeRequests
]

{ #category : #accessing }
ClosedMergeRequestMetric >> name [

	^ 'closedMergeRequest'
]
