Class {
	#name : #CommitsNumberByJiraTicketsMetric,
	#superclass : #UserJiraMetric,
	#category : #'GitLabHealth-Model-Analysis'
}

{ #category : #calculating }
CommitsNumberByJiraTicketsMetric >> calculate [

	| groupedByDate dateOver |
	userMergeRequests ifNil: [ self load ].
	userMergeRequests ifEmpty: [ ^ 0 ].
	groupedByDate := self setupGroupedDate.
	userMergeRequests do: [ :userMergeRequest |
		dateOver := self transformDate: userMergeRequest created_at to: over.
		groupedByDate
			at: dateOver printString
			ifPresent: [ :value | value add: userMergeRequest ] ].
	groupedByDate := groupedByDate collect: [ :group |
		                 | average |
		                 average := (group collect: [ :mergeRequest |
			                             mergeRequest commits size ]) average ].
	^ groupedByDate average asFloat
]

{ #category : #accessing }
CommitsNumberByJiraTicketsMetric >> description [

	^ 'average number of commit by merge request associated to a jira ticket'
]

{ #category : #loading }
CommitsNumberByJiraTicketsMetric >> load [

	userMergeRequests := self
		                     loadUserCompleteMergeRequestsWithJiraIssueSince:
		                     (period at: #since)
		                     until: (period at: #until).
]
