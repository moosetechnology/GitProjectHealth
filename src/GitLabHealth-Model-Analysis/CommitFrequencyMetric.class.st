Class {
	#name : #CommitFrequencyMetric,
	#superclass : #UserMetric,
	#category : #'GitLabHealth-Model-Analysis'
}

{ #category : #calculating }
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

{ #category : #accessing }
CommitFrequencyMetric >> description [

	^'commits frequency (avg)'
]

{ #category : #loading }
CommitFrequencyMetric >> load [

	userCommits := user loadCommitsSince: (period at: #since) until: (period at: #until). 
]

{ #category : #accessing }
CommitFrequencyMetric >> name [

	^ 'commitFrequency'
]
