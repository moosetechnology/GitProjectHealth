Class {
	#name : #JiraTimeMRTimeDifferenceProjectMetric,
	#superclass : #ProjectMetric,
	#instVars : [
		'issues'
	],
	#category : #'GitLabHealth-Model-Analysis'
}

{ #category : #calculating }
JiraTimeMRTimeDifferenceProjectMetric >> calculate [

	| groupedByDate dateOver jiraID |
	projectMergeRequests ifNil: [ self load ].
	projectMergeRequests := projectMergeRequests reject: [:mr | mr jiraIssue isNil or: [(mr jiraIssue timeOriginalEstimate ifNil: [mr jiraIssue timeEstimate ]) isNil]].
	projectMergeRequests ifEmpty: [ ^ nil ].

	groupedByDate := self setupGroupedDate.

	projectMergeRequests do: [ :mr |
		dateOver := self transformDate: mr created_at to: over.

		"Extraction de l'ID du ticket Jira depuis le titre du mr"
		jiraID := GPJCConnector new jiraKeyFromCommitMessage: mr title.

		groupedByDate
			at: dateOver printString
			ifPresent: [ :value | value add: mr ] ].

	groupedByDate := groupedByDate collect: [ :group |
		                 | differences average |
		                 differences := group collect: [ :mergeRequest |
			                                | firstCommitDate mergeRequestTime jiraTime jiraIssue |
			                                jiraIssue := mergeRequest jiraIssue.


			                                firstCommitDate := mergeRequest
				                                                   commits last
				                                                   created_at.
			                                mergeRequestTime := mergeRequest
				                                                    merged_at
			                                                    -
			                                                    firstCommitDate.


			                                jiraTime := jiraIssue
				                                            timeOriginalEstimate
				                                            ifNil: [
				                                            jiraIssue timeEstimate ].

			                                (jiraTime - mergeRequestTime)
				                                asSeconds ].

		                 average := group
			                            ifEmpty: [ 0 ]
			                            ifNotEmpty: [ differences average ].
		                 average ].

	^ groupedByDate average asFloat
]

{ #category : #accessing }
JiraTimeMRTimeDifferenceProjectMetric >> description [

	^ 'average difference in seconds between jira estimate time and associated merge request time '
]

{ #category : #loading }
JiraTimeMRTimeDifferenceProjectMetric >> load [

	projectMergeRequests := self
		                     loadProjectCompleteMergeRequestsSince:  (period at: #since)
		                     until: (period at: #until).
	
	projectMergeRequests := projectMergeRequests select: [ :mergeRequest |
		                     mergeRequest state = #merged and:
			                     [mergeRequest merged_at isNotNil] ].
	
	self loadMergeRequestIssues: projectMergeRequests .
	
]

{ #category : #issue }
JiraTimeMRTimeDifferenceProjectMetric >> loadMergeRequestIssues: aMergeRequestCollection [
	
	 (aMergeRequestCollection do: [ :mr | 
		|id|
		id := GPJCConnector new jiraKeyFromCommitMessage: mr title .
		jiraImporter importIssue: id.      
		GPJCConnector new gpModel: glhImporter glhModel; jiraModel: jiraImporter model; connect.
		 ]).
]
