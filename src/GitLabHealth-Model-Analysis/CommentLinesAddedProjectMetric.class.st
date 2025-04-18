Class {
	#name : #CommentLinesAddedProjectMetric,
	#superclass : #ProjectMetric,
	#instVars : [
		'maxCommitWindow'
	],
	#category : #'GitLabHealth-Model-Analysis'
}

{ #category : #calculating }
CommentLinesAddedProjectMetric >> calculate [

	| groupedByDate gitAnalyzer contributions |
	projectCommits ifNil: [ self load ].
	groupedByDate := self setupGroupedDate.

	gitAnalyzer := GitAnalyzer new.

	contributions := projectCommits collect: [ :commit |
		                 commit -> (gitAnalyzer
			                  fromCommit: commit;
			                  analyseCommentContribution) ].


	contributions do: [ :assoc |
		| dateOver |
		dateOver := self transformDate: assoc key created_at to: over.
		groupedByDate
			at: dateOver printString
			ifPresent: [ :v | v add: assoc value ] ].

	groupedByDate := groupedByDate collect: [ :contribs |
		                 contribs
			                 ifNotEmpty: [ contribs sum ]
			                 ifEmpty: [ 0 ] ].


	^ groupedByDate average asFloat
]

{ #category : #accessing }
CommentLinesAddedProjectMetric >> description [
	"as the sum of each comment line in commits made in the period, average by the unit scale"

	^ 'Comment lines added (avg by ',over printString,')'
]

{ #category : #loading }
CommentLinesAddedProjectMetric >> load [

	projectCommits := self loadCommitsSince: (period at:#since) until: (period at:#until) 
]
