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
	
	Halt now.

	userMergeRequests := userMergeRequests select: [ :mergeRequest |
		                     mergeRequest merged_at isNotNil ].

	userMergeRequests do: [ :userMergeRequest |
		dateOver := self transformDate: userMergeRequest created_at to: over.
		groupedByDate
			at: dateOver printString
			ifPresent: [ :value | value add: userMergeRequest ] ].

	groupedByDate := groupedByDate collect: [ :group |
		                 group collect: [ :mergeRequest |
			                 | mergeRequestBranch createdDate duration |
			                 mergeRequestBranch := STONJSON fromString:
				                                       (glhImporter glhApi
					                                        branchOfRepository:
					                                        mergeRequest project_id
					                                        withName:
					                                        mergeRequest
						                                        source_branch).

			                 createdDate := (mergeRequestBranch at: #commit)
				                                at: #created_at.

			                 duration := mergeRequest merged_at - createdDate.

			                 mergeRequest jiraIssue timeEstimate - duration ] ].

	^ groupedByDate average asFloat
]

{ #category : #accessing }
JiraTimeMRTimeDifferenceMetric >> description [

	^ 'average difference between jira estimate time and associated merge resquest time'
]
