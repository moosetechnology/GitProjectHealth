"
I look at the commit on the period and I sum their deletions
"
Class {
	#name : #CodeDeletionProjectMetric,
	#superclass : #ProjectMetric,
	#category : #'GitLabHealth-Model-Analysis'
}

{ #category : #calculating }
CodeDeletionProjectMetric >> calculate [

	| gitAnalyzer contributions groupedByDate |
	projectCommits ifNil: [ self load ].
	groupedByDate := self setupGroupedDate.

	gitAnalyzer := GitAnalyzer new.

	contributions := projectCommits collect: [ :commit |
		                 commit -> (gitAnalyzer
			                  fromCommit: commit;
			                  analyseCommitContribution) ].


	contributions do: [ :assoc |
		| dateOver |
		dateOver := self transformDate: assoc key created_at to: over.
		groupedByDate
			at: dateOver printString
			ifPresent: [ :v | v add: assoc value ] ].

	groupedByDate := groupedByDate collect: [ :contribs |
		                 contribs sum: [ :v | v at: #deletion ] ].

	^ groupedByDate average asFloat
]

{ #category : #accessing }
CodeDeletionProjectMetric >> description [

	^ 'Code Deletion'
]

{ #category : #loading }
CodeDeletionProjectMetric >> load [

	projectCommits := self
		                  loadCommitsSince: (period at: #since)
		                  until: (period at: #until)
]
