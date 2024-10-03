Class {
	#name : #ContributedProjectMetric,
	#superclass : #UserCommitsMetric,
	#category : #'GitLabHealth-Model-Analysis'
}

{ #category : #calculating }
ContributedProjectMetric >> calculate [

	| groupedByDate dateOver projects |
	userCommits ifNil: [ self load ].
	groupedByDate := self setupGroupedDate.

	userCommits do: [ :userCommit |
		dateOver := self transformDate: userCommit committed_date to: over.

		groupedByDate
			at: dateOver printString
			ifPresent: [ :value | value add: userCommit repository project ] ].

	groupedByDate := groupedByDate collect: [ :group |
		                 projects := Set newFrom: group.
		                 projects size ].

	^ groupedByDate average asFloat
]

{ #category : #accessing }
ContributedProjectMetric >> description [

	^ 'number of project with min 1 commit of user'
]
