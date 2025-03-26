Class {
	#name : #ContributorsProjectMetric,
	#superclass : #ProjectMetric,
	#category : #'GitLabHealth-Model-Analysis'
}

{ #category : #calculating }
ContributorsProjectMetric >> calculate [

	| groupedByDate |
	projectCommits ifNil: [ self load ].

	groupedByDate := self setupGroupedDate.
	
	"convert group collect to set, to ensure no duplicated data"
	groupedByDate keys do: [ :key |  groupedByDate at: key put: Set new].
	

	projectCommits do: [ :commit |
		| dateOver |
		dateOver := self transformDate: commit created_at to: over.
		groupedByDate at: dateOver printString ifPresent: [ :v | v add: commit commitCreator ] ].

	groupedByDate := groupedByDate collect: [ :group | group size ].

	^ groupedByDate average asFloat
]

{ #category : #accessing }
ContributorsProjectMetric >> description [

	^ 'Nb Contributors (avg)'
]

{ #category : #loading }
ContributorsProjectMetric >> load [

	^ projectCommits := self
		                  loadCommitsSince: (period at: #since)
		                  until: (period at: #until)
]
