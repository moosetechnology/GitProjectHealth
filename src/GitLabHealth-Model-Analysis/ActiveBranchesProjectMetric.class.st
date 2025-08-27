Class {
	#name : #ActiveBranchesProjectMetric,
	#superclass : #ProjectMetric,
	#category : #'GitLabHealth-Model-Analysis'
}

{ #category : #calculating }
ActiveBranchesProjectMetric >> calculate [

	| groupedByDate |
	


	projectBranches ifNil:[ self load].
	
		
		
	
	groupedByDate := self setupGroupedDate.
	
	"convert group collect to set, to ensure no duplicated data"
	groupedByDate keys do: [ :key |  groupedByDate at: key put: Set new].
	

	projectBranches do: [ :branch |
		| dateOver commit|
		"sort commits by ASC date"
		commit := (branch commits sort: [ :c1 :c2 | c1 created_at > c2 created_at]) first.
		 
		dateOver := self transformDate: commit created_at to: over.
		groupedByDate at: dateOver printString ifPresent: [ :v | v add: commit created_at ] ].

	groupedByDate := groupedByDate collect: [ :group | group size ].

	^ groupedByDate average asFloat
]

{ #category : #accessing }
ActiveBranchesProjectMetric >> description [

	^ 'Nb active branches at period (avg)'
]

{ #category : #loading }
ActiveBranchesProjectMetric >> load [

	^ projectBranches := self
		                  loadBranchesSince: (period at: #since)
		                  until: (period at: #until)
]
