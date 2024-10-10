Extension { #name : #GLHUser }

{ #category : #'*GitLabHealth-Model-Extension' }
GLHUser >> computeCommitFrequencyOver: aDateWeekMonthOrYear [

	| orderedCommits |
	orderedCommits := self commits asArray sort: [ :a :b |
		                  a created_at < b created_at ].

	^ GitMetric4User new
		  userWithId: self;
		glhImporter: GLHModelImporter current;
		itsProjects: (self commits collect: [ :c |
					   c repository project id -> c repository project ]) asDictionary ;
		  commitFrequencySince: orderedCommits first created_at
		  until: orderedCommits last created_at
		  overA: aDateWeekMonthOrYear
]

{ #category : #'*GitLabHealth-Model-Extension' }
GLHUser >> computeCommitFrequencySince: since until: until overA: aDateWeekMonthOrYear [

	^ GitMetric4User new
		  userWithId: self;
		  glhImporter: GLHModelImporter current;
		  itsProjects: (self commits collect: [:c |  (c repository project id) -> (c repository project) ]) asDictionary;
		  commitFrequencySince: since
		  until: until
		  overA: aDateWeekMonthOrYear
]
