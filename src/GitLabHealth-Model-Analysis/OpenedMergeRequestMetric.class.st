Class {
	#name : #OpenedMergeRequestMetric,
	#superclass : #UserMetric,
	#category : #'GitLabHealth-Model-Analysis'
}

{ #category : #calculating }
OpenedMergeRequestMetric >> calculate [

	| groupedByDate dateOver |
	groupedByDate := self setupGroupedDate.

	userMergeRequests do: [ :userMergeRequest |
		dateOver := self transformDate: userMergeRequest created_at to: over.

		groupedByDate
			at: dateOver printString
			ifPresent: [ :value | value add: userMergeRequest ] ].

	groupedByDate := groupedByDate collect: [ :group | group size ].

	^ groupedByDate
]

{ #category : #accessing }
OpenedMergeRequestMetric >> description [

	^'number of opened merge request'
]

{ #category : #loading }
OpenedMergeRequestMetric >> load [

	self loadUserProjects.
	self loadUserMergeRequests
]

{ #category : #accessing }
OpenedMergeRequestMetric >> name [

	^'openedMergeRequest'
]
