Class {
	#name : #InactiveBranchesProjectMetric,
	#superclass : #ProjectMetric,
	#category : #'GitLabHealth-Model-Analysis'
}

{ #category : #calculating }
InactiveBranchesProjectMetric >> calculate [

	| groupedByDate outside|
	
	projectBranches ifNil:[ self load].
	
	groupedByDate := self setupGroupedDate.
	
	"convert group collect to set, to ensure no duplicated data"
	groupedByDate keys do: [ :key |  groupedByDate at: key put: Set new].
	
	outside := OrderedCollection new.

	projectBranches do: [ :branch |
		| dateOver commit|
		"sort commits by ASC date"
		commit := (branch commits sort: [ :c1 :c2 | c1 created_at > c2 created_at]) first.
		dateOver := self transformDate: commit created_at to: over.
		groupedByDate at: dateOver printString ifAbsent: [  outside add: branch ] ].

	
	^ outside size asFloat
]

{ #category : #accessing }
InactiveBranchesProjectMetric >> description [
	"inactif = no activity observed inside the set period"

	^ 'Nb inactive branches at period (avg)'
]

{ #category : #loading }
InactiveBranchesProjectMetric >> load [

	^ projectBranches := self
		                  loadBranchesSince: (period at: #since)
		                  until: (period at: #until)
]
