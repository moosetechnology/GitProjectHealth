Class {
	#name : #CodeAdditionByCommitProjectMetric,
	#superclass : #ProjectMetric,
	#category : #'GitLabHealth-Model-Analysis'
}

{ #category : #calculating }
CodeAdditionByCommitProjectMetric >> calculate [

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
		                 contribs sum: [ :v | v at: #addition ] ].

	^ groupedByDate average asFloat
]

{ #category : #accessing }
CodeAdditionByCommitProjectMetric >> description [

	^ 'Code Addition by Commits (avg)'
]

{ #category : #loading }
CodeAdditionByCommitProjectMetric >> load [

	projectCommits := self
		                  loadCommitsSince: (period at: #since)
		                  until: (period at: #until)
]
