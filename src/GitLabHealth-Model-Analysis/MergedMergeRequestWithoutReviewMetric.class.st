Class {
	#name : #MergedMergeRequestWithoutReviewMetric,
	#superclass : #UserMetric,
	#category : #'GitLabHealth-Model-Analysis'
}

{ #category : #calculating }
MergedMergeRequestWithoutReviewMetric >> calculate [

	| groupedByDate mergedMergeRequest noVerificationMergeRequests dateOver gitAnalyzer |
	groupedByDate := self setupGroupedDate.

	gitAnalyzer := GitAnalyzer new glhImporter: glhImporter.

	mergedMergeRequest := userMergeRequests select: [ :mr |
		                      mr merged_at isNotNil ].


	noVerificationMergeRequests := mergedMergeRequest select: [
		                               :userMergeRequest |
		                               | validation |
		                               glhImporter
			                               importMergeResquestMerger:
			                               userMergeRequest.

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

	^ groupedByDate
]

{ #category : #accessing }
MergedMergeRequestWithoutReviewMetric >> description [

	^ 'number of merge requests merged without review'
]

{ #category : #loading }
MergedMergeRequestWithoutReviewMetric >> load [

	self loadUserProjects.
	self loadUserMergeRequests
]

{ #category : #accessing }
MergedMergeRequestWithoutReviewMetric >> name [

	^ 'mergeRequestMergedWithoutReview'
]
