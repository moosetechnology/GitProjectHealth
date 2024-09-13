Class {
	#name : #MergeRequestDurationMetric,
	#superclass : #UserMergeRequestMetric,
	#category : #'GitLabHealth-Model-Analysis'
}

{ #category : #calculating }
MergeRequestDurationMetric >> calculate [

	| groupedByDate gitAnalyzer mergeRequestsValidation filterGroups |
	userMergeRequests ifNil: [ self load ].
	groupedByDate := self setupGroupedDate.

	userMergeRequests ifEmpty: [ ^ nil ].

	gitAnalyzer := GitAnalyzer new.

	mergeRequestsValidation := userMergeRequests collect: [ :mr |
		                           gitAnalyzer
			                           analyseMergeResquestValidation: mr ].


	mergeRequestsValidation do: [ :dic |
		| overDate |
		overDate := self transformDate: (dic at: #created_at) to: over.

		groupedByDate
			at: overDate printString
			ifPresent: [ :durations | durations add: (dic at: #duration) ]
			ifAbsentPut: [
				OrderedCollection new
					add: (dic at: #duration);
					yourself ] ].


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
MergeRequestDurationMetric >> description [

	^ 'average time to merge a merge request (in seconds)'
]

{ #category : #accessing }
MergeRequestDurationMetric >> name [

	^ 'mergeRequestDuration'
]
