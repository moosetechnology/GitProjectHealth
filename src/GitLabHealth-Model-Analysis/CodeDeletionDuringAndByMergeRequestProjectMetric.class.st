Class {
	#name : #CodeDeletionDuringAndByMergeRequestProjectMetric,
	#superclass : #ProjectMetric,
	#category : #'GitLabHealth-Model-Analysis'
}

{ #category : #'as yet unclassified' }
CodeDeletionDuringAndByMergeRequestProjectMetric >> calculate [

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
				                  mergeRequest commits sum: #deletions ]) average ] ].

	^ groupedByDate average asFloat
]

{ #category : #'as yet unclassified' }
CodeDeletionDuringAndByMergeRequestProjectMetric >> description [

	^ 'average code addition by merge request'
]

{ #category : #'as yet unclassified' }
CodeDeletionDuringAndByMergeRequestProjectMetric >> load [

	projectMergeRequests := self
		                  loadProjectCompleteMergeRequestsSince: (period at: #since)
		                  until: (period at: #until)
]
