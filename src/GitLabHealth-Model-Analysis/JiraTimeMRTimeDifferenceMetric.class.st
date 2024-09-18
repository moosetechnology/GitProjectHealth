Class {
	#name : #JiraTimeMRTimeDifferenceMetric,
	#superclass : #UserJiraMetric,
	#category : #'GitLabHealth-Model-Analysis'
}

{ #category : #calculating }
JiraTimeMRTimeDifferenceMetric >> calculate [

	| groupedByDate dateOver |
	userMergeRequests ifNil: [ self load ].
	userMergeRequests ifEmpty: [ ^nil ].
	groupedByDate := self setupGroupedDate.

	userMergeRequests do: [ :userMergeRequest |
		dateOver := self transformDate: userMergeRequest created_at to: over.
		groupedByDate
			at: dateOver printString
			ifPresent: [ :value | value add: userMergeRequest ] ].

	groupedByDate := groupedByDate collect: [ :group |
		                 | differences |
		                 differences := group collect: [ :mergeRequest |
			                                | firstCommitDate mergeRequestTime jiraTime |
			                                firstCommitDate := mergeRequest
				                                                   commits last
				                                                   created_at.

			                                mergeRequestTime := mergeRequest
				                                                    merged_at
			                                                    -
			                                                    firstCommitDate.

			                                jiraTime := mergeRequest jiraIssue
				                                            timeOriginalEstimate
				                                            ifNil: [
				                                            mergeRequest jiraIssue
					                                            timeEstimate ]
				                                            ifNotNil: [
				                                            mergeRequest jiraIssue
					                                            timeOriginalEstimate ].

			                                (jiraTime - mergeRequestTime)
				                                asSeconds ].
		                 differences average ].

	^ groupedByDate average
]

{ #category : #accessing }
JiraTimeMRTimeDifferenceMetric >> description [

	^ 'average difference in seconds between jira estimate time and associated merge request time (time between first commit and merge date)'
]

{ #category : #loading }
JiraTimeMRTimeDifferenceMetric >> load [

	userMergeRequests := self
		                     loadUserCompleteMergeRequestsWithJiraIssueSince: (period at: #since)
		                     until: (period at: #until).

	"Take only the merge requests that have been merged and given a time estimate"
	userMergeRequests := userMergeRequests select: [ :mergeRequest |
		                     | issueIsEstimated |
		                     issueIsEstimated := mergeRequest jiraIssue
			                                         timeEstimate isNotNil or:
			                                         mergeRequest jiraIssue
				                                         timeOriginalEstimate
				                                         isNotNil.
		                     mergeRequest merged_at isNotNil and:
			                     issueIsEstimated ]
]
