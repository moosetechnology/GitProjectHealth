Class {
	#name : #MergedMergeRequestMetric,
	#superclass : #UserMetric,
	#category : #'GitLabHealth-Model-Analysis'
}

{ #category : #calculating }
MergedMergeRequestMetric >> calculate [

	| groupedByDate userMergedMergeRequests dateOver |
		userMergeRequests ifNil: [ self load ].
	groupedByDate := self setupGroupedDate.

	userMergedMergeRequests := userMergeRequests select: [
		                           :userMergeRequest |
		                           userMergeRequest merged_at isNotNil ].

	userMergedMergeRequests do: [ :userMergeRequest |
		dateOver := self transformDate: userMergeRequest created_at to: over.
		groupedByDate
			at: dateOver printString
			ifPresent: [ :value | value add: userMergeRequest ] ].
	groupedByDate := groupedByDate collect: [ :group | group size ].

	^ groupedByDate average asFloat
]

{ #category : #accessing }
MergedMergeRequestMetric >> description [

	^ 'number of merged merge request'
]

{ #category : #loading }
MergedMergeRequestMetric >> load [

	
	userMergeRequests := user
		                     loadMergeRequestsSince: (period at: #since)
		                     until: (period at: #until)
]

{ #category : #accessing }
MergedMergeRequestMetric >> name [

	^ 'mergedMergeRequest'
]
