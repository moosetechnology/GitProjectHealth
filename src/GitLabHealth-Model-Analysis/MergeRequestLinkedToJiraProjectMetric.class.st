Class {
	#name : #MergeRequestLinkedToJiraProjectMetric,
	#superclass : #ProjectMetric,
	#instVars : [
		'issues'
	],
	#category : #'GitLabHealth-Model-Analysis'
}

{ #category : #calculating }
MergeRequestLinkedToJiraProjectMetric >> calculate [

	| groupedByDate dateOver |
	projectMergeRequests ifNil: [ self load ].
	projectMergeRequests := projectMergeRequests reject: [ :mr |
		                        mr jiraIssue isNil ].
	projectMergeRequests ifEmpty: [ ^ 0 ].

	groupedByDate := self setupGroupedDate.
	projectMergeRequests do: [ :mr |
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
MergeRequestLinkedToJiraProjectMetric >> description [

	^ 'number of merged merge request linked to a jira ticket'
]

{ #category : #loading }
MergeRequestLinkedToJiraProjectMetric >> load [

	projectMergeRequests := self
		                        loadProjectCompleteMergeRequestsSince:
		                        (period at: #since)
		                        until: (period at: #until).

	projectMergeRequests := projectMergeRequests select: [ :mergeRequest |
		                        mergeRequest state = #merged and: [
			                        mergeRequest merged_at isNotNil ] ].

	self loadMergeRequestIssues: projectMergeRequests
]

{ #category : #issue }
MergeRequestLinkedToJiraProjectMetric >> loadMergeRequestIssues: aMergeRequestCollection [

	aMergeRequestCollection do: [ :mr |
		| id |
		id := GPJCConnector new jiraKeyFromCommitMessage: mr title.
		jiraImporter importIssue: id.
		GPJCConnector new
			gpModel: glhImporter glhModel;
			jiraModel: jiraImporter model;
			connect ]
]
