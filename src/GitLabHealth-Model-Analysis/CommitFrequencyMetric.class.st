Class {
	#name : #CommitFrequencyMetric,
	#superclass : #UserMetric,
	#category : #'GitLabHealth-Model-Analysis'
}

{ #category : #calculating }
CommitFrequencyMetric >> calculate [

	| groupedByDate |
	groupedByDate := self setupGroupedDate.

	userCommits do: [ :c |
		| dateOver |
		dateOver := self transformDate: c created_at to: over.
		groupedByDate at: dateOver printString ifPresent: [ :v | v add: c ] ].

	groupedByDate := groupedByDate collect: [ :group | group size ].

	^ groupedByDate
]

{ #category : #accessing }
CommitFrequencyMetric >> description [

	^'commits frequency (avg)'
]

{ #category : #loading }
CommitFrequencyMetric >> load [

	self loadUserProjects.
	self loadUserCommits.
]

{ #category : #accessing }
CommitFrequencyMetric >> name [

	^ 'commitFrequency'
]
