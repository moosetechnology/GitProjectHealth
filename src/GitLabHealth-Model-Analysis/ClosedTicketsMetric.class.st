Class {
	#name : #ClosedTicketsMetric,
	#superclass : #UserMetric,
	#category : #'GitLabHealth-Model-Analysis'
}

{ #category : #calculating }
ClosedTicketsMetric >> calculate [

	| groupedByDate dateOver average |
	groupedByDate := self setupGroupedDate.


	userMergeRequests do: [ :userMergeRequest |
		dateOver := self transformDate: userMergeRequest created_at to: over.
		groupedByDate
			at: dateOver printString
			ifPresent: [ :value | value add: userMergeRequest ] ].

	groupedByDate := groupedByDate collect: [ :group | group size ].

	average := groupedByDate
		           ifEmpty: [ 0 ]
		           ifNotEmpty: [ groupedByDate average ].

	^ groupedByDate
]

{ #category : #accessing }
ClosedTicketsMetric >> description [

	^ 'number of merge request with jira ticket closed'
]

{ #category : #loading }
ClosedTicketsMetric >> load [

	self loadUserProjects.
	self loadUserMergeRequests.

	jiraImporter importAllCurrentAndPastIssuesOf:
		user commits anyOne author_email.

	GPJCConnector new
		gpModel: glhImporter glhModel;
		jiraModel: jiraImporter model;
		connect.

	userMergeRequests := userMergeRequests select: [ :mergeRequest |
		                     mergeRequest jiraIssue isNotNil ].
	
]

{ #category : #accessing }
ClosedTicketsMetric >> name [

	^ 'closedTickets'
]
