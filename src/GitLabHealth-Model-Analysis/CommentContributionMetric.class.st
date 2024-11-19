Class {
	#name : #CommentContributionMetric,
	#superclass : #UserCommitsMetric,
	#category : 'GitLabHealth-Model-Analysis'
}

{ #category : #calculating }
CommentContributionMetric >> calculate [

	| groupedByDate gitAnalyzer contributions |
	userCommits ifNil: [ self load ].
	groupedByDate := self setupGroupedDate.

	gitAnalyzer := GitAnalyzer new.

	contributions := userCommits collect: [ :commit |
		                 commit -> (gitAnalyzer
			                  fromCommit: commit;
			                  analyseCommentContribution) ].


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
		                 contribs
			                 ifNotEmpty: [ contribs sum ]
			                 ifEmpty: [ 0 ] ].


	^ groupedByDate average asFloat
]

{ #category : #accessing }
CommentContributionMetric >> description [

	^ 'comment contribution (avg)'
]

{ #category : #loading }
CommentContributionMetric >> load [

	userCommits := self
		               loadUserCompleteCommitsSince: (period at: #since)
		               until: (period at: #until)
]
