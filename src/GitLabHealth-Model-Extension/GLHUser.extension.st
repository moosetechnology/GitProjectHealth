Extension { #name : #GLHUser }

{ #category : #'*GitLabHealth-Model-Extension' }
GLHUser >> computeCommitFrequencyOver: aDateWeekMonthOrYear [

	| orderedCommits |
	orderedCommits := self commits sortBy: #created_at.

	^ GitMetric4User new
		user: self;
		commitFrequencySince: orderedCommits first created_at asDateAndTime
		until: orderedCommits last created_at asDateAndTime
		overA: aDateWeekMonthOrYear
]
