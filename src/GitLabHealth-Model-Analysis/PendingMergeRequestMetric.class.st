Class {
	#name : #PendingMergeRequestMetric,
	#superclass : #UserMergeRequestMetric,
	#category : 'GitLabHealth-Model-Analysis'
}

{ #category : #calculating }
PendingMergeRequestMetric >> calculate [

	| groupedByDate userMergedMergeRequests dateOver |
		userMergeRequests ifNil: [ self load ].
	groupedByDate := self setupGroupedDate.

	userMergedMergeRequests := userMergeRequests select: [
		                           :userMergeRequest |
		                           userMergeRequest state = 'opened'  ].

	userMergedMergeRequests do: [ :userMergeRequest |
		"here we look at the specific date of its merged"
		dateOver := self transformDate: userMergeRequest created_at to: over.
		groupedByDate
			at: dateOver printString
			ifPresent: [ :value | value add: userMergeRequest ] ].
	groupedByDate := groupedByDate collect: [ :group | group size ].

	^ groupedByDate average asFloat
]

{ #category : #accessing }
PendingMergeRequestMetric >> description [

	^ 'number of merge request opened during a period and left opened at the end of it'
]

{ #category : #accessing }
PendingMergeRequestMetric >> name [ 
	^'pendingMergeRequest'
]
