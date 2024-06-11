Class {
	#name : #GitMetricExporter,
	#superclass : #Object,
	#instVars : [
		'glhImporter',
		'beforeExp',
		'duringExp',
		'label'
	],
	#category : #'GitLabHealth-Model-Analysis'
}

{ #category : #'as yet unclassified' }
GitMetricExporter >> beforeDic: aDictionnarySinceUntil [

	beforeExp := aDictionnarySinceUntil
]

{ #category : #'as yet unclassified' }
GitMetricExporter >> duringDic: aDictionnarySinceUntil [
	duringExp := aDictionnarySinceUntil
]

{ #category : #'as yet unclassified' }
GitMetricExporter >> exportFor: usersWithProjects [

	self exportFor: usersWithProjects over: { Date. Week . Month . Year }.
]

{ #category : #'as yet unclassified' }
GitMetricExporter >> exportFor: usersWithProjects over: aCollectionOfDateWeekMonthOrYear [

	| over entities file exportBrowserModel |
	over := Date.


	entities := usersWithProjects associations collect: [ :assoc |
		            | username projects metrics |
		            username := assoc key.
		            projects := assoc value.

		            metrics := GitMetric4User new.
		            metrics
			            glhImporter: glhImporter;
			            findUserNamed: username.
		            metrics loadProjects: projects.

		            metrics ].



	exportBrowserModel := MiExportModel new.
	exportBrowserModel entitiesList: entities.
	exportBrowserModel removeColumnForQueryNamed: #Type.
	exportBrowserModel removeColumnForQueryNamed: #Name.

	exportBrowserModel
		addColumnForQuery: [ :metrics | metrics user name printString ]
		withName: #'User name'.


	"Code Contribution "
	exportBrowserModel
		addColumnForQuery: [ :metrics |
			((metrics
				  codeContributionsSince: (beforeExp at: #since)
				  until: (beforeExp at: #until)
				  overA: over) at: #avgAddition) printString ]
		withName: #'(B) code additions (avg)'.
	exportBrowserModel
		addColumnForQuery: [ :metrics |
			((metrics
				  codeContributionsSince: (beforeExp at: #since)
				  until: (beforeExp at: #until)
				  overA: over) at: #avgDeletion) printString ]
		withName: #'(B) code deletion (avg)'.

	exportBrowserModel
		addColumnForQuery: [ :metrics |
			((metrics
				  codeContributionsSince: (duringExp at: #since)
				  until: (duringExp at: #until)
				  overA: over) at: #avgAddition) printString ]
		withName: #'(D) code additions (avg)'.
	exportBrowserModel
		addColumnForQuery: [ :metrics |
			((metrics
				  codeContributionsSince: (duringExp at: #since)
				  until: (duringExp at: #until)
				  overA: over) at: #avgDeletion) printString ]
		withName: #'(D) code deletion (avg)'.


	"Commit frequencies "
	exportBrowserModel
		addColumnForQuery: [ :metrics |
			((metrics
				  commitFrequencySince: (beforeExp at: #since)
				  until: (beforeExp at: #until)
				  overA: over) at: #averageFloat) printString ]
		withName: #'(B) commits frequency (avg)'.

	exportBrowserModel
		addColumnForQuery: [ :metrics |
			((metrics
				  commitFrequencySince: (duringExp at: #since)
				  until: (duringExp at: #until)
				  overA: over) at: #averageFloat) printString ]
		withName: #'(D) commits frequency (avg)'.


	"comment contribution "
	exportBrowserModel
		addColumnForQuery: [ :metrics |
			((metrics
				  commentsContributionsSince: (beforeExp at: #since)
				  until: (beforeExp at: #until)
				  overA: over) at: #avgComments) printString ]
		withName: #'(B) comment contribution (avg)'.

	exportBrowserModel
		addColumnForQuery: [ :metrics |
			((metrics
				  commentsContributionsSince: (duringExp at: #since)
				  until: (duringExp at: #until)
				  overA: over) at: #avgComments) printString ]
		withName: #'(D) comment contribution (avg)'.


	"merge Request Duration "
	exportBrowserModel
		addColumnForQuery: [ :metrics |
			((metrics
				  mergeRequestDurationSince: (beforeExp at: #since)
				  until: (beforeExp at: #until)
				  overA: over) at: #avgDuration) printString ]
		withName: #'(B) merge Request Duration'.

	exportBrowserModel
		addColumnForQuery: [ :metrics |
			((metrics
				  mergeRequestDurationSince: (duringExp at: #since)
				  until: (duringExp at: #until)
				  overA: over) at: #avgDuration) printString ]
		withName: #'(D) merge Request Duration'.


	"code churn"
	exportBrowserModel
		addColumnForQuery: [ :metrics |
			((metrics
				  codeChurnSince: (beforeExp at: #since)
				  until: (beforeExp at: #until)
				  onACommitWindowOf: 3
				  overA: over) at: #churn) printString ]
		withName: #'(B) code churn (window=3)'.

	exportBrowserModel
		addColumnForQuery: [ :metrics |
			((metrics
				  codeChurnSince: (duringExp at: #since)
				  until: (duringExp at: #until)
				  onACommitWindowOf: 3
				  overA: over) at: #churn) printString ]
		withName: #'(D) code churn (window=3)'.

	"delay Until First Churn"
	exportBrowserModel
		addColumnForQuery: [ :metrics |
			((metrics
				  delayUntilFirstChurnSince: (beforeExp at: #since)
				  until: (beforeExp at: #until)
				  overA: over) at: #avgDelay) printString ]
		withName: #'(B) delay Until First Churn'.

	exportBrowserModel
		addColumnForQuery: [ :metrics |
			((metrics
				  delayUntilFirstChurnSince: (duringExp at: #since)
				  until: (duringExp at: #until)
				  overA: over) at: #avgDelay) printString ]
		withName: #'(D) delay until first churn'.




	aCollectionOfDateWeekMonthOrYear do: [ :period |
		over := period.

		file := (FileLocator home
		         /
			         ('IA4Code-' , label printString , '-' , over printString
			          , '-'
			          , (DateAndTime now printString replaceAll: $: with: $-)
			          , '.csv')) asFileReference.

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

{ #category : #accessing }
GitMetricExporter >> glhImporter: anImporter [
	glhImporter := anImporter. 
]
