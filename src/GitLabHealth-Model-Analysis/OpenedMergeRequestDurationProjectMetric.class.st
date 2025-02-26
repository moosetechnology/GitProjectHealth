Class {
	#name : #OpenedMergeRequestDurationProjectMetric,
	#superclass : #ProjectMetric,
	#category : #'GitLabHealth-Model-Analysis'
}

{ #category : #calculating }
OpenedMergeRequestDurationProjectMetric >> calculate [

	| groupedByDate gitAnalyzer mergeRequestsValidation filterGroups  |
	projectMergeRequests ifNil: [ self load ].
	
	groupedByDate := self setupGroupedDate.

	projectMergeRequests ifEmpty: [ ^ nil ].

	gitAnalyzer := GitAnalyzer new.

	mergeRequestsValidation := projectMergeRequests  collect: [ :mr |
		                           gitAnalyzer
			                           analyseMergeResquestValidation: mr ].


	mergeRequestsValidation do: [ :dic |
		| overDate |
		overDate := self transformDate: (dic at: #created_at) to: over.

		groupedByDate
			at: overDate printString
			ifPresent: [ :durations | durations add: (dic at: #open_duration) ]
			ifAbsentPut: [
				OrderedCollection new
					add: (dic at: #open_duration);
					yourself ] ].

     "deleting the empty array"
	filterGroups := groupedByDate reject: [ :array | array isEmpty ].

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
OpenedMergeRequestDurationProjectMetric >> description [

	^ ' duration of a Merge Request since it creation  (second)'
]

{ #category : #loading }
OpenedMergeRequestDurationProjectMetric >> load [

	projectMergeRequests := self
	                      loadMergeRequestsSince:  (period at: #since)
	                      until:  (period at: #until)
]
