Class {
	#name : #CodeAdditionProjectMetric,
	#superclass : #ProjectMetric,
	#category : #'GitLabHealth-Model-Analysis'
}

{ #category : #calculating }
CodeAdditionProjectMetric >> calculate [

	| gitAnalyzer contributions groupedByDate |
	projectCommits  ifNil: [ self load ].
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
			ifPresent: [ :v | v add: assoc value ]
			ifAbsentPut: [
				OrderedCollection new
					add: assoc value;
					yourself ] ].

	groupedByDate := groupedByDate collect: [ :contribs |
		                 contribs sum: [ :v | v at: #addition ] ].

	^ groupedByDate average asFloat
]

{ #category : #accessing }
CodeAdditionProjectMetric >> description [

	^ 'merge frequency (avg)'
]
