Class {
	#name : #MergedMergeRequestWithoutReviewMetric,
	#superclass : #UserMetric,
	#category : #'GitLabHealth-Model-Analysis'
}

{ #category : #calculating }
MergedMergeRequestWithoutReviewMetric >> calculate [

	| groupedByDate mergedMergeRequest noVerificationMergeRequests dateOver gitAnalyzer |
	userMergeRequests ifNil: [ self load ].
	groupedByDate := self setupGroupedDate.

	gitAnalyzer := GitAnalyzer new.

	mergedMergeRequest := userMergeRequests select: [ :mr |
		                      mr merged_at isNotNil ].


	noVerificationMergeRequests := mergedMergeRequest select: [
		                               :userMergeRequest |
		                               | validation |
		                               validation := gitAnalyzer
			                                             analyseMergeResquestValidation:
			                                             userMergeRequest.

		                               userMergeRequest merge_user
		                               = userMergeRequest author and:
			                               (validation at: #duration)
			                               < 1 minutes ].


	noVerificationMergeRequests do: [ :userMergeRequest |
		dateOver := self transformDate: userMergeRequest created_at to: over.

		groupedByDate
			at: dateOver printString
			ifPresent: [ :value | value add: userMergeRequest ] ].


	groupedByDate := groupedByDate collect: [ :group | group size ].

	^ groupedByDate average asFloat
]

{ #category : #accessing }
MergedMergeRequestWithoutReviewMetric >> description [

	^ 'number of merge requests merged without review'
]

{ #category : #loading }
MergedMergeRequestWithoutReviewMetric >> load [

	userMergeRequests := user
		                     loadCompleteMergeRequestsSince:
		                     (period at: #since)
		                     until: (period at: #until)
]

{ #category : #accessing }
MergedMergeRequestWithoutReviewMetric >> name [

	^ 'mergeRequestMergedWithoutReview'
]
