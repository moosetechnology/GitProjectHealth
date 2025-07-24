Class {
	#name : #CommitWithoutUsernameProjectMetric,
	#superclass : #ProjectMetric,
	#category : #'GitLabHealth-Model-Analysis'
}

{ #category : #calculating }
CommitWithoutUsernameProjectMetric >> calculate [

	| groupedByDate filteredCommits|
	projectCommits ifNil: [ self load ].
	
	groupedByDate := self setupGroupedDate.
	
	filteredCommits := projectCommits select: [ :c |
		c commitCreator isFakeUser 
		 ].
	
	filteredCommits do: [ :c |
		| dateOver |
		dateOver := self transformDate: c created_at to: over.
		groupedByDate at: dateOver printString ifPresent: [ :v | v add: c ] ].

	groupedByDate := groupedByDate collect: [ :group | group size ].

	^ groupedByDate average asFloat
]

{ #category : #accessing }
CommitWithoutUsernameProjectMetric >> description [

	^ 'Nb Commit without a real username (avg)'
]

{ #category : #loading }
CommitWithoutUsernameProjectMetric >> load [
	projectCommits := self loadCommitsSince: (period at: #since) until: (period at: #until) 
]
