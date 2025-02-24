Class {
	#name : #MergedMergeRequestProjectMetric,
	#superclass : #ProjectMetric,
	#category : #'GitLabHealth-Model-Analysis'
}

{ #category : #calculating }
MergedMergeRequestProjectMetric >> calculate [

	| groupedByDate |
	projectMergeRequests ifNil: [ self load ].

	groupedByDate := self setupGroupedDate.

(projectMergeRequests select: [ :mr| mr state= #merged ]) do: [ :c |
		| dateOver |
		dateOver := self transformDate: c merged_at to: over.
		groupedByDate at: dateOver printString ifPresent: [ :v | v add: c ] ].

	groupedByDate := groupedByDate collect: [ :group | group size ].

	^ groupedByDate average asFloat
]

{ #category : #accessing }
MergedMergeRequestProjectMetric >> description [

	^ 'Merged Merge Request (avg)'
]

{ #category : #loading }
MergedMergeRequestProjectMetric >> load [

	projectMergeRequests := self
		                  loadMergeRequestsSince:   (period at: #since)
		                  until: (period at: #until)
]
