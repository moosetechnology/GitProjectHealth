Class {
	#name : #GitMetric4User,
	#superclass : #GitMetric,
	#instVars : [
		'itsCommits',
		'itsMergeRequests'
	],
	#category : #'GitLabHealth-Model-Analysis'
}

{ #category : #churn }
GitMetric4User >> codeChurnSince: since until: until onACommitWindowOf: commitLimit overA: aDateWeekMonthOrYear [

	| commits res groupedByDate totalContributions userCommits |
	"for each commit, we get its churn result (a dictionnary)"
	'GitMetric4User: code churn' recordInfo.
	totalContributions := OrderedCollection new.
	groupedByDate := self
		                 setupGroupedDateFrom: since
		                 to: until
		                 over: aDateWeekMonthOrYear.
	gitAnalyzer := GitAnalyzer new
		               glhImporter: glhImporter;
		               onModel: glhModel;
		               maxChildCommit: commitLimit.
	glhImporter withCommitDiffs: false.
	commits := self
		           loadCommitsFromProjectsIds: itsProjects keys
		           since: since
		           until: until.
	glhImporter withCommitDiffs: true.
	userCommits := commits reject: [ :commit |
		               commit commitCreator ~= user ].
	commits := self
		           foundSuccessorOf: userCommits
		           andCompleteImportForMax: commitLimit.


	res := commits collect: [ :commit |
		       commit -> (gitAnalyzer
			        fromCommit: commit;
			        analyseChurn) ].
	res do: [ :commits4Churns |
		| commit allChurnsInCommit sumChurnInCommit overDate contribution churnOnCommit |
		commit := commits4Churns key.
		allChurnsInCommit := commits4Churns value.
		sumChurnInCommit := (allChurnsInCommit at: #churns) sum: [ :churn |
			                    | numerator |
			                    numerator := churn value at: #churnLoC.
			                    numerator ].
		contribution := allChurnsInCommit at: #totalContribution.
		totalContributions add: contribution.
		churnOnCommit := {
			                 (#churnOnCommit -> sumChurnInCommit).
			                 (#LoCOnCommit -> contribution) } asDictionary.
		overDate := self
			            transformDate: commit created_at
			            to: aDateWeekMonthOrYear.
		groupedByDate
			at: overDate printString
			ifPresent: [ :array | array add: churnOnCommit ]
			ifAbsentPut: [
				OrderedCollection new
					add: churnOnCommit;
					yourself ] ].
	groupedByDate := groupedByDate collect: [ :churnsAtDate |
		                 | totalChurn totalContribution percentage |
		                 totalChurn := churnsAtDate sum: [ :churn |
			                               churn at: #churnOnCommit ].
		                 totalContribution := churnsAtDate sum: [ :churn |
			                                      churn at: #LoCOnCommit ].
		                 totalContribution = 0
			                 ifTrue: [ percentage := 0 asFloat ]
			                 ifFalse: [
			                 percentage := (totalChurn * 100
			                                / totalContribution) asFloat ].
		                 {
			                 (#churn -> totalChurn).
			                 (#contribution -> totalContribution).
			                 (#percentage -> percentage) } asDictionary ].
	^ {
		  (#details -> groupedByDate).
		  (#totalContribution -> (totalContributions
			    ifEmpty: [ 0 ]
			    ifNotEmpty: [ totalContributions sum ])).
		  (#totalChurn -> (groupedByDate sum: [ :date | date at: #churn ])).
		  (#churn
		   ->
		   (groupedByDate collect: [ :date | date at: #percentage ]) average).
		  (#overEach -> aDateWeekMonthOrYear name).
		  (#forOver -> (groupedByDate keys size printString
		    , aDateWeekMonthOrYear printString)).
		  (#userCommits -> commits size).
		  (#churnWindow -> commitLimit) } asDictionary
]

{ #category : #metrics }
GitMetric4User >> codeContributionsSince: since until: until overA: aDateWeekMonthOrYear [

	| commits contributions groupedByDate |
	'GitMetric4User: code contribution' recordInfo.

	groupedByDate := self
		                 setupGroupedDateFrom: since
		                 to: until
		                 over: aDateWeekMonthOrYear.

	gitAnalyzer := GitAnalyzer new
		               onModel: glhModel;
		               glhImporter: glhImporter.

	glhImporter withCommitDiffs: false.
	commits := self
		           loadCommitsFromProjectsIds: itsProjects keys
		           since: since
		           until: until.
	glhImporter withCommitDiffs: true.
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

	^ {
		  (#overEach -> aDateWeekMonthOrYear name).
		  (#forOver -> (groupedByDate keys size printString
		    , aDateWeekMonthOrYear printString)).
		  (#avgAddition
		   ->
		   (groupedByDate collect: [ :d | d at: #addition ]) average asFloat).
		  (#avgDeletion
		   ->
		   (groupedByDate collect: [ :d | d at: #deletion ]) average asFloat).
		  (#details -> groupedByDate).
		  (#userCommits -> commits size) } asDictionary
]

{ #category : #metrics }
GitMetric4User >> commentsContributionsSince: since until: until overA: aDateWeekMonthOrYear [

	| commits contributions groupedByDate |
	'GitMetric4User: comment contribution' recordInfo.

	groupedByDate := self
		                 setupGroupedDateFrom: since
		                 to: until
		                 over: aDateWeekMonthOrYear.

	gitAnalyzer := GitAnalyzer new
		               onModel: glhModel;
		               glhImporter: glhImporter.

	glhImporter withCommitDiffs: false.
	commits := self
		           loadCommitsFromProjectsIds: itsProjects keys
		           since: since
		           until: until.
	glhImporter withCommitDiffs: true.
	commits := commits reject: [ :commit | commit commitCreator ~= user ].
	commits do: [ :commit | glhImporter completeImportedCommit: commit ].


	contributions := commits collect: [ :commit |
		                 commit -> (gitAnalyzer
			                  fromCommit: commit;
			                  analyseCommentContribution) ].


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
		  (#avgComments -> groupedByDate values average asFloat).
		  (#overEach -> aDateWeekMonthOrYear name).
		  (#forOver -> (groupedByDate keys size printString
		    , aDateWeekMonthOrYear printString)).
		  (#userCommits -> commits size) } asDictionary
]

{ #category : #metrics }
GitMetric4User >> commitFrequencySince: since until: until overA: aDateWeekMonthOrYear [

	| periods total groupedByDate userCommits |
	'GitMetric4User: commit frequency' recordInfo.

	groupedByDate := self
		                 setupGroupedDateFrom: since
		                 to: until
		                 over: aDateWeekMonthOrYear.

	glhImporter withCommitDiffs: false.
	userCommits := self
		               loadCommitsFromProjectsIds: itsProjects keys
		               since: since
		               until: until.
	glhImporter withCommitDiffs: true.
	userCommits := userCommits reject: [ :c | c commitCreator ~= user ].

	userCommits do: [ :c |
		| dateOver |
		dateOver := self
			            transformDate: c created_at
			            to: aDateWeekMonthOrYear.
		groupedByDate at: dateOver printString ifPresent: [ :v | v add: c ] ].

	periods := groupedByDate keys size.
	total := groupedByDate values sum: [ :commits | commits size ].


	^ {
		  (#averageFrac -> (total / periods)).
		  (#averageFloat -> (total / periods) asFloat).
		  (#userCommit -> total).
		  (#forOver -> (groupedByDate keys size printString
		    , aDateWeekMonthOrYear printString)).
		  (#periode -> aDateWeekMonthOrYear name).
		  (#details -> groupedByDate) } asOrderedDictionary
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
	"'aWeekOrMonthOrYear' should be the class of Data, Week, Month or Year"

	| frequency aggregatedFrequencies |
	aggregatedFrequencies := self
		                         setupGroupedDateFrom: since
		                         to: until
		                         over: aWeekOrMonthOrYear.

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
GitMetric4User >> delayUntilFirstChurnSince: since until: until onACommitWindowOf: maxCommitWindow overA: aDateWeekMonthOrYear [

	| commits groupedByDate res avg userCommits |
	'GitMetric4User: delay until first churn' recordInfo.

	groupedByDate := self
		                 setupGroupedDateFrom: since
		                 to: until
		                 over: aDateWeekMonthOrYear.

	glhImporter withCommitDiffs: false.
	commits := self
		           loadCommitsFromProjectsIds: itsProjects keys
		           since: since
		           until: until.
	glhImporter withCommitDiffs: true.

	userCommits := commits reject: [ :commit |
		               commit commitCreator ~= user ].
	commits := self
		           foundSuccessorOf: userCommits
		           andCompleteImportForMax: maxCommitWindow.


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
				                  maxChildCommit: maxCommitWindow;
				                  analyseDelayUntilFirstChurn.

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
			       (filtered sum: [ :v | v asDuration asSeconds]) / filtered size ] ].

	res := res reject: #isNil.

	res
		ifEmpty: [ avg := nil ]
		ifNotEmpty: [ avg := res values average asFloat ].


	^ {
		  (#avgDelay -> avg).
		  (#overEach -> aDateWeekMonthOrYear name).
		  (#forOver -> (groupedByDate keys size printString
		    , aDateWeekMonthOrYear printString)).
		  (#details -> groupedByDate) } asDictionary
]

{ #category : #churn }
GitMetric4User >> delayUntilFirstChurnSince: since until: until overA: aDateWeekMonthOrYear [

	| commits groupedByDate res avg |
	self
		deprecated:
		'Use #delayUntilFirstChurnSince:until:onACommitWindowOf:overA: instead'
		on: '1 July 2024'
		in:
		'Pharo-11.0.0+build.726.sha.aece1b5473acf3830a0e082c1bc3a15d4ff3522b (64 Bit)'.

	'GitMetric4User: delay until first churn' recordInfo.

	groupedByDate := self
		                 setupGroupedDateFrom: since
		                 to: until
		                 over: aDateWeekMonthOrYear.

	commits := self
		           loadCommitsFromProjectsIds: itsProjects keys
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
				                  analyseDelayUntilFirstChurn.

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

	res
		ifEmpty: [ avg := nil ]
		ifNotEmpty: [ avg := res values sum / res keys size ].


	^ {
		  (#avgDelay -> avg).
		  (#overEach -> aDateWeekMonthOrYear name).
		  (#forOver -> (groupedByDate keys size printString
		    , aDateWeekMonthOrYear printString)).
		  (#details -> groupedByDate) } asDictionary
]

{ #category : #churn }
GitMetric4User >> foundSuccessorOf: userCommits andCompleteImportForMax: commitLimit [

	| analyzingCommits i size|
	analyzingCommits := Set new.
	glhImporter withCommitDiffs: true.

	userCommits do: [ :c |
		gitAnalyzer
			visitChildCommits: c childCommits
			toStoreThemIn: analyzingCommits
			upto: commitLimit ].

	i := 0.
	size := analyzingCommits size. 
	analyzingCommits do: [ :c |
		('import complete commits  [' , (i:=i+1) printString, '/', size printString , ']'  ) recordInfo.
		glhImporter completeImportedCommit: c ].

	^ analyzingCommits
]

{ #category : #initialization }
GitMetric4User >> initialize [

	user := GLHUser new.
	itsProjects := Dictionary new.
	itsCommits := Dictionary new.
	itsMergeRequests := Dictionary new
]

{ #category : #accessing }
GitMetric4User >> itsProjects: projects [
	itsProjects := projects .
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

	^ self userCommits.
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

	glhImporter withCommitDiffs: false.
	mergeRequest := self
		                loadMergeRequestsFromProjectsIds: itsProjects keys
		                since: since
		                until: until.
	glhImporter withCommitDiffs: true.

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

{ #category : #accessing }
GitMetric4User >> user [
	^ user
]

{ #category : #accessing }
GitMetric4User >> user: anUser [
	user := anUser. 
]

{ #category : #accessing }
GitMetric4User >> userCommits [
	^ user commits
]
