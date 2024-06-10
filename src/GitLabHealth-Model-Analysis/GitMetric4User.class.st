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
		'glhImporter',
		'itsMergeRequests'
	],
	#category : #'GitLabHealth-Model-Analysis'
}

{ #category : #churn }
GitMetric4User >> codeChurnSince: since until: until onACommitWindowOf: commitLimit overA: aDateWeekMonthOrYear [

	| commits res groupedByDate totalContributions |
	
		('GitMetric4User: code churn')
		recordInfo.
	
	totalContributions := OrderedCollection new.
		groupedByDate := self
		                 setupGroupedDateFrom: since
		                 to: until
		                 over: aDateWeekMonthOrYear.
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
		totalContributions add: contribution.

		fraction := sumChurn / ((contribution = 0) ifTrue: [1] ifFalse: [contribution ]) .
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
							 totalContribution = 0 ifTrue: [ totalChurn / 1] ifFalse: [ totalChurn / totalContribution  ]
		                  ].



	^ {
		  (#details -> groupedByDate).
		  (#totalContribution -> (totalContributions ifEmpty: [ 0 ] ifNotEmpty: [ totalContributions sum ]) ).
		  (#totalChurn -> (groupedByDate sum: [ :frac | frac numerator ])).
		  "(#avgChurn -> ((groupedByDate sum: [ :frac | frac numerator ])
		    / (groupedByDate keys ifEmpty: [ 1 ] ifNotEmpty: [ groupedByDate keys size ]) ))."
		  (#churn -> ((groupedByDate sum: [ :frac | frac numerator ]) ->
		     (groupedByDate sum: [ :frac | frac denominator ]))).
		  (#overEach -> aDateWeekMonthOrYear name).
		  (#forOver -> (groupedByDate keys size printString
		    , aDateWeekMonthOrYear printString)).
		  (#userCommits -> commits size).
		  (#churnWindow -> commitLimit) } asDictionary
]

{ #category : #metrics }
GitMetric4User >> codeContributionsSince: since until: until overA: aDateWeekMonthOrYear [

	| commits contributions groupedByDate |
	
			('GitMetric4User: code contribution') recordInfo.
	
		glhImporter withCommitDiffs: false.
	
		groupedByDate := self
		                 setupGroupedDateFrom: since
		                 to: until
		                 over: aDateWeekMonthOrYear.
		
	gitAnalyzer := GitAnalyzer new
		               onModel: glhModel;
		               glhImporter: glhImporter.

	commits := self
		           loadCommitOfProjects: itsProjects keys
		           since: since
		           until: until.
	commits := commits reject: [ :commit | commit commitCreator ~= user ].

	contributions := commits collect: [ :commit |
		                 commit -> (gitAnalyzer
			                  fromCommit: commit;
			                  analyseCommitContribution) ].

	contributions do: [ :assoc |
		| dateOver |
		dateOver := self
			            transformDate: assoc key created_at
			            to: aDateWeekMonthOrYear.
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

		glhImporter withCommitDiffs: true.

	^ {
		  (#overEach -> aDateWeekMonthOrYear name).
		  (#forOver -> (groupedByDate keys size printString
		    , aDateWeekMonthOrYear printString)).
		  (#avgAddition
		   -> ((groupedByDate values sum: [ :v | v at: #addition ])
			    / groupedByDate keys size) asFloat).
		  (#avgDeletion
		   -> ((groupedByDate values sum: [ :v | v at: #deletion ])
			    / groupedByDate keys size) asFloat).
		  (#details -> groupedByDate).
		  (#userCommits -> commits size) } asDictionary
]

{ #category : #metrics }
GitMetric4User >> commentsContributionsSince: since until: until overA: aDateWeekMonthOrYear [

	| commits contributions groupedByDate |
	
				('GitMetric4User: comment contribution') recordInfo.
	
	groupedByDate := self
		                 setupGroupedDateFrom: since
		                 to: until
		                 over: aDateWeekMonthOrYear.

	gitAnalyzer := GitAnalyzer new
		               onModel: glhModel;
		               glhImporter: glhImporter.

	commits := self
		           loadCommitOfProjects: itsProjects keys
		           since: since
		           until: until.
	commits := commits reject: [ :commit | commit commitCreator ~= user ].

	contributions := commits collect: [ :commit |
		                 commit -> (gitAnalyzer
			                  fromCommit: commit;
			                  analyseCommentContributions) ].


	contributions do: [ :assoc |
		| dateOver |
		dateOver := self
			            transformDate: assoc key created_at
			            to: aDateWeekMonthOrYear.
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


	^ {
		  (#details -> groupedByDate).
		  (#totalComments -> groupedByDate values sum).
		  (#avgComments
		   -> (groupedByDate values sum / groupedByDate keys size)).
		  (#overEach -> aDateWeekMonthOrYear name).
		  (#forOver -> (groupedByDate keys size printString
		    , aDateWeekMonthOrYear printString)).
		  (#userCommits -> commits size) } asDictionary
]

{ #category : #metrics }
GitMetric4User >> commitFrequencySince: since until: until overA: aDateWeekMonthOrYear [

	| all aggregate periods total groupedByDate |
	
	('GitMetric4User: commit frequency') recordInfo.	
	
	groupedByDate := self
		                 setupGroupedDateFrom: since
		                 to: until
		                 over: aDateWeekMonthOrYear.

	aggregate := OrderedDictionary new.

	all := itsProjects keys collect: [ :id |
		       self
			       commitsProducedOnProject: id
			       since: since
			       until: until
			       overA: aDateWeekMonthOrYear ].


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
			(#userCommit -> total).  
		(#forOver
		   ->
		   (aggregate keys size printString
		    , aDateWeekMonthOrYear printString)).
		  (#periode -> aDateWeekMonthOrYear name).
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

{ #category : #metrics }
GitMetric4User >> commitsProducedOnProject: aProjectId since: since until: until overA: aWeekOrMonthOrYear [
	"'aWeekOrMonthOrYear' should be the class of Week, Month or Year"

	"self commitFrequencyOnProject: 6462 since: (Date today - 60 day) until: (Date today) overA: Week. "

	| frequency aggregatedFrequencies |
	aggregatedFrequencies := self setupGroupedDateFrom: since to: until  over: aWeekOrMonthOrYear.
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
	
		('GitMetric4User: delay until first churn') recordInfo.	
	
	groupedByDate := self
		                 setupGroupedDateFrom: since
		                 to: until
		                 over: aDateWeekMonthOrYear.

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
			       commitB := GitAnalyzer new
				                  glhImporter: glhImporter;
				                  onModel: glhModel;
				                  fromCommit: commitA;
										maxChildCommit: 5;
				                  analyseAmandment.

			       durationFromA2B := commitB
				                          ifNil: [ 0 ]
				                          ifNotNil: [
				                          commitB created_at - commitA created_at ].
			       durationFromA2B ] ].



	res := res collect: [ :durationsByDate |
		       | filtered |
		       filtered := durationsByDate reject: [ :value | value = 0 ].
		       filtered isEmpty
			       ifTrue: [ nil ]
			       ifFalse: [
			       (filtered sum: [ :v | v asDuration ]) / filtered size ] ].

	res := res reject: #isNil.
	
	res ifEmpty: [ avg:= nil ] ifNotEmpty: [ avg := res values sum / res keys size. ].


	^ {
		  (#avgDelay -> avg).
		  (#overEach -> aDateWeekMonthOrYear name).
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
	itsGroups := Dictionary new.
	itsMergeRequests := Dictionary new
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

	| allCommits |
	allCommits := itsCommits
		              at: since printString , '-' , until printString
		              ifPresent: [ :c | c ]
		              ifAbsentPut: [
			              | commits |
			              commits := (aCollection collect: [ :id |
				                          glhImporter
					                          importCommitsOProject:
					                          (itsProjects at: id)
					                          since: since
					                          until: until ]) flattened.
			              commits := commits flatCollect: [ :c | c ].
			              commits ].

	allCommits do: [ :commit |	glhImporter completeImportedCommit: commit ].

	glhImporter chainsCommitsFrom: allCommits.

	^ allCommits
]

{ #category : #churn }
GitMetric4User >> loadMergeRequestsOfProjects: aCollection since: since until: until [

	| allMr |
	itsMergeRequests ifNil: [ itsMergeRequests := Dictionary new ].



	allMr := itsMergeRequests
		         at: since printString , '-' , until printString
		         ifPresent: [ :c | c ]
		         ifAbsentPut: [
			         | mr |
			         mr := (aCollection collect: [ :id |
				                glhImporter
					                importMergeRequests: (itsProjects at: id)
					                since: since
					                until: until ]) flattened.
			        " mr := mr flatCollect: [ :c | c ]."
			         mr ].


	^ allMr
]

{ #category : #loading }
GitMetric4User >> loadProjects: projectIds [

	projectIds do: [ :id |
		itsProjects at: id ifAbsentPut: [ glhImporter importProject: id ] ].

	^ itsProjects
]

{ #category : #metrics }
GitMetric4User >> mergeRequestDurationSince: since until: until overA: aDateWeekMonthOrYear [

	| mergeRequest res groupedByDate filterGroups avg |
	groupedByDate := self
		                 setupGroupedDateFrom: since
		                 to: until
		                 over: aDateWeekMonthOrYear.

	gitAnalyzer := GitAnalyzer new
		               glhImporter: glhImporter;
		               onModel: glhModel.

	mergeRequest := self
		                loadMergeRequestsOfProjects: itsProjects keys
		                since: since
		                until: until.
	

	mergeRequest ifEmpty: [
		^ {
			  (#avgDuration -> nil).
			  (#overEach -> aDateWeekMonthOrYear name).
			  (#forOver -> (groupedByDate keys size printString
			    , aDateWeekMonthOrYear printString)).
			  (#totalMergeRequest -> 0).
			  (#details -> nil) } asDictionary ].

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


	filterGroups := groupedByDate reject: [ :array | array isEmpty ].

	filterGroups associations do: [ :assoc |
		| sum denominator |
		denominator := assoc value size.

		sum := assoc value sum: [ :v |
			       v ifNil: [
				       denominator := denominator - 1.
				       0 asDuration ] ].
		denominator = 0 ifTrue: [ denominator := 1 ].

		filterGroups at: assoc key put: sum / denominator ].


	filterGroups keys
		ifEmpty: [ avg := 0 ]
		ifNotEmpty: [
		avg := filterGroups values sum / filterGroups keys size ].


	^ {
		  (#avgDuration -> avg).
		  (#overEach -> aDateWeekMonthOrYear name).
		  (#forOver -> (groupedByDate keys size printString
		    , aDateWeekMonthOrYear printString)).
		  (#totalMergeRequest -> mergeRequest size).
		  (#details -> groupedByDate) } asDictionary
]

{ #category : #setup }
GitMetric4User >> setupGroupedDateFrom: since to: until over: aDateWeekMonthOrYear [

	| groupedByDate start end over increment|
	groupedByDate := OrderedDictionary new.

	increment := 1.
	start := self transformDate: since to: aDateWeekMonthOrYear.
	end := self transformDate: until to: aDateWeekMonthOrYear.

	groupedByDate
		at: start printString
		ifAbsentPut: [ OrderedCollection new ].
	
	over := aDateWeekMonthOrYear name asLowercase asSymbol.
		over = #date ifTrue: [ over := #day ].
		over = #month ifTrue: [ increment := 32. over := #day ].
		 

	[ groupedByDate keys last asDateAndTime < end ] whileTrue: [
		| index  |
		index := groupedByDate keys last asDateAndTime + (increment perform: over).
		index := self transformDate: index to: aDateWeekMonthOrYear.
		groupedByDate
			at: index printString
			ifAbsentPut: [ OrderedCollection new ] ].
	
	
	over = #day ifTrue: [ 
		groupedByDate keys do: [ :date |
			|aWeekday|
			 aWeekday := date asDate weekday. 
			((aWeekday =  #Sunday) or: [ aWeekday = #Saturday ] )ifTrue: [ 
				groupedByDate removeKey: date. 
				 ] 
			 ].
		 ].
	

	groupedByDate
		at: end printString
		ifAbsentPut: [ OrderedCollection new ].

	^ groupedByDate
]

{ #category : #'as yet unclassified' }
GitMetric4User >> transformDate: date to: aWeekOrMonthOrYear [

	aWeekOrMonthOrYear = Month ifTrue: [ ^ date asDate month asDate ].

	^ (date asDate perform: ('as' , aWeekOrMonthOrYear name) asSymbol)
		  asDate
]

{ #category : #accessing }
GitMetric4User >> user [
	^ user
]

{ #category : #accessing }
GitMetric4User >> user: anUser [
	user := anUser. 
]
