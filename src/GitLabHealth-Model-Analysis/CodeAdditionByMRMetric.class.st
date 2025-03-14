Class {
	#name : #CodeAdditionByMRMetric,
	#superclass : #UserMergeRequestMetric,
	#category : #'GitLabHealth-Model-Analysis'
}

{ #category : #calculating }
CodeAdditionByMRMetric >> calculate [

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
				                             commit additions ] ]) average ].

	^ groupedByDate average asFloat
]

{ #category : #accessing }
CodeAdditionByMRMetric >> description [

	^ 'average code addition by merge request'
]

{ #category : #loading }
CodeAdditionByMRMetric >> load [

	userMergeRequests := self
		                     loadUserCompleteMergeRequestsSince:
		                     (period at: #since)
		                     until: (period at: #until)
]
