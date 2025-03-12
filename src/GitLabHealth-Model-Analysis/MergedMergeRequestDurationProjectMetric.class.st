Class {
	#name : #MergedMergeRequestDurationProjectMetric,
	#superclass : #ProjectMetric,
	#category : #'GitLabHealth-Model-Analysis'
}

{ #category : #calculating }
MergedMergeRequestDurationProjectMetric >> calculate [

	| groupedByDate gitAnalyzer mergeRequestsValidation filterGroups |
	projectMergeRequests ifNil: [ self load ].

	groupedByDate := self setupGroupedDate.

	projectMergeRequests ifEmpty: [ ^ nil ].

	gitAnalyzer := GitAnalyzer new.

	mergeRequestsValidation := projectMergeRequests collect: [ :mr |
		                           gitAnalyzer
			                           analyseMergeResquestValidation: mr ].


	mergeRequestsValidation do: [ :dic |
		| overDate |
		overDate := self transformDate: (dic at: #merged_at) to: over.

		groupedByDate
			at: overDate printString
			ifPresent: [ :durations | durations add: (dic at: #duration) ] ].

	"deleting the empty array (merge request that are not merged )"
	filterGroups := groupedByDate reject: [ :array | array isEmpty ].
	"Check if filterGroups is empty before proceeding to avoid merge request out of analyse periode "
	filterGroups isEmpty ifTrue: [ ^ 0 ].

	filterGroups associations do: [ :assoc |
		| sum denominator |
		denominator := assoc value size.

		sum := assoc value sum: [ :v |
			       v ifNil: [
				       denominator := denominator - 1.
				       0 asDuration ] ].
		denominator = 0 ifTrue: [ denominator := 1 ].

		filterGroups at: assoc key put: sum / denominator ].

	^ filterGroups average asSeconds
]

{ #category : #accessing }
MergedMergeRequestDurationProjectMetric >> description [

	^ 'Merged Merge Request duration  (second)'
]

{ #category : #loading }
MergedMergeRequestDurationProjectMetric >> load [

	projectMergeRequests := self
	                      loadMergeRequestsSince:  (period at: #since)
	                      until:  (period at: #until)
]
