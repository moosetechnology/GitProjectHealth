Class {
	#name : #ReviewedByUserMergeRequestMetric,
	#superclass : #UserMergeRequestMetric,
	#category : #'GitLabHealth-Model-Analysis'
}

{ #category : #calculating }
ReviewedByUserMergeRequestMetric >> calculate [

	| groupedByDate mergedMergeRequest reviewedMergeRequests dateOver gitAnalyzer |
	userMergeRequests ifNil: [ self load ].
	groupedByDate := self setupGroupedDate.

	gitAnalyzer := GitAnalyzer new.

	mergedMergeRequest := userMergeRequests select: [ :mr |
		                      mr reviewers isNotEmpty  ].

	reviewedMergeRequests := mergedMergeRequest select: [
		                               :userMergeRequest |
		                               | validation |
		                               validation := gitAnalyzer
			                                             analyseMergeResquestValidation:
			                                             userMergeRequest.
		                               (userMergeRequest reviewers includes: user) ].

	reviewedMergeRequests do: [ :userMergeRequest |
		dateOver := self transformDate: userMergeRequest created_at to: over.

		groupedByDate
			at: dateOver printString
			ifPresent: [ :value | value add: userMergeRequest ] ].

	groupedByDate := groupedByDate collect: [ :group | group size ].

	^ groupedByDate average asFloat
]

{ #category : #accessing }
ReviewedByUserMergeRequestMetric >> description [

	^ 'number of merger request reviewed by the user'
]

{ #category : #loading }
ReviewedByUserMergeRequestMetric >> load [ 
		userMergeRequests := self
		                     loadCompleteMergeRequestsSince:
		                     (period at: #since)
		                     until: (period at: #until)
]

{ #category : #accessing }
ReviewedByUserMergeRequestMetric >> name [

	^ 'reviewedMergeRequest'
]
