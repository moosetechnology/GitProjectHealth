Class {
	#name : #CodeDeletionByMRMetric,
	#superclass : #UserMergeRequestMetric,
	#category : #'GitLabHealth-Model-Analysis'
}

{ #category : #calculating }
CodeDeletionByMRMetric >> calculate [

	| groupedByDate dateOver |
	userMergeRequests ifNil: [ self load ].

	groupedByDate := self setupGroupedDate.
	userMergeRequests ifEmpty: [ ^ 0 ].


	userMergeRequests do: [ :userMergeRequest |
		dateOver := self transformDate: userMergeRequest created_at to: over.
		groupedByDate
			at: dateOver printString
			ifPresent: [ :value | value add: userMergeRequest ] ].

	groupedByDate := groupedByDate collect: [ :group |
		                 | average |
		                 average := (group collect: [ :mergeRequest |
			                             mergeRequest commits sum: [ :commit |
				                             commit deletions ] ]) average ].

	^ groupedByDate average asFloat
]

{ #category : #accessing }
CodeDeletionByMRMetric >> description [

	^ 'average code deletion by merge request'
]

{ #category : #loading }
CodeDeletionByMRMetric >> load [

	userMergeRequests := self
		                     loadUserCompleteMergeRequestsSince:
		                     (period at: #since)
		                     until: (period at: #until)
]
