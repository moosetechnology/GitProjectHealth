Extension { #name : #GLHUser }

{ #category : #'*GitLabHealth-Model-Extension' }
GLHUser >> computeCommitFrequencyOver: aDateWeekMonthOrYear [

	| orderedCommits |
	orderedCommits := self commits asArray sort: [ :a :b |
		                  a created_at < b created_at ].

	^ GitMetric4User new
		  user: self;
		glhImporter: GitlabModelImporter current;
		itsProjects: (self commits collect: [ :c |
					   c repository project id -> c repository project ]) asDictionary ;
		  commitFrequencySince: orderedCommits first created_at
		  until: orderedCommits last created_at
		  overA: aDateWeekMonthOrYear
]

{ #category : #'*GitLabHealth-Model-Extension' }
GLHUser >> computeCommitFrequencySince: since until: until overA: aDateWeekMonthOrYear [

	^ GitMetric4User new
		  user: self;
		  glhImporter: GitlabModelImporter current;
		  itsProjects: (self commits collect: [:c |  (c repository project id) -> (c repository project) ]) asDictionary;
		  commitFrequencySince: since
		  until: until
		  overA: aDateWeekMonthOrYear
]

{ #category : #'*GitLabHealth-Model-Extension' }
GLHUser >> isFakeUser [
	^ self isRealUser not. 
]

{ #category : #'*GitLabHealth-Model-Extension' }
GLHUser >> isRealUser [
	^ self id isNotNil.
]
