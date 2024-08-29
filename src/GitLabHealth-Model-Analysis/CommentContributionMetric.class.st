Class {
	#name : #CommentContributionMetric,
	#superclass : #UserMetric,
	#category : #'GitLabHealth-Model-Analysis'
}

{ #category : #calculating }
CommentContributionMetric >> calculate [

	| groupedByDate gitAnalyzer contributions |
	groupedByDate := self setupGroupedDate.

	gitAnalyzer := GitAnalyzer new glhImporter: glhImporter.

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

	self loadUserProjects.
	self loadUserCommits.
	
	userCommits do: [ :commit | glhImporter completeImportedCommit: commit ].
]

{ #category : #accessing }
CommentContributionMetric >> name [

	^ 'commentContribution'
]
