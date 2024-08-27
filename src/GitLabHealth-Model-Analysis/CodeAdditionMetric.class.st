Class {
	#name : #CodeAdditionMetric,
	#superclass : #UserMetric,
	#category : #'GitLabHealth-Model-Analysis'
}

{ #category : #'as yet unclassified' }
CodeAdditionMetric >> calculate [

	| gitAnalyzer contributions groupedByDate |
	groupedByDate := self setupGroupedDate.

	gitAnalyzer := GitAnalyzer new glhImporter: glhImporter.

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
		               
		                contribs sum: [ :v | v at: #addition ].
		       
		                  ].

	^ groupedByDate
]

{ #category : #accessing }
CodeAdditionMetric >> description [

	^ 'code addition (avg)'
]

{ #category : #loading }
CodeAdditionMetric >> load [

	self loadUserProjects.
	self loadUserCommits
]

{ #category : #accessing }
CodeAdditionMetric >> name [

	^ 'codeContribution'
]
