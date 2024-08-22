Class {
	#name : #GitMetricExporter,
	#superclass : #Object,
	#instVars : [
		'glhImporter',
		'label',
		'entities',
		'projectCache',
		'sinceTimeLimit',
		'runningPeriods',
		'maxCommitWindow',
		'over',
		'analyses'
	],
	#category : #'GitLabHealth-Model-Analysis'
}

{ #category : #'as yet unclassified' }
GitMetricExporter class >> demoPeriod [

	^ self new
		  addAPeriodFrom: '01 march 2023' to: '31 may 2023';
		  addAPeriodFrom: '01 december 2023' to: '29 february 2024';
		  addAPeriodFrom: '01 march 2024' to: '31 may 2024'
]

{ #category : #adding }
GitMetricExporter >> addAPeriodFrom: since to: until [

	runningPeriods add: {
			(#since -> since asDate).
			(#until -> until asDate) } asDictionary.
	
	^runningPeriods 
]

{ #category : #adding }
GitMetricExporter >> addEntitiesFromUserNames: userNames [
	"import all the project since a certain time"

	'Import all projects from the Git repository' recordInfo.
	projectCache := projectCache ifNil: [
		                glhImporter importProjectsSince: sinceTimeLimit ].

	"then collect the project in which the user has be seen commited"
	entities addAll: (userNames collect: [ :username |
			 | projects metrics i size |
			 projects := self findParticipationOfCommitAuthorNamed: username amongProjects: projectCache.

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

{ #category : #adding }
GitMetricExporter >> addEntitiesFromUserNamesAndProjects: usersWithProjects [

	entities addAll: (usersWithProjects associations collect: [ :assoc |
		            | username projects metrics |
		            username := assoc key.
		            projects := assoc value.

		            metrics := GitMetric4User new.
		            metrics
			            glhImporter: glhImporter;
			            findUserNamed: username.
		            metrics loadProjectsFromIds: projects.

		            metrics ]).

	^ self
]

{ #category : #accessing }
GitMetricExporter >> analyses [

	^ analyses
]

{ #category : #accessing }
GitMetricExporter >> analyses: anObject [

	analyses := anObject
]

{ #category : #utilities }
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

{ #category : #exporting }
GitMetricExporter >> csvMetrics [

	^ OrderedDictionary newFrom: {
			  ('code addition (avg)' -> [ :analysis | analysis codeAddition ]).

			  ('code deletion (avg)' -> [ :analysis | analysis codeDeletion ]).

			  ('commits frequency (avg)'
			   -> [ :analysis | analysis commitFrequency ]).

			  ('comment contribution (avg)'
			   -> [ :analysis | analysis commentContribution ]).

			  ('churn % (W=' , maxCommitWindow printString , ') '
			   -> [ :analysis | analysis codeChurn ]).

			  ('delay Until First Churn (W=' , maxCommitWindow printString
			   , ') ' -> [ :analysis | analysis delayUntilFirstChurn ]).

			  ('number of project with min 1 commit of user'
			   -> [ :analysis | analysis numberOfProjectWithCommit ]).

			  ('merge Request Duration'
			   -> [ :analysis | analysis mergeRequestDuration ]).

			  ('average time between commits'
			   -> [ :analysis | analysis averageTimeBetweenCommits ]).

			  ('number of open merge request'
			   -> [ :analysis | analysis numberOfOpenMergeRequests ]).

			  ('number of merged merge request'
			   -> [ :analysis | analysis numberOfMergedMergeRequest ]).

			  ('number of merge requests closed and not merged'
			   -> [ :analysis | analysis numberOfClosedMergeRequests ]).

			  ('number of merge requests without review'
			   -> [ :analysis | analysis numberOfMergeRequestsWithoutReview ]) }
]

{ #category : #accessing }
GitMetricExporter >> entities: aCollection [ 
	entities := aCollection
]

{ #category : #exporting }
GitMetricExporter >> exportFor: usersWithProjects [

	self exportFor: usersWithProjects over: { Date. Week . Month . Year }.
]

{ #category : #exporting }
GitMetricExporter >> exportFor: usersWithProjects over: aCollectionOfDateWeekMonthOrYear [

	entities ifNil: [
		self addEntitiesFromUserNamesAndProjects: usersWithProjects ].

	self exportFor: aCollectionOfDateWeekMonthOrYear. 
]

{ #category : #exporting }
GitMetricExporter >> exportInCSV [

	| exportBrowserModel file metrics |
	exportBrowserModel := MiExportModel new.

	self analyses ifNil: [ self generateAnalyses ].
	metrics := self csvMetrics.

	runningPeriods do: [ :period |
		| periodAnalyses analysesDate |
		periodAnalyses := self analyses select: [ :analysis |
			                  ((analysis period at: #since) = (period at: #since))
				                  and:
				                  ((analysis period at: #until)
				                  = (period at: #until)) ].
		analysesDate := (period at: #since) asString.

		exportBrowserModel entitiesList: periodAnalyses.

		exportBrowserModel removeColumnForQueryNamed: #Type.
		exportBrowserModel removeColumnForQueryNamed: #Name.

		exportBrowserModel
			addColumnForQuery: [ :analysis | analysis username ]
			withName: #'User name'.


		metrics associations do: [ :association |
			exportBrowserModel
				addColumnForQuery: association value
				withName: (' - ' join: {
							 association key.
							 analysesDate }) ].


		file := self constructFilePath: over.
		file writeStreamDo: [ :aStream |
			aStream
				<< 'sep=,';
				<< OSPlatform current lineEnding.
			exportBrowserModel writeCSVOn: aStream ] ].

	'Done computing' recordInfo
]

{ #category : #exporting }
GitMetricExporter >> exportInDB: repository [

	repository enableSingleton.

	self analyses ifNil: [ self generateAnalyses ].
	self analyses do: [ :analysis | analysis save ]
]

{ #category : #exporting }
GitMetricExporter >> exportInS3: bucketName accessKey: accessKey secretKey: secretKey region: region [

	| s3 bucket ston date fileName |
	AWSS3Config default
		accessKeyId: accessKey;
		secretKey: secretKey;
		regionName: region.

	s3 := AWSS3 new.
	bucket := s3 bucketNamed: bucketName.

	ston := STON toString: analyses.

	date := Date today asString copyReplaceAll: ' ' asString with: '-'.
	fileName := ('-' join: {
			             'analyse'.
			             label.
			             over asString.
			             date }) , '.ston'.

	bucket atKey: fileName putObject: ston
]

{ #category : #projects }
GitMetricExporter >> findParticipationOfCommitAuthorNamed: username amongProjects: aCollectionOfProjects [

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
			                           until: Date today asDateAndTime.
		               response := glhImporter parseCommitsResult: response.
		               response isNotEmpty
		 ].

	^ itsProjects
]

{ #category : #projects }
GitMetricExporter >> findProjectsOfUser: aCollection [ 
	self shouldBeImplemented.
]

{ #category : #analysis }
GitMetricExporter >> generateAnalyses [

	| newAnalyses |
	newAnalyses := OrderedCollection new.

	runningPeriods do: [ :period |
		newAnalyses addAll: (entities collect: [ :entity |
			entity
				generateAnalysisForPeriod: period
				over: over
				withMaxCommitWindows: maxCommitWindow ]) ].

	self analyses: newAnalyses.

	^ newAnalyses
]

{ #category : #analysis }
GitMetricExporter >> generateAnalysesOver: aDateWeekMonthOrYear [

	| newAnalyses |
	over := aDateWeekMonthOrYear.
	newAnalyses := OrderedCollection new.

	runningPeriods do: [ :period |
		newAnalyses addAll: (entities collect: [ :entity |
			entity
				generateAnalysisForPeriod: period
				over: over
				withMaxCommitWindows: maxCommitWindow ]) ].

	self analyses: newAnalyses.

	^ newAnalyses
]

{ #category : #accessing }
GitMetricExporter >> glhImporter: anImporter [

	glhImporter := anImporter withInitialCommits: false; yourself. 
]

{ #category : #adding }
GitMetricExporter >> importAnalysesFromS3: bucketName accessKey: accessKey secretKey: secretKey region: region [

	| s3 bucket xmlObjects contentElements filesContent |
	AWSS3Config default
		accessKeyId: accessKey;
		secretKey: secretKey;
		regionName: region.

	s3 := AWSS3 new.
	bucket := s3 bucketNamed: bucketName.
	xmlObjects := bucket listObjects.
	contentElements := xmlObjects root elementsSelect: [ :element |
		                   element isNamed: 'Contents' ].

	filesContent := contentElements collect: [ :contentElement |
		                | keyValue |
		                keyValue := contentElement contentStringAt: 'Key'.
		                bucket getObject: keyValue ].

	^ analyses := (filesContent collect: [ :file | STON fromString: file ])
		              flattened
]

{ #category : #initialization }
GitMetricExporter >> initialize [

	entities := OrderedCollection new.
	"set up the minimal date from which we are looking for the commits a particular user in projects"
	sinceTimeLimit := '2024-01-01' asDateAndTime..
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

{ #category : #adding }
GitMetricExporter >> onlyImportProjectsOfGroup: groupId [

	| group |
	group := glhImporter importGroup: groupId.
	projectCache := group toScope: GLHProject
]

{ #category : #adding }
GitMetricExporter >> setupAnalysisForUsersWithNames: userNames [
	"import all the project since a certain time"

	| users |
	users := userNames collect: [ :username |
		         glhImporter importUserByUsername: username ].

	glhImporter userCatalogue scrapeAuthorNamesForUsers: users.

	entities addAll: (users collect: [ :user |
			 | itsProjects metrics i size |
			 itsProjects := glhImporter importContributedProjectsOfUser: user.

			 metrics := GitMetric4User new.
			 metrics
				 glhImporter: glhImporter;
				 user: user.

			 i := 0.
			 size := itsProjects size.
			 metrics itsProjects: (itsProjects collect: [ :p |
					  (' ' join: {
							   'complete import of project:'.
							   p name printString.
							   '['.
							   (i := i + 1) printString.
							   '/'.
							   size.
							   ']' }) recordInfo.

					  p id -> (glhImporter completeImportProject: p) ]) asDictionary ]).

	^ self
]
