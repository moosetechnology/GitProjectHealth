Class {
	#name : 'CommitFrequencyMetric',
	#superclass : 'UserCommitsMetric',
	#category : 'GitLabHealth-Model-Analysis',
	#package : 'GitLabHealth-Model-Analysis'
}

{ #category : 'calculating' }
CommitFrequencyMetric >> calculate [

	| groupedByDate |
	userCommits ifNil: [ self load ].
	groupedByDate := self setupGroupedDate.

	userCommits do: [ :c |
		| dateOver |
		dateOver := self transformDate: c created_at to: over.
		groupedByDate at: dateOver printString ifPresent: [ :v | v add: c ] ].

	groupedByDate := groupedByDate collect: [ :group | group size ].

	^ groupedByDate average asFloat
]

{ #category : 'accessing' }
CommitFrequencyMetric >> description [

	^'commits frequency (avg)'
]
