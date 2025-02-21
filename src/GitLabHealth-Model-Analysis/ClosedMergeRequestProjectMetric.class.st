Class {
	#name : #ClosedMergeRequestProjectMetric,
	#superclass : #ProjectMetric,
	#category : #'GitLabHealth-Model-Analysis'
}

{ #category : #calculating }
ClosedMergeRequestProjectMetric >> calculate [

	| groupedByDate |
	projectMergeRequests ifNil: [ self load ].

	groupedByDate := self setupGroupedDate.

	(projectMergeRequests select: [ :mr| mr state= #closed ]) do: [ :c |
		| dateOver |
		dateOver := self transformDate: c closed_at to: over.
		groupedByDate at: dateOver printString ifPresent: [ :v | v add: c ] ].

	groupedByDate := groupedByDate collect: [ :group | group size ].

	^ groupedByDate average asFloat
]

{ #category : #accessing }
ClosedMergeRequestProjectMetric >> description [

	^ 'Closed Merge Request (avg)'
]

{ #category : #loading }
ClosedMergeRequestProjectMetric >> load [

	projectMergeRequests := self
		                  loadMergeRequestsSince:  (period at: #since)
		                  until: (period at: #until)
]
