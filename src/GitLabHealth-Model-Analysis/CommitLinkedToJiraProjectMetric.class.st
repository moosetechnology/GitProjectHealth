Class {
	#name : #CommitLinkedToJiraProjectMetric,
	#superclass : #ProjectMetric,
	#instVars : [
		'issues'
	],
	#category : #'GitLabHealth-Model-Analysis'
}

{ #category : #calculating }
CommitLinkedToJiraProjectMetric >> calculate [

	| groupedByDate dateOver |
	projectCommits ifNil: [ self load ].
	projectCommits := projectCommits reject: [ :commit |
		                  commit jiraIssue isNil ].
	projectCommits ifEmpty: [ ^ 0 ].

	groupedByDate := self setupGroupedDate.
	projectCommits do: [ :mr |
		dateOver := self transformDate: mr created_at to: over.

		groupedByDate
			at: dateOver printString
			ifPresent: [ :value | value add: mr ] ].

	groupedByDate := groupedByDate collect: [ :group |
		                 | average |
		                 average := group
			                            ifEmpty: [ 0 ]
			                            ifNotEmpty: [ group size ].
		                 average ].

	^ groupedByDate average asFloat
]

{ #category : #accessing }
CommitLinkedToJiraProjectMetric >> description [

	^ 'number of commits linked to a jira ticket'
]

{ #category : #loading }
CommitLinkedToJiraProjectMetric >> load [

	projectCommits := self
		                  loadCommitsSince: (period at: #since)
		                  until: (period at: #until).
	self loadCommitRequestIssues: projectCommits
]

{ #category : #issue }
CommitLinkedToJiraProjectMetric >> loadCommitRequestIssues: aCommitCollection [

	aCommitCollection do: [ :commit |
		| id |
		id := GPJCConnector new jiraKeyFromCommitMessage: commit message.
		jiraImporter importIssue: id.
		GPJCConnector new
			gpModel: glhImporter glhModel;
			jiraModel: jiraImporter model;
			connect ]
]
