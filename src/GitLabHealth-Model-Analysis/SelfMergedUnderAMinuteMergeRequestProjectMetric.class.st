Class {
	#name : #SelfMergedUnderAMinuteMergeRequestProjectMetric,
	#superclass : #ProjectMetric,
	#category : #'GitLabHealth-Model-Analysis'
}

{ #category : #calculating }
SelfMergedUnderAMinuteMergeRequestProjectMetric >> calculate [

	| groupedByDate gitAnalyzer mergedMergeRequest noVerificationMergeRequests |
	projectMergeRequests ifNil: [ self load ].
	groupedByDate := self setupGroupedDate.

	gitAnalyzer := GitAnalyzer new.

	mergedMergeRequest := projectMergeRequests select: [ :mr |
		                      mr merged_at isNotNil ].

	noVerificationMergeRequests := mergedMergeRequest select: [
		                               :userMergeRequest |
		                               | validation |
		                               validation := gitAnalyzer
			                                             analyseMergeResquestValidation:
			                                             userMergeRequest.
			
		                               userMergeRequest merge_user
		                               = userMergeRequest author and: [
			                               (validation at: #duration)
			                               < 1 minutes ] ].

	noVerificationMergeRequests do: [ :userMergeRequest |
		| dateOver |
		dateOver := self transformDate: userMergeRequest created_at to: over.
		groupedByDate
			at: dateOver printString
			ifPresent: [ :value | value add: userMergeRequest ] ].

	groupedByDate := groupedByDate collect: [ :group | group size ].

	^ groupedByDate average asFloat
]

{ #category : #accessing }
SelfMergedUnderAMinuteMergeRequestProjectMetric >> description [

	^ 'Merged merge requests merged by its author under a minute after creation'
]

{ #category : #loading }
SelfMergedUnderAMinuteMergeRequestProjectMetric >> load [

	projectMergeRequests := self
		                        loadMergeRequestsSince: (period at: #since)
		                        until: (period at: #until)
]

{ #category : #accessing }
SelfMergedUnderAMinuteMergeRequestProjectMetric >> name [

	^ 'ProjectSelfMergedUnderAMinuteMergeRequest'
]
