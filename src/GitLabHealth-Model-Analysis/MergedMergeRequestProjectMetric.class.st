Class {
	#name : #MergedMergeRequestProjectMetric,
	#superclass : #ProjectMetric,
	#category : #'GitLabHealth-Model-Analysis'
}

{ #category : #'as yet unclassified' }
MergedMergeRequestProjectMetric >> calculate [

	| groupedByDate |
	projectMergeRequests ifNil: [ self load ].

	groupedByDate := self setupGroupedDate.

	projectMergeRequests
		select: [ :mr | mr state = #merged ]
		thenDo: [ :c |
			| dateOver |
			dateOver := self transformDate: c merged_at to: over.
			groupedByDate at: dateOver printString ifPresent: [ :v | v add: c ] ].

	groupedByDate := groupedByDate collect: [ :group | group size ].

	^ groupedByDate average asFloat
]

{ #category : #'as yet unclassified' }
MergedMergeRequestProjectMetric >> description [

	^ 'Merged Merge Request (avg)'
]

{ #category : #'as yet unclassified' }
MergedMergeRequestProjectMetric >> load [

	projectMergeRequests := self
		                  loadMergeRequestsSince:   (period at: #since)
		                  until: (period at: #until)
]

