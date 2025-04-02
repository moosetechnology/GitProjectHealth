Class {
	#name : #CodeDeletionByMergeRequestProjectMetric,
	#superclass : #ProjectMetric,
	#category : #'GitLabHealth-Model-Analysis'
}

{ #category : #calculating }
CodeDeletionByMergeRequestProjectMetric >> calculate [

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
				                  (mergeRequest mergedCommit ifNil: [
					                   mergeRequest mergeRequestCommit ifNil: [
						                   mergeRequest squashCommit ] ]) deletions ])
				                 average ] ].

	^ groupedByDate average asFloat
]

{ #category : #accessing }
CodeDeletionByMergeRequestProjectMetric >> description [

	^ 'average code deletion by merge request'
]

{ #category : #loading }
CodeDeletionByMergeRequestProjectMetric >> load [

	projectMergeRequests := self
		                  loadProjectCompleteMergeRequestsSince: (period at: #since)
		                  until: (period at: #until)
]
