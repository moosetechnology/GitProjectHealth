Class {
	#name : #ActiveBranchesProjectMetric,
	#superclass : #ProjectMetric,
	#category : #'GitLabHealth-Model-Analysis'
}

{ #category : #calculating }
ActiveBranchesProjectMetric >> calculate [

	| groupedByDate |
	
	1 halt. 
	
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
ActiveBranchesProjectMetric >> description [

	^ 'Nb Active branches (avg)'
]

{ #category : #loading }
ActiveBranchesProjectMetric >> load [

	^ projectCommits := self
		                  loadBranchesSince: (period at: #since)
		                  until: (period at: #until)
]
