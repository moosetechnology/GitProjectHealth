Class {
	#name : #GitMetric4User,
	#superclass : #Object,
	#instVars : [
		'user',
		'itsProjects',
		'itsGroups',
		'itsCommits',
		'gitAnalyzer',
		'glhModel',
		'glhImporter'
	],
	#category : #'GitLabHealth-Model-Analysis'
}

{ #category : #churn }
GitMetric4User >> codeChurnSince: since until: until onACommitWindowOf: commitLimit overA: aDateWeekMonthOrYear [

	| commits res groupedByDate |
	groupedByDate := OrderedDictionary new.
	gitAnalyzer := GitAnalyzer new
		               glhImporter: glhImporter;
		               onModel: glhModel;
		               maxChildCommit: commitLimit.

	commits := self
		           loadCommitOfProjects: itsProjects keys
		           since: since
		           until: until.
	commits := commits reject: [ :commit | commit commitCreator ~= user ].


	"for each commit, we get its churn result (a dictionnary)"
	res := commits collect: [ :commit |
		       commit -> (gitAnalyzer
			        fromCommit: commit;
			        analyseChurn) ].


	res do: [ :assoc |
		| commit churnResult sumChurn overDate contribution fraction |
		commit := assoc key.
		churnResult := assoc value.
		sumChurn := (churnResult at: #churns) sum: [ :churn |
			            | numerator |
			            numerator := churn value asFraction numerator.
			            self flag:
				            'must investigate what does it mean to have a -1 in churn'.
			            numerator = -1
				            ifTrue: [ 0 ]
				            ifFalse: [ numerator ] ].
		contribution := churnResult at: #totalContribution.

		fraction := sumChurn / contribution.
		overDate := self
			            transformDate: commit created_at
			            to: aDateWeekMonthOrYear.
		groupedByDate
			at: overDate printString
			ifPresent: [ :array | array add: fraction ]
			ifAbsentPut: [
				OrderedCollection new
					add: fraction;
					yourself ] ].

	groupedByDate := groupedByDate collect: [ :churns |
		                 | totalChurn totalContribution |
		                 totalChurn := churns sum: [ :churn |
			                               churn asFraction numerator ].
		                 totalContribution := churns sum: [ :churn |
			                                      churn asFraction denominator ].
		                 totalChurn / totalContribution ].



	^ {
		  (#details -> groupedByDate).
		  (#totalChurn -> (groupedByDate sum: [ :frac | frac numerator ])).
		  (#avgChurn -> ((groupedByDate sum: [ :frac | frac numerator ]) / groupedByDate keys size) ) .
		  (#overEach -> aDateWeekMonthOrYear name).
		  (#forOver -> (groupedByDate keys size printString
		    , aDateWeekMonthOrYear printString)).
		  (#userCommits -> commits size).
		  (#churnWindow -> commitLimit) } asDictionary
]

{ #category : #'as yet unclassified' }
GitMetric4User >> commitFrequencySince: since until: until overA: aWeekMonthOrYear [

	| all aggregate periods total |
	aggregate := OrderedDictionary new.

	all := itsProjects keys collect: [ :id |
		       self
			       commitsProducedOnProject: id
			       since: since
			       until: until
			       overA: aWeekMonthOrYear ].




	all do: [ :frequencies |
		frequencies associations do: [ :assoc |
			aggregate
				at: assoc key
				ifPresent: [ :collection | collection addAll: assoc value ]
				ifAbsentPut: [ assoc value ] ] ].

	periods := aggregate keys size.
	total := aggregate values sum: [ :commits | commits size ].


	^ {
		  (#averageFrac -> (total / periods)).
		  (#averageFloat -> (total / periods) asFloat).
		(#forOver -> (aggregate keys size printString
		    , aWeekMonthOrYear printString)).
		  (#periode -> aWeekMonthOrYear name).
		  (#details -> aggregate) } asOrderedDictionary
]

{ #category : #'as yet unclassified' }
GitMetric4User >> commitsProducedOnProject: projectId since: sinceDate until: untilDate [

	| frequencies |
	
	gitAnalyzer := GitAnalyzer new 
	glhImporter: glhImporter; 
	onModel: glhModel.
	 
	frequencies := gitAnalyzer
		               onProject: (itsProjects at: projectId);
		               analyseCommitFrequencySince: sinceDate
		               until: untilDate. 
	
	"complete each commit "
	frequencies values flattened do: [ :commit |
		glhImporter completeImportedCommit: commit.
		 ].
	
	"Filter the associations in the 'frequencies' collection, removing any commits not created by the specified 'user'. "
	frequencies associations do: [ :assoc |
		|commits| 
		commits := assoc value.
		assoc value: (commits reject: [ :commit | commit commitCreator ~= user ]). 
	].
	
	^ frequencies 
]

{ #category : #frequency }
GitMetric4User >> commitsProducedOnProject: aProjectId since: since until: until overA: aWeekOrMonthOrYear [
	"'aWeekOrMonthOrYear' should be the class of Week, Month or Year"

	"self commitFrequencyOnProject: 6462 since: (Date today - 60 day) until: (Date today) overA: Week. "

	| frequency aggregatedFrequencies |
	aggregatedFrequencies := OrderedDictionary new.
	frequency := self
		             commitsProducedOnProject: aProjectId
		             since: since
		             until: until.


	frequency associations do: [ :assoc |
		| date commits overDate |
		date := assoc key.
		commits := assoc value.

		commits ifNotEmpty: [ " convert the date as its week date. For some english reason, the week start in sunday so we should add a + 1 day "
			overDate := self transformDate: date to: aWeekOrMonthOrYear.
			aggregatedFrequencies
				at: overDate printString
				ifPresent: [ :collection | collection addAll: commits ]
				ifAbsentPut: [ commits ] ] ].

	^ aggregatedFrequencies
]

{ #category : #churn }
GitMetric4User >> delayUntilFirstChurnSince: since until: until overA: aDateWeekMonthOrYear [

	| commits groupedByDate res avg |
	groupedByDate := OrderedDictionary new.

	commits := self
		           loadCommitOfProjects: itsProjects keys
		           since: since
		           until: until.

	"class commit by dates, filter none user commits"
	commits do: [ :commit |
		commit commitCreator = user ifTrue: [
			| overDate |
			overDate := self
				            transformDate: commit created_at
				            to: aDateWeekMonthOrYear.

			groupedByDate
				at: overDate printString
				ifPresent: [ :arrayOfCommits | arrayOfCommits add: commit ]
				ifAbsentPut: [
					OrderedCollection new
						add: commit;
						yourself ] ] ].



	res := groupedByDate collect: [ :commits4Date |
		       | durationFromA2B |
		       commits4Date collect: [ :commitA |
			       | commitB |
			       commitB := gitAnalyzer
				                  glhImporter: glhImporter;
				                  onModel: glhModel;
				                  fromCommit: commitA;
				                  analyseAmandment.

			       durationFromA2B := commitB
				                          ifNil: [ 0 ]
				                          ifNotNil: [
				                          commitB created_at - commitA created_at ].
			       durationFromA2B ] ].

	

	res := res collect: [ :durationsByDate |
				|filtered|
				filtered := durationsByDate reject: [ :value | value = 0 ].
				filtered isEmpty ifTrue: [  nil ] ifFalse: [ (filtered sum: [ :v | v asDuration ])
		       / filtered size ] 
		        ].

	res := res reject: #isNil.

	avg := res values sum / res keys size.

	^ {
		  (#avg -> avg).
		  (#periode -> aDateWeekMonthOrYear name).
		  (#forOver -> (groupedByDate keys size printString
		    , aDateWeekMonthOrYear printString)).
		  (#details -> groupedByDate) } asDictionary
]

{ #category : #'as yet unclassified' }
GitMetric4User >> findUserNamed: aUsername [

	user := glhImporter importUserByUsername: aUsername.
	^ user
]

{ #category : #accessing }
GitMetric4User >> glhImporter: aGLPHModelImporter [ 
	glhImporter := aGLPHModelImporter
]

{ #category : #initialization }
GitMetric4User >> initialize [

	user := GLHUser new.
	itsProjects := Dictionary new.
	itsCommits := Dictionary new.
	itsGroups := Dictionary new
]

{ #category : #accessing }
GitMetric4User >> itsCommits [
	^ user commits
]

{ #category : #churn }
GitMetric4User >> loadCommitOfProjects: aCollection since: aTimespan [
	|commits|
	
	commits := (aCollection collect: [ :id |
		 glhImporter
			importCommitsOProject: (itsProjects at: id)
			since: aTimespan
			until: nil ]) flattened.

	commits do: [ :commit |
		glhImporter completeImportedCommit: commit. 
		 ].

	^ self itsCommits.
]

{ #category : #churn }
GitMetric4User >> loadCommitOfProjects: aCollection since: since until: until [

	| commits |
	commits := (aCollection collect: [ :id |
		            glhImporter
			            importCommitsOProject: (itsProjects at: id)
			            since: since
			            until: until ]) flattened first.

	commits do: [ :commit | glhImporter completeImportedCommit: commit ].
	
	glhImporter chainsCommitsFrom: commits. 

	^ commits
]

{ #category : #loading }
GitMetric4User >> loadProjects: aCollection [

	aCollection do: [ :id |
		itsProjects at: id ifAbsentPut: (glhImporter importProject: id) ].

	^ itsProjects
]

{ #category : #metrics }
GitMetric4User >> mergeRequestDurationSince: since until: until overA: aDateWeekMonthOrYear [

	| mergeRequest res groupedByDate avg |
	groupedByDate := OrderedDictionary new.

	gitAnalyzer := GitAnalyzer new
		               glhImporter: glhImporter;
		               onModel: glhModel.

	mergeRequest := itsProjects collect: [ :project |
		                glhImporter
			                importMergeRequests: project
			                since: since
			                until: until ].

	mergeRequest := mergeRequest values flattened.

	res := mergeRequest collect: [ :mr |
		       gitAnalyzer analyseMergeResquestValidation: mr ].


	res do: [ :dic |
		| overDate |
		overDate := self
			            transformDate: (dic at: #created_at)
			            to: aDateWeekMonthOrYear.

		groupedByDate
			at: overDate printString
			ifPresent: [ :durations | durations add: (dic at: #duration) ]
			ifAbsentPut: [
				OrderedCollection new
					add: (dic at: #duration);
					yourself ] ].

	groupedByDate associations do: [ :assoc |
		| sum denominator |
		denominator := assoc value size.
		sum := assoc value sum: [ :v | v ifNil: [denominator := denominator -1. 0 asDuration] ].
		assoc value: sum / denominator ].


	avg := (groupedByDate values sum: [ :v | v ])
	       / groupedByDate keys size.


	^ {
		  (#avgDuration -> avg).
		  (#overEach -> aDateWeekMonthOrYear name).
		  (#forOver -> (groupedByDate keys size printString
		    , aDateWeekMonthOrYear printString)).
		  (#totalMergeRequest -> mergeRequest size).
		  (#details -> groupedByDate) } asDictionary
]

{ #category : #'as yet unclassified' }
GitMetric4User >> transformDate: date to: aWeekOrMonthOrYear [
	^ (date asDate perform:
				             ('as' , aWeekOrMonthOrYear name) asSymbol) asDate
]

{ #category : #accessing }
GitMetric4User >> user [
	^ user
]

{ #category : #accessing }
GitMetric4User >> user: anUser [
	user := anUser. 
]
