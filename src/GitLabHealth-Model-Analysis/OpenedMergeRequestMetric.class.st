Class {
	#name : 'OpenedMergeRequestMetric',
	#superclass : 'UserMergeRequestMetric',
	#category : 'GitLabHealth-Model-Analysis',
	#package : 'GitLabHealth-Model-Analysis'
}

{ #category : 'calculating' }
OpenedMergeRequestMetric >> calculate [

	| groupedByDate dateOver |
	userMergeRequests ifNil: [ self load ].
	
	groupedByDate := self setupGroupedDate.

	userMergeRequests do: [ :userMergeRequest |
		dateOver := self transformDate: userMergeRequest created_at to: over.

		groupedByDate
			at: dateOver printString
			ifPresent: [ :value | value add: userMergeRequest ] ].

	groupedByDate := groupedByDate collect: [ :group | group size ].

	^ groupedByDate average asFloat
]

{ #category : 'accessing' }
OpenedMergeRequestMetric >> description [

	^'number of opened merge request'
]

{ #category : 'accessing' }
OpenedMergeRequestMetric >> name [

	^'openedMergeRequest'
]
