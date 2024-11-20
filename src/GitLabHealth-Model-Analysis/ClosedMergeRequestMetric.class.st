Class {
	#name : #ClosedMergeRequestMetric,
	#superclass : #UserMergeRequestMetric,
	#category : 'GitLabHealth-Model-Analysis'
}

{ #category : #calculating }
ClosedMergeRequestMetric >> calculate [

	| groupedByDate dateOver |
	userMergeRequests ifNil: [ self load ].
	groupedByDate := self setupGroupedDate.
	
		userMergeRequests := userMergeRequests select: [ :userMergeRequest |
		                     userMergeRequest state = 'closed'  ].

	userMergeRequests do: [ :userMergeRequest |
		dateOver := self transformDate: userMergeRequest created_at to: over.

		groupedByDate
			at: dateOver printString
			ifPresent: [ :value | value add: userMergeRequest ] ].


	groupedByDate := groupedByDate collect: [ :group | group size ].

	^ groupedByDate average asFloat
]

{ #category : #accessing }
ClosedMergeRequestMetric >> description [

	^ 'number of closed merge requests'
]

{ #category : #accessing }
ClosedMergeRequestMetric >> name [

	^ 'closedMergeRequest'
]
