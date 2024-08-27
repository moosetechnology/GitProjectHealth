Class {
	#name : #CodeContributionMetric,
	#superclass : #UserMetric,
	#category : #'GitLabHealth-Model-Analysis'
}

{ #category : #'as yet unclassified' }
CodeContributionMetric >> calculate [

	| gitAnalyzer contributions groupedByDate |
	groupedByDate := self setupGroupedDate.

	gitAnalyzer := GitAnalyzer new
		               glhImporter: glhImporter.

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
		                 | totalAdd totalDele |
		                 totalAdd := contribs sum: [ :v | v at: #addition ].
		                 totalDele := contribs sum: [ :v | v at: #deletion ].
		                 {
			                 (#addition -> totalAdd).
			                 (#deletion -> totalDele) } asDictionary ].

	^ groupedByDate
]

{ #category : #loading }
CodeContributionMetric >> load [

	self loadUserProjects.
	self loadUserCommits.
]
