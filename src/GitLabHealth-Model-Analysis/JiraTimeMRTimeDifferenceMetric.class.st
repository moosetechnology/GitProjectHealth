Class {
	#name : #JiraTimeMRTimeDifferenceMetric,
	#superclass : #UserJiraMetric,
	#category : #'GitLabHealth-Model-Analysis'
}

{ #category : #calculating }
JiraTimeMRTimeDifferenceMetric >> calculate [

	| groupedByDate dateOver |
	userMergeRequests ifNil: [ self load ].
	groupedByDate := self setupGroupedDate.

	userMergeRequests := userMergeRequests select: [ :mergeRequest |
		                     | issueIsEstimated |
		                     issueIsEstimated := mergeRequest jiraIssue
			                                         timeEstimate isNotNil or:
			                                         mergeRequest jiraIssue
				                                         timeOriginalEstimate
				                                         isNotNil.
		                     mergeRequest merged_at isNotNil and:
			                     issueIsEstimated ].

	userMergeRequests do: [ :userMergeRequest |
		dateOver := self transformDate: userMergeRequest created_at to: over.
		groupedByDate
			at: dateOver printString
			ifPresent: [ :value | value add: userMergeRequest ] ].

	groupedByDate := groupedByDate collect: [ :group |
		                 group collect: [ :mergeRequest |
			                 | firstCommitDate mergeRequestTime jiraTime |
			                 firstCommitDate := mergeRequest commits last
				                                    created_at.

			                 mergeRequestTime := mergeRequest merged_at
			                                     - firstCommitDate.

			                 jiraTime := mergeRequest jiraIssue
				                             timeOriginalEstimate
				                             ifNil: [
				                             mergeRequest jiraIssue timeEstimate ]
				                             ifNotNil: [
				                             mergeRequest jiraIssue
					                             timeOriginalEstimate ].

			                 jiraTime - mergeRequestTime ] ].

	^groupedByDate average ifNil: [ nil ] ifNotNil: [ groupedByDate average ] 
]

{ #category : #accessing }
JiraTimeMRTimeDifferenceMetric >> description [

	^ 'average difference between jira estimate time and associated merge resquest time'
]

{ #category : #loading }
JiraTimeMRTimeDifferenceMetric >> load [

	userMergeRequests := self
		                     loadCompleteMergeRequestsWithJiraIssueOfUser: user
		                     since: (period at: #since)
		                     until: (period at: #until)
]
