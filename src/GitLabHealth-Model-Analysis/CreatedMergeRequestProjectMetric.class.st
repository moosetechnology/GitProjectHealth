Class {
	#name : #CreatedMergeRequestProjectMetric,
	#superclass : #ProjectMetric,
	#category : #'GitLabHealth-Model-Analysis'
}

{ #category : #calculating }
CreatedMergeRequestProjectMetric >> calculate [

	| groupedByDate |
	projectMergeRequests ifNil: [ self load ].

	groupedByDate := self setupGroupedDate.

	projectMergeRequests do: [ :c | 
		| dateOver |
		dateOver := self transformDate: c created_at to: over.
		groupedByDate at: dateOver printString ifPresent: [ :v | v add: c ] ].

	groupedByDate := groupedByDate collect: [ :group | group size ].

	^ groupedByDate average asFloat
]

{ #category : #accessing }
CreatedMergeRequestProjectMetric >> description [

	^ 'Merge frequency (avg) for a project '
]

{ #category : #loading }
CreatedMergeRequestProjectMetric >> load [

	projectMergeRequests := self
	                      loadMergeRequestsSince:  (period at: #since)
	                      until:  (period at: #until)
]
