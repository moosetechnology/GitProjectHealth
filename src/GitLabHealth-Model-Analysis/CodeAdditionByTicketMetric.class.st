Class {
	#name : #CodeAdditionByTicketMetric,
	#superclass : #UserJiraMetric,
	#category : #'GitLabHealth-Model-Analysis'
}

{ #category : #calculating }
CodeAdditionByTicketMetric >> calculate [

	| groupedByDate dateOver |
	userMergeRequests ifNil: [ self load ].
	
	groupedByDate := self setupGroupedDate.
	userMergeRequests ifEmpty: [ ^ 0 ].


	userMergeRequests do: [ :userMergeRequest |
		dateOver := self transformDate: userMergeRequest created_at to: over.
		groupedByDate
			at: dateOver printString
			ifPresent: [ :value | value add: userMergeRequest ] ].

	groupedByDate := groupedByDate collect: [ :group |
		                 | average |
		                 average := (group collect: [ :mergeRequest |
			                             mergeRequest commits sum: [ :commit |
				                             commit additions ] ]) average ].

	^ groupedByDate average asFloat
]

{ #category : #accessing }
CodeAdditionByTicketMetric >> description [

	^ 'average code addition by merge request associated with a jira ticket'
]

{ #category : #loading }
CodeAdditionByTicketMetric >> load [

	userMergeRequests := self
		                     loadUserCompleteMergeRequestsWithJiraIssueSince:
		                     (period at: #since)
		                     until: (period at: #until)
]
