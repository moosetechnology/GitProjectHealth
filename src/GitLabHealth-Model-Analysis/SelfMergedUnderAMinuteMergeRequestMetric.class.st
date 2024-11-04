Class {
	#name : #SelfMergedUnderAMinuteMergeRequestMetric,
	#superclass : #UserMergeRequestMetric,
	#category : 'GitLabHealth-Model-Analysis'
}

{ #category : #calculating }
SelfMergedUnderAMinuteMergeRequestMetric >> calculate [

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
SelfMergedUnderAMinuteMergeRequestMetric >> description [

	^ 'number of merge requests merged by its author under a minute after creation'
]

{ #category : #loading }
SelfMergedUnderAMinuteMergeRequestMetric >> load [

	userMergeRequests := self
		                     loadUserCompleteMergeRequestsSince:
		                     (period at: #since)
		                     until: (period at: #until)
]

{ #category : #accessing }
SelfMergedUnderAMinuteMergeRequestMetric >> name [

	^ 'SelfMergedUnderAMinuteMergeRequest'
]
