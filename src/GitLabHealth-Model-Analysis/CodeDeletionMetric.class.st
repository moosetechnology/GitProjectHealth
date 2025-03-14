Class {
	#name : #CodeDeletionMetric,
	#superclass : #UserCommitsMetric,
	#category : #'GitLabHealth-Model-Analysis'
}

{ #category : #calculating }
CodeDeletionMetric >> calculate [

	| gitAnalyzer contributions groupedByDate |
	userCommits ifNil: [ self load ].
	groupedByDate := self setupGroupedDate.

	gitAnalyzer := GitAnalyzer new.

	contributions := userCommits collect: [ :commit |
		                 commit -> (gitAnalyzer
			                  fromCommit: commit;
			                  analyseCommitContribution) ].


	contributions do: [ :assoc |
		| dateOver |
		dateOver := self transformDate: assoc key created_at to: over.
		groupedByDate
			at: dateOver printString
			ifPresent: [ :v | v add: assoc value ]
			].

	groupedByDate := groupedByDate collect: [ :contribs |
		                 contribs sum: [ :v | v at: #deletion ] ].

	^ groupedByDate average asFloat
]

{ #category : #accessing }
CodeDeletionMetric >> description [

	^'code deletion (avg)'
]
