Class {
	#name : #ClosedTicketsMetric,
	#superclass : #UserJiraMetric,
	#category : #'GitLabHealth-Model-Analysis'
}

{ #category : #calculating }
ClosedTicketsMetric >> calculate [

	| groupedByDate dateOver |
	userMergeRequests ifNil: [ self load ].
	groupedByDate := self setupGroupedDate.


	userMergeRequests do: [ :userMergeRequest |
		dateOver := self transformDate: userMergeRequest created_at to: over.
		groupedByDate
			at: dateOver printString
			ifPresent: [ :value | value add: userMergeRequest ] ].

	groupedByDate := groupedByDate collect: [ :group | group size ].

	^ groupedByDate average asFloat
]

{ #category : #accessing }
ClosedTicketsMetric >> description [

	^ 'number of merge request with jira ticket closed'
]

{ #category : #accessing }
ClosedTicketsMetric >> name [

	^ 'closedTickets'
]
