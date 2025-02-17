Class {
	#name : #CommitFrequencyProjectMetric,
	#superclass : #ProjectMetric,
	#category : #'GitLabHealth-Model-Analysis'
}

{ #category : #calculating }
CommitFrequencyProjectMetric >> calculate [

	| groupedByDate |
	projectCommits ifNil: [ self load ].
	
	groupedByDate := self setupGroupedDate.

	projectCommits do: [ :c |
		| dateOver |
		dateOver := self transformDate: c created_at to: over.
		groupedByDate at: dateOver printString ifPresent: [ :v | v add: c ] ].

	groupedByDate := groupedByDate collect: [ :group | group size ].

	^ groupedByDate average asFloat
]

{ #category : #accessing }
CommitFrequencyProjectMetric >> description [

	^ 'commits frequency (avg)'
]

{ #category : #loading }
CommitFrequencyProjectMetric >> load [
	projectCommits := self loadCommitsSince: (period at: #since) until: (period at: #until) 
]
