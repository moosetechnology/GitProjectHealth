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
		'over'
	],
	#category : #'GitLabHealth-Model-Analysis'
}

{ #category : #'as yet unclassified' }
GitMetricExporter >> addCodeChurnExporter: exportBrowserModel [


		
	
	| columnName |


	runningPeriods do: [ :period |
		columnName := ('code churn (window=3) ' , period printString)
			              asSymbol.

			exportBrowserModel
		addColumnForQuery: [ :metrics |
			((metrics
				  codeChurnSince: (period at: #since)
				  until: (period at: #until)
				  onACommitWindowOf: 3
				  overA: over) at: #churn) printString ]
		withName: columnName.
			
				Smalltalk snapshot: true andQuit: false.
			]
]

{ #category : #'as yet unclassified' }
GitMetricExporter >> addCommentContributionExporter: exportBrowserModel [

	| columnName |
	Smalltalk snapshot: true andQuit: false.

	runningPeriods do: [ :period |
		columnName := ('comment contribution (avg) ' , period printString)
			              asSymbol.

		exportBrowserModel
			addColumnForQuery: [ :metrics |
				((metrics
					  commentsContributionsSince: (period at: #since)
					  until: (period at: #until)
					  overA: over) at: #avgComments) printString ]
			withName: columnName ]
]

{ #category : #'as yet unclassified' }
GitMetricExporter >> addContributionExporter: exportBrowserModel [

	| columnName |
	"Code Contribution "
	runningPeriods do: [ :period |
		columnName := ('code addition (avg) ' , period printString) asSymbol.

		exportBrowserModel
			addColumnForQuery: [ :metrics |
				((metrics
					  codeContributionsSince: (period at: #since)
					  until: (period at: #until)
					  overA: over) at: #avgAddition) printString ]
			withName: columnName.

		columnName := ('code deletion (avg) ' , period printString) asSymbol.
		exportBrowserModel
			addColumnForQuery: [ :metrics |
				((metrics
					  codeContributionsSince: (period at: #since)
					  until: (period at: #until)
					  overA: over) at: #avgDeletion) printString ]
			withName: columnName.
			
			Smalltalk snapshot: true andQuit: false.
			
			 ]
]

{ #category : #'as yet unclassified' }
GitMetricExporter >> addDelayUntilFirstChurnExporter: exportBrowserModel [

	
		
		| columnName |

	runningPeriods do: [ :period |
		columnName := ('delay Until First Churn ' , period printString)
			              asSymbol.

exportBrowserModel
		addColumnForQuery: [ :metrics |
			((metrics
				  delayUntilFirstChurnSince: (period at: #since)
				  until: (period at: #until)
				  overA: over) at: #avgDelay) printString ]
		withName: columnName
			
			
			]
	
	
]

{ #category : #'as yet unclassified' }
GitMetricExporter >> addEntitiesFromUserNames: userNames [

	projectCache := projectCache ifNil: [ glhImporter importProjectsSince: sinceTimeLimit ].

	entities addAll: (userNames collect: [ :username |
			 | projects metrics |
			 projects := self findProjectsOfUser: username inside: projectCache.

			 metrics := GitMetric4User new.
			 metrics
				 glhImporter: glhImporter;
				 findUserNamed: username.
			 metrics itsProjects:
				 (projects collect: [ :p | p id -> p ]) asDictionary.

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
			addColumnForQuery: [ :metrics |
				((metrics
					  commitFrequencySince: (period at: #since)
					  until: (period at: #until)
					  overA: over) at: #averageFloat) printString ]
			withName: columnName ]
]

{ #category : #'as yet unclassified' }
GitMetricExporter >> addMergeRequestDurationExporter: exportBrowserModel [


		| columnName |
	runningPeriods do: [ :period |
		columnName := ('merge Request Duration ' , period printString)
			              asSymbol.

		exportBrowserModel
		addColumnForQuery: [ :metrics |
			Smalltalk snapshot: true andQuit: false.
			((metrics
				  mergeRequestDurationSince: (period at: #since)
				  until: (period at: #until)
				  overA: over) at: #avgDuration) printString ]
		withName: columnName
			
			
			 ]
	
	
]

{ #category : #'as yet unclassified' }
GitMetricExporter >> beforeDic: aDictionnarySinceUntil [

	beforeExp := aDictionnarySinceUntil
]

{ #category : #'as yet unclassified' }
GitMetricExporter >> constructFilePath: over [

	| file |
	file := (FileLocator home
	         /
		         ('IA4Code-' , label printString , '-' , over printString
		          , '-'
		          , (DateAndTime now printString replaceAll: $: with: $-)
		          , '.csv')) asFileReference.
	^ file
]

{ #category : #'as yet unclassified' }
GitMetricExporter >> debugExportOver: aCollectionOfDateWeekMonthOrYear [

	| over |
	over := Date.


	"Code Contribution "
	entities collect: [ :metrics |
		((metrics
			  codeContributionsSince: (beforeExp at: #since)
			  until: (beforeExp at: #until)
			  overA: over) at: #avgAddition) printString ].

	entities collect: [ :metrics |
		((metrics
			  codeContributionsSince: (beforeExp at: #since)
			  until: (beforeExp at: #until)
			  overA: over) at: #avgDeletion) printString ].

	entities collect: [ :metrics |
		Smalltalk snapshot: true andQuit: false.
		((metrics
			  codeContributionsSince: (duringExp at: #since)
			  until: (duringExp at: #until)
			  overA: over) at: #avgAddition) printString ].

	entities collect: [ :metrics |
		((metrics
			  codeContributionsSince: (duringExp at: #since)
			  until: (duringExp at: #until)
			  overA: over) at: #avgDeletion) printString ].



	"Commit frequencies "
	entities collect: [ :metrics |
		((metrics
			  commitFrequencySince: (beforeExp at: #since)
			  until: (beforeExp at: #until)
			  overA: over) at: #averageFloat) printString ].


	entities collect: [ :metrics |
		((metrics
			  commitFrequencySince: (duringExp at: #since)
			  until: (duringExp at: #until)
			  overA: over) at: #averageFloat) printString ].


	"comment contribution "
	entities collect: [ :metrics |
		Smalltalk snapshot: true andQuit: false.
		((metrics
			  commentsContributionsSince: (beforeExp at: #since)
			  until: (beforeExp at: #until)
			  overA: over) at: #avgComments) printString ].

	entities collect: [ :metrics |
		((metrics
			  commentsContributionsSince: (duringExp at: #since)
			  until: (duringExp at: #until)
			  overA: over) at: #avgComments) printString ].


	"merge Request Duration "
	entities collect: [ :metrics |
		Smalltalk snapshot: true andQuit: false.
		((metrics
			  mergeRequestDurationSince: (beforeExp at: #since)
			  until: (beforeExp at: #until)
			  overA: over) at: #avgDuration) printString ].

	entities collect: [ :metrics |
		((metrics
			  mergeRequestDurationSince: (duringExp at: #since)
			  until: (duringExp at: #until)
			  overA: over) at: #avgDuration) printString ].


	"code churn"
	entities collect: [ :metrics |
		((metrics
			  codeChurnSince: (beforeExp at: #since)
			  until: (beforeExp at: #until)
			  onACommitWindowOf: 3
			  overA: over) at: #churn) printString ].

	entities collect: [ :metrics |
		((metrics
			  codeChurnSince: (duringExp at: #since)
			  until: (duringExp at: #until)
			  onACommitWindowOf: 3
			  overA: over) at: #churn) printString ].

	"delay Until First Churn"
	entities collect: [ :metrics |
		((metrics
			  delayUntilFirstChurnSince: (beforeExp at: #since)
			  until: (beforeExp at: #until)
			  overA: over) at: #avgDelay) printString ].

	entities collect: [ :metrics |
		((metrics
			  delayUntilFirstChurnSince: (duringExp at: #since)
			  until: (duringExp at: #until)
			  overA: over) at: #avgDelay) printString ].


	'Done computing' recordInfo
]

{ #category : #'as yet unclassified' }
GitMetricExporter >> duringDic: aDictionnarySinceUntil [
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


	aCollectionOfDateWeekMonthOrYear do: [ :period |
		over := period.
		file := self constructFilePath: over.

		file writeStreamDo: [ :aStream |
			aStream
				<< 'sep=,';
				<< OSPlatform current lineEnding.
			exportBrowserModel writeCSVOn: aStream.

			aStream << OSPlatform current lineEnding.

			aStream << ('(B): ' , beforeExp printString)
			<< OSPlatform current lineEnding.
			aStream << ('(D): ' , duringExp printString)
			<< OSPlatform current lineEnding ] ].

	'Done computing' recordInfo
]

{ #category : #'as yet unclassified' }
GitMetricExporter >> findProjectsOfUser: aCollection [ 
	self shouldBeImplemented.
]

{ #category : #projects }
GitMetricExporter >> findProjectsOfUser: username inside: aCollectionOfProjects [

	| response itsProjects |
	itsProjects := aCollectionOfProjects select: [ :project |
		               response := glhImporter glhApi
			                           commitsOfUser: username
			                           inProject: project id since: '01 january 2023' asDateAndTime  until: '24 may 2024' asDateAndTime.
		               response := glhImporter parseCommitsResult: response.

		               response isNotEmpty ].

	^ itsProjects
]

{ #category : #accessing }
GitMetricExporter >> glhImporter: anImporter [

	glhImporter := anImporter withInitialCommits: false; yourself. 
]

{ #category : #initialization }
GitMetricExporter >> initialize [

	entities := OrderedCollection new.
	sinceTimeLimit := '1 january 2023' asDateAndTime.
	runningPeriods := OrderedCollection new
		                  add: {
				                  (#since -> '1 march 2023' asDate).
				                  (#until -> '24 may 2023' asDate) } asDictionary;
		                  add: {
				                  (#since -> '1 march 2024' asDate).
				                  (#until -> '24 may 2024' asDate) } asDictionary;
		                  add: {
				                  (#since -> '1 december 2024' asDate).
				                  (#until -> '24 february 2024' asDate) }
				                  asDictionary;
		                  yourself.
		over := Date.
]

{ #category : #accessing }
GitMetricExporter >> label: aString [ 
	label := aString
]
