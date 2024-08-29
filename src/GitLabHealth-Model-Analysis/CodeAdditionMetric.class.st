Class {
	#name : #CodeAdditionMetric,
	#superclass : #UserMetric,
	#category : #'GitLabHealth-Model-Analysis'
}

{ #category : #calculating }
CodeAdditionMetric >> calculate [

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
			ifAbsentPut: [
				OrderedCollection new
					add: assoc value;
					yourself ] ].

	groupedByDate := groupedByDate collect: [ :contribs |
		                 contribs sum: [ :v | v at: #addition ] ].

	^ groupedByDate average asFloat
]

{ #category : #accessing }
CodeAdditionMetric >> description [

	^ 'code addition (avg)'
]

{ #category : #loading }
CodeAdditionMetric >> load [

	userCommits := user loadCommitsSince: (period at: #since) until: (period at: #until). 
]

{ #category : #accessing }
CodeAdditionMetric >> name [

	^ 'codeContribution'
]
