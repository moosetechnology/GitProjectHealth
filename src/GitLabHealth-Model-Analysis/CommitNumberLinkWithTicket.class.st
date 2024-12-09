Class {
	#name : #CommitNumberLinkWithTicket,
	#superclass : #UserJiraMetric,
	#category : #'GitLabHealth-Model-Analysis'
}

{ #category : #calculating }
CommitNumberLinkWithTicket >> calculate [

	| groupedByDate |
	userCommits ifNil: [ self load ].
	groupedByDate := self setupGroupedDate.

	userCommits do: [ :c |
		| dateOver |
		dateOver := self transformDate: c created_at to: over.
		groupedByDate at: dateOver printString ifPresent: [ :v | v add: c ] ].

	groupedByDate := groupedByDate collect: [ :group | group size ].

	^ groupedByDate average asFloat
]

{ #category : #accessing }
CommitNumberLinkWithTicket >> description [

	^ 'number of commits link a jira ticket'
]

{ #category : #loading }
CommitNumberLinkWithTicket >> load [

	| email |
	userCommits := self
		               loadUserCommitsSince: (period at: #since)
		               until: (period at: #until).
		
	email := self userEmail.

	jiraImporter importAllCurrentAndPastIssuesOf: email.

	GPJCConnector new
		gpModel: glhImporter glhModel;
		jiraModel: jiraImporter model;
		connect.

	^userCommits := userCommits select: [ :commit |
		  commit jiraIssue isNotNil ]
		
	
]
