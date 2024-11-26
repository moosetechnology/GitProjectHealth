Class {
	#name : #TimeBetweenCommitMetric,
	#superclass : #UserCommitsMetric,
	#category : #'GitLabHealth-Model-Analysis'
}

{ #category : #calculating }
TimeBetweenCommitMetric >> calculate [

	| commitSortedByDate commits1 commits2 differences groupedByDate dateOver average |
	userCommits ifNil: [ self load ].
	groupedByDate := self setupGroupedDate.

	commitSortedByDate := userCommits sorted: [ :commit1 :commit2 |
		                      commit1 committed_date
		                      < commit2 committed_date ].

	commitSortedByDate do: [ :commit |
		dateOver := self transformDate: commit committed_date to: over.

		groupedByDate
			at: dateOver printString
			ifPresent: [ :value | value add: commit ] ].

	groupedByDate := groupedByDate select: [ :group | group size >= 2 ].


	groupedByDate := groupedByDate collect: [ :group |
		                 differences := (1 to: group size - 1) collect: [ :i |
			                                commits1 := group at: i.
			                                commits2 := group at: i + 1.

			                                (commits2 committed_date
			                                 - commits1 committed_date)
				                                asSeconds ].
			

		                 differences average asFloat ].

	average := groupedByDate
		           ifEmpty: [ nil ]
		           ifNotEmpty: [ groupedByDate average asFloat ].

	^ average 
]

{ #category : #accessing }
TimeBetweenCommitMetric >> description [

	^ 'average time between commits (in seconds)'
]
