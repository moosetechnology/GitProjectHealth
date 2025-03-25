Class {
	#name : #CodeAdditionDuringAndByMergeRequestProjectMetric,
	#superclass : #ProjectMetric,
	#category : #'GitLabHealth-Model-Analysis'
}

{ #category : #'as yet unclassified' }
CodeAdditionDuringAndByMergeRequestProjectMetric >> calculate [

	| groupedByDate dateOver |
	projectMergeRequests ifNil: [ self load ].

	groupedByDate := self setupGroupedDate.
	projectMergeRequests ifEmpty: [ ^ 0 ].
	projectMergeRequests := projectMergeRequests select: [ :mr |
		                        mr state = #merged ].
	projectMergeRequests do: [ :mr |
		dateOver := self transformDate: mr created_at to: over.
		groupedByDate
			at: dateOver printString
			ifPresent: [ :value | value add: mr ] ].

	groupedByDate := groupedByDate collect: [ :group |
		                 group ifEmpty: [ 0 ] ifNotEmpty: [
			                 (group collect: [ :mergeRequest |
				                  mergeRequest commits sum: #additions ]) average ] ].

	^ groupedByDate average asFloat
]

{ #category : #'as yet unclassified' }
CodeAdditionDuringAndByMergeRequestProjectMetric >> description [

	^ 'average code addition during and by merge request'
]

{ #category : #'as yet unclassified' }
CodeAdditionDuringAndByMergeRequestProjectMetric >> load [

	projectMergeRequests := self
		                  loadProjectCompleteMergeRequestsSince: (period at: #since)
		                  until: (period at: #until)
]
