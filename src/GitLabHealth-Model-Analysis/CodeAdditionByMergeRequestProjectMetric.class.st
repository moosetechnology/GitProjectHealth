Class {
	#name : #CodeAdditionByMergeRequestProjectMetric,
	#superclass : #ProjectMetric,
	#category : #'GitLabHealth-Model-Analysis'
}

{ #category : #calculating }
CodeAdditionByMergeRequestProjectMetric >> calculate [

	| groupedByDate dateOver |
	projectMergeRequests ifNil: [ self load ].

	groupedByDate := self setupGroupedDate.
	projectMergeRequests ifEmpty: [ ^ 0 ].


	projectMergeRequests  do: [ :mr |
		dateOver := self transformDate: mr created_at to: over.
		groupedByDate
			at: dateOver printString
			ifPresent: [ :value | value add: mr ] ].

	groupedByDate := groupedByDate collect: [ :group |
		                 | average |
		                 average := (group collect: [ :mergeRequest |
			                             mergeRequest commits sum: [ :commit |
				                             commit additions ] ]) average ].

	^ groupedByDate average asFloat
]

{ #category : #accessing }
CodeAdditionByMergeRequestProjectMetric >> description [

	^ 'average code addition by merge request'
]

{ #category : #loading }
CodeAdditionByMergeRequestProjectMetric >> load [

	projectMergeRequests := self
		                  loadProjectCompleteMergeRequestsSince: (period at: #since)
		                  until: (period at: #until)
]
