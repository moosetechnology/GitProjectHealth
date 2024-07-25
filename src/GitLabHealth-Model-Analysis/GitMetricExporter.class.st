Class {
	#name : #GitMetricExporter,
	#superclass : #Object,
	#instVars : [
		'glhImporter',
		'beforeExp',
		'duringExp',
		'label',
		'entities',
		'projectCache',
		'sinceTimeLimit',
		'runningPeriods',
		'maxCommitWindow',
		'over'
	],
	#category : #'GitLabHealth-Model-Analysis'
}

{ #category : #'as yet unclassified' }
GitMetricExporter class >> demoPeriod [

	^ self new
		  addPeriodFrom: '01 march 2023' to: '31 may 2023';
		  addPeriodFrom: '01 december 2023' to: '29 february 2024';
		  addPeriodFrom: '01 march 2024' to: '31 may 2024'
]

{ #category : #'as yet unclassified' }
GitMetricExporter >> addCodeChurnExporter: exportBrowserModel [

	| columnName |
	maxCommitWindow := 3.
	runningPeriods do: [ :period |
		columnName := ('churn % (W=' , maxCommitWindow printString , ') '
		               , period printString) asSymbol.

		exportBrowserModel
			addColumnForQuery: (self blockCodeChurnSince: period)
			withName: columnName.

	 ].
]

{ #category : #'as yet unclassified' }
GitMetricExporter >> addCommentContributionExporter: exportBrowserModel [

	| columnName |
	Smalltalk snapshot: true andQuit: false.

	runningPeriods do: [ :period |
		columnName := ('comment contribution (avg) ' , period printString)
			              asSymbol.

		exportBrowserModel
			addColumnForQuery: (self blockCommentsContributionSince: period)
			withName: columnName ]
]

{ #category : #'as yet unclassified' }
GitMetricExporter >> addContributionExporter: exportBrowserModel [

	| columnName |
	"Code Contribution "
	runningPeriods do: [ :period |
		columnName := ('code addition (avg) ' , period printString) asSymbol.

		exportBrowserModel
			addColumnForQuery: (self blockCodeAdditionSince: period)
			withName: columnName.

		columnName := ('code deletion (avg) ' , period printString) asSymbol.
		exportBrowserModel
			addColumnForQuery: (self blockCodeDeletionSince: period)
			withName: columnName.

	 ]
]

{ #category : #'as yet unclassified' }
GitMetricExporter >> addDelayUntilFirstChurnExporter: exportBrowserModel [

	| columnName |
	runningPeriods do: [ :period |
		columnName := ('delay Until First Churn (W=' , maxCommitWindow printString , ') '
		               , period printString) asSymbol.

		exportBrowserModel
			addColumnForQuery: (self blockDelayUntilFirstChurnSince: period)
			withName: columnName ]
]

{ #category : #'as yet unclassified' }
GitMetricExporter >> addEntitiesFromUserNames: userNames [
	"import all the project since a certain time"

	'Import all projects from the Git repository' recordInfo.
	projectCache := projectCache ifNil: [
		                glhImporter importProjectsSince: sinceTimeLimit ].

	"then collect the project in which the user has be seen commited"
	entities addAll: (userNames collect: [ :username |
			 | projects metrics i size |
			 projects := self findCommitAuthorNamed: username amongProjects: projectCache.

			 metrics := GitMetric4User new.
			 metrics
				 glhImporter: glhImporter;
				 findUserNamed: username.



			 i := 0.
			 size := projects size.
			 metrics itsProjects: (projects collect: [ :p |
					  (' ' join: {
							   'complete import of project:'.
							   p name printString.
							   '['.
							   (i := i + 1) printString.
							   '/'.
							   size.
							   ']' }) recordInfo.

					  p id -> (glhImporter completeImportProject: p) ]) asDictionary.

			 metrics ]).

	^ self
]

{ #category : #'as yet unclassified' }
GitMetricExporter >> addEntitiesFromUserNamesAndProjects: usersWithProjects [

	entities addAll: (usersWithProjects associations collect: [ :assoc |
		            | username projects metrics |
		            username := assoc key.
		            projects := assoc value.

		            metrics := GitMetric4User new.
		            metrics
			            glhImporter: glhImporter;
			            findUserNamed: username.
		            metrics loadProjects: projects.

		            metrics ]).

	^ self
]

{ #category : #'as yet unclassified' }
GitMetricExporter >> addFrequencyCommitExporter: exportBrowserModel [

	| columnName |
	runningPeriods do: [ :period |
		columnName := ('commits frequency (avg) ' , period printString)
			              asSymbol.

		exportBrowserModel
			addColumnForQuery: (self blockCommitFrequencySince: period)
			withName: columnName ]
]

{ #category : #'as yet unclassified' }
GitMetricExporter >> addMergeRequestDurationExporter: exportBrowserModel [

	| columnName |
	runningPeriods do: [ :period |
		columnName := ('merge Request Duration ' , period printString)
			              asSymbol.

		exportBrowserModel
			addColumnForQuery: (self blockMergeRequestDurationSince: period)
			withName: columnName ]
]

{ #category : #adding }
GitMetricExporter >> addPeriodFrom: since to: until [

	runningPeriods add: {
			(#since -> since asDate).
			(#until -> until asDate) } asDictionary.
	
	^runningPeriods 
]

{ #category : #'as yet unclassified' }
GitMetricExporter >> beforeDic: aDictionnarySinceUntil [

	self
		deprecated: 'Use #addPeriodFrom:to: instead'
		on: '11 July 2024'
		in:
		'Pharo-11.0.0+build.726.sha.aece1b5473acf3830a0e082c1bc3a15d4ff3522b (64 Bit)'.

	beforeExp := aDictionnarySinceUntil
]

{ #category : #'as yet unclassified' }
GitMetricExporter >> blockCodeAdditionSince: period [

	^ [ :metrics |
	  ((metrics
		    codeContributionsSince: (period at: #since)
		    until: (period at: #until)
		    overA: over) at: #avgAddition) printString ]
]

{ #category : #'as yet unclassified' }
GitMetricExporter >> blockCodeChurnSince: period [
	"comment stating purpose of instance-side method"

	"scope: class-variables  &  instance-variables"

	^ [ :metrics |
	  ((metrics
		    codeChurnSince: (period at: #since)
		    until: (period at: #until)
		    onACommitWindowOf: maxCommitWindow
		    overA: over) at: #churn) printString ]
]

{ #category : #'as yet unclassified' }
GitMetricExporter >> blockCodeDeletionSince: period [

	^ [ :metrics |
	  ((metrics
		    codeContributionsSince: (period at: #since)
		    until: (period at: #until)
		    overA: over) at: #avgDeletion) printString ]
]

{ #category : #'as yet unclassified' }
GitMetricExporter >> blockCommentsContributionSince: period [

	^ [ :metrics |
	  ((metrics
		    commentsContributionsSince: (period at: #since)
		    until: (period at: #until)
		    overA: over) at: #avgComments) printString ]
]

{ #category : #'as yet unclassified' }
GitMetricExporter >> blockCommitFrequencySince: period [

	^ [ :metrics |
	  ((metrics
		    commitFrequencySince: (period at: #since)
		    until: (period at: #until)
		    overA: over) at: #averageFloat) printString ]
]

{ #category : #'as yet unclassified' }
GitMetricExporter >> blockDelayUntilFirstChurnSince: period [
	"comment stating purpose of instance-side method"

	"scope: class-variables  &  instance-variables"

	^ [ :metrics |
	  ((metrics
		    delayUntilFirstChurnSince: (period at: #since)
		    until: (period at: #until)
			 onACommitWindowOf: maxCommitWindow
		    overA: over) at: #avgDelay) printString ]
]

{ #category : #'as yet unclassified' }
GitMetricExporter >> blockMergeRequestDurationSince: period [
	
	^ [ :metrics |
				Smalltalk snapshot: true andQuit: false.
				((metrics
					  mergeRequestDurationSince: (period at: #since)
					  until: (period at: #until)
					  overA: over) at: #avgDuration) printString ]
]

{ #category : #'as yet unclassified' }
GitMetricExporter >> constructFilePath: runningOver [

	| file |
	file := (FileLocator home
	         /
		         ('GitlabHealth-' , label printString , '-' , runningOver printString
		          , '-'
		          , (DateAndTime now printString replaceAll: $: with: $-)
		          , '.csv')) asFileReference.
	^ file
]

{ #category : #'as yet unclassified' }
GitMetricExporter >> debugExportOver: aCollectionOfDateWeekMonthOrYear [

	| period |
	over := Week.

	period := runningPeriods second.


	1 halt.
	"Code Contribution "
	entities collect: (self blockCodeAdditionSince: period).
	entities collect: (self blockCodeDeletionSince: period).

	"Commit frequencies "
	entities collect: (self blockCommitFrequencySince: period).

	"comment contribution "
	entities collect: (self blockCommentsContributionSince: period).

	"merge Request Duration "
	entities collect: (self blockMergeRequestDurationSince: period).

	"code churn"
	entities collect: (self blockCodeChurnSince: period).

	"delay Until First Churn"
	entities collect: (self blockDelayUntilFirstChurnSince: period).


	'Done computing debug' recordInfo
]

{ #category : #'as yet unclassified' }
GitMetricExporter >> duringDic: aDictionnarySinceUntil [

	self
		deprecated: 'Use #addPeriodFrom:to: instead'
		on: '11 July 2024'
		in:
		'Pharo-11.0.0+build.726.sha.aece1b5473acf3830a0e082c1bc3a15d4ff3522b (64 Bit)'.

	duringExp := aDictionnarySinceUntil
]

{ #category : #accessing }
GitMetricExporter >> entities: aCollection [ 
	entities := aCollection
]

{ #category : #'as yet unclassified' }
GitMetricExporter >> exportFor: usersWithProjects [

	self exportFor: usersWithProjects over: { Date. Week . Month . Year }.
]

{ #category : #'as yet unclassified' }
GitMetricExporter >> exportFor: usersWithProjects over: aCollectionOfDateWeekMonthOrYear [

	entities ifNil: [
		self addEntitiesFromUserNamesAndProjects: usersWithProjects ].

	self exportFor: aCollectionOfDateWeekMonthOrYear. 
]

{ #category : #'as yet unclassified' }
GitMetricExporter >> exportOver: aCollectionOfDateWeekMonthOrYear [

	| file exportBrowserModel |
	exportBrowserModel := MiExportModel new.
	exportBrowserModel entitiesList: entities.
	exportBrowserModel removeColumnForQueryNamed: #Type.
	exportBrowserModel removeColumnForQueryNamed: #Name.

	exportBrowserModel
		addColumnForQuery: [ :metrics | metrics user name printString ]
		withName: #'User name'.

	"Code Contribution "
	self addContributionExporter: exportBrowserModel.

	"Commit frequencies "
	self addFrequencyCommitExporter: exportBrowserModel.

	"comment contribution "
	self addCommentContributionExporter: exportBrowserModel.

	"merge Request Duration "
	self addMergeRequestDurationExporter: exportBrowserModel.

	"code churn"
	self addCodeChurnExporter: exportBrowserModel.

	"delay Until First Churn"
	self addDelayUntilFirstChurnExporter: exportBrowserModel.

	aCollectionOfDateWeekMonthOrYear do: [ :aDateWeekMonthOrYear |
		over := aDateWeekMonthOrYear.
		file := self constructFilePath: over.

		file writeStreamDo: [ :aStream |
			aStream
				<< 'sep=,';
				<< OSPlatform current lineEnding.
			exportBrowserModel writeCSVOn: aStream ] ].

	'Done computing' recordInfo
]

{ #category : #projects }
GitMetricExporter >> findCommitAuthorNamed: username amongProjects: aCollectionOfProjects [

	| response itsProjects i size |
	i := 1.
	size := aCollectionOfProjects size.
	itsProjects := aCollectionOfProjects select: [ :project |
		               (' ' join: {
				                'search'.
				                username printString.
				                'in Project:'.
				                project name printString.
				                '['.
				                (i := i + 1) printString.
				                '/'.
				                size.
				                ']' }) recordInfo.

		               response := glhImporter glhApi
			                           commitsOfUser: username
			                           inProject: project id
			                           since: '01 january 2023' asDateAndTime
			                           until: '24 may 2024' asDateAndTime.
		               response := glhImporter parseCommitsResult: response.
		               response isNotEmpty ].

	^ itsProjects
]

{ #category : #'as yet unclassified' }
GitMetricExporter >> findProjectsOfUser: aCollection [ 
	self shouldBeImplemented.
]

{ #category : #accessing }
GitMetricExporter >> glhImporter: anImporter [

	glhImporter := anImporter withInitialCommits: false; yourself. 
]

{ #category : #initialization }
GitMetricExporter >> initialize [

	entities := OrderedCollection new.
	"set up the minimal date from which we are looking for the commits a particular user in projects"
	sinceTimeLimit := '1 january 2024' asDateAndTime.
	runningPeriods := OrderedCollection new.
	maxCommitWindow := 3.
	over := Date
]

{ #category : #accessing }
GitMetricExporter >> label: aString [ 
	label := aString
]

{ #category : #accessing }
GitMetricExporter >> maxCommitWindow: anInteger [
	maxCommitWindow := anInteger abs
]
