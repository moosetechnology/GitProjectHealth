Class {
	#name : #GitMetricExporter,
	#superclass : #Object,
	#instVars : [
		'glhImporter',
		'jiraImporter',
		'label',
		'entities',
		'projectCache',
		'sinceTimeLimit',
		'runningPeriods',
		'maxCommitWindow',
		'over',
		'emailDomain',
		'metrics',
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
	
	self
		deprecated: 'Use #setupAnalysesForUsersWithNames instead'
		on: '03 Sept 2024'
		in:
		'Pharo-11.0.0+build.726.sha.aece1b5473acf3830a0e082c1bc3a15d4ff3522b (64 Bit)'.

	'Import all projects from the Git repository' recordInfo.
	projectCache := projectCache ifNil: [
		                glhImporter importProjectsSince: sinceTimeLimit ].

	"then collect the project in which the user has be seen commited"
	entities addAll: (userNames collect: [ :username |
			 | projects  i size |
			 projects := self
				             findParticipationOfCommitAuthorNamed: username
				             amongProjects: projectCache.

			"metrics := GitMetric4User new.
			 metrics
				 glhImporter: glhImporter;
				 jiraImporter: jiraImporter;
				 findUserNamed: username."



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

	self
		deprecated: 'Use #setupAnalysesForUsersWithNames instead'
		on: '03 Sept 2024'
		in:
		'Pharo-11.0.0+build.726.sha.aece1b5473acf3830a0e082c1bc3a15d4ff3522b (64 Bit)'.

	entities addAll: (usersWithProjects associations collect: [ :assoc |
			 | username projects  |
			 username := assoc key.
			 projects := assoc value.

			" metrics := GitMetric4User new.
			 metrics
				 glhImporter: glhImporter;
				 jiraImporter: jiraImporter;
				 findUserNamed: username.
			 metrics loadProjectsFromIds: projects."

			 username ]).

	^ self 
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
GitMetricExporter >> csvMetricsFor: metricCollection at: date [

	| csvMetrics |
	csvMetrics := metricCollection collect: [ :metric |
		              metric new description , ' - ' , date asString
		              -> [ :groupAnalyses |
			              | analysis |
			              analysis := self
				                          getAnalysisWithDate: date
				                          from: groupAnalyses.
			              analysis
				              ifNil: [ nil ]
				              ifNotNil: [ analysis metrics at: metric new name ] ] ].

	^ csvMetrics asOrderedDictionary
]

{ #category : #accessing }
GitMetricExporter >> entities: aCollection [ 
	entities := aCollection
]

{ #category : #exporting }
GitMetricExporter >> exportFor: usersWithProjects [

	self
		deprecated: 'Use #exportInCSV instead'
		on: '03 Sept 2024'
		in:
		'Pharo-11.0.0+build.726.sha.aece1b5473acf3830a0e082c1bc3a15d4ff3522b (64 Bit)'.

	self exportFor: usersWithProjects over: {
			Date.
			Week.
			Month.
			Year }
]

{ #category : #exporting }
GitMetricExporter >> exportFor: usersWithProjects over: aCollectionOfDateWeekMonthOrYear [

	self
		deprecated: 'Use #exportInCSV instead'
		on: '03 Sept 2024'
		in:
		'Pharo-11.0.0+build.726.sha.aece1b5473acf3830a0e082c1bc3a15d4ff3522b (64 Bit)'.

	entities ifNil: [
		self addEntitiesFromUserNamesAndProjects: usersWithProjects ].

	self exportFor: aCollectionOfDateWeekMonthOrYear
]

{ #category : #exporting }
GitMetricExporter >> exportInCSV [

	self exportUserAnalysesInCSV.
	self exportProjectAnalysesInCSV.
]

{ #category : #exporting }
GitMetricExporter >> exportInDB: repository [

	repository enableSingleton.
	analyses do: [ :analysis | analysis save ]
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

{ #category : #exporting }
GitMetricExporter >> exportProjectAnalysesInCSV [

	| exportBrowserModel groupedByOver group groupOver groupByName periods csvMetrics file |
	exportBrowserModel := MiExportModel new.

	groupedByOver := self projectAnalyses groupedBy: #over.

	groupedByOver associations do: [ :groupAssociation |
		group := groupAssociation value.
		groupOver := groupAssociation key.


		groupByName := group groupedBy: #projectName.
		exportBrowserModel entitiesList: groupByName.

		exportBrowserModel removeColumnForQueryNamed: #Type.
		exportBrowserModel removeColumnForQueryNamed: #Name.

		exportBrowserModel
			addColumnForQuery: [ :groupAnalyses |
			(groupAnalyses at: 1) projectName ]
			withName: #'Project name'.

		periods := (group groupedBy: #period) keys.

		periods do: [ :period |
			csvMetrics := self
				              csvMetricsFor: self projectMetrics
				              at: (period at: #since).


			csvMetrics associations do: [ :association |
				exportBrowserModel
					addColumnForQuery: association value
					withName: association key ] ].

		file := self constructFilePath: groupOver.
		file writeStreamDo: [ :aStream |
			aStream
				<< 'sep=,';
				<< OSPlatform current lineEnding.
			exportBrowserModel writeCSVOn: aStream ] ]
]

{ #category : #exporting }
GitMetricExporter >> exportUserAnalysesInCSV [

	| exportBrowserModel groupedByOver group groupOver groupByName periods csvMetrics file |
	exportBrowserModel := MiExportModel new.

	groupedByOver := self userAnalyses groupedBy: #over.
	

	groupedByOver associations do: [ :groupAssociation |
		group := groupAssociation value.
		groupOver := groupAssociation key.


		groupByName := group groupedBy: #username.
		exportBrowserModel entitiesList: groupByName.

		exportBrowserModel removeColumnForQueryNamed: #Type.
		exportBrowserModel removeColumnForQueryNamed: #Name.

		exportBrowserModel
			addColumnForQuery: [ :groupAnalyses |
			(groupAnalyses at: 1) username ]
			withName: #'User name'.

		periods := (group groupedBy: #period) keys.

		periods do: [ :period |
			csvMetrics := self
				              csvMetricsFor: self userMetrics
				              at: (period at: #since).


			csvMetrics associations do: [ :association |
				exportBrowserModel
					addColumnForQuery: association value
					withName: association key ] ].

		file := self constructFilePath: groupOver.
		file writeStreamDo: [ :aStream |
			aStream
				<< 'sep=,';
				<< OSPlatform current lineEnding.
			exportBrowserModel writeCSVOn: aStream ] ]
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
GitMetricExporter >> generateAnalysesOver: aDateWeekMonthOrYear [

	| userAnalyses projectAnalyses |
	runningPeriods do: [ :period |
		userAnalyses := self
			                generateUsersAnalysesDuringPeriod: period
			                over: aDateWeekMonthOrYear.
		projectAnalyses := self
			                   generateProjectsAnalysesDuringPeriod: period
			                   over: aDateWeekMonthOrYear ].

	^ analyses := userAnalyses, projectAnalyses.
]

{ #category : #analysis }
GitMetricExporter >> generateProjectsAnalysesDuringPeriod: period over: aDateWeekMonthOrYear [

	^self projectEntities collect: [ :project |
		ProjectAnalysisReport new
			projectName: project name;
			period: period;
			over: aDateWeekMonthOrYear ]
]

{ #category : #analysis }
GitMetricExporter >> generateUsersAnalysesDuringPeriod: period over: aDateWeekMonthOrYear [

	| userAnalysisReport newMetric result |
	^ self userEntities collect: [ :user |
		  userAnalysisReport := UserAnalysisReport new
			                        username: user name;
			                        period: period;
			                        over: aDateWeekMonthOrYear.

		  metrics do: [ :metric |
			  newMetric := metric new
				               glhImporter: glhImporter;
				               jiraImporter: jiraImporter;
				               setPeriodSince: (period at: #since)
				               until: (period at: #until);
				               over: aDateWeekMonthOrYear;
				               user: user;
									emailDomain: emailDomain.


			  result := newMetric calculate.
			  userAnalysisReport metrics at: newMetric name put: result ].

		  userAnalysisReport ]
]

{ #category : #utilities }
GitMetricExporter >> getAnalysisWithDate: date from: analysisCollection [

	^analysisCollection
		detect: [ :groupAnalysis | (groupAnalysis period at: #since) = date ]
		ifNone: [ nil ]
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
	sinceTimeLimit := '2024-01-01' asDateAndTime.
	runningPeriods := OrderedCollection new.
	maxCommitWindow := 3.
	over := Date.

	analyses := OrderedCollection new.

	metrics := {
		           CodeAdditionMetric.
		           CodeDeletionMetric.
		           CommentContributionMetric.
		           CommitFrequencyMetric.
		           CodeChurnMetric.
		           DelayUntilFirstChurnMetric.
		           TimeBetweenCommitMetric.
		           ContributedProjectMetric.
		           MergeRequestDurationMetric.
		           OpenedMergeRequestMetric.
		           ClosedMergeRequestMetric.
		           MergedMergeRequestMetric.
		           MergedMergeRequestWithoutReviewMetric.
		           ClosedTicketsMetric}
]

{ #category : #accessing }
GitMetricExporter >> jiraImporter: anObject [

	jiraImporter := anObject
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

{ #category : #accessing }
GitMetricExporter >> projectAnalyses [

	^ analyses select: [ :analysis | analysis class = ProjectAnalysisReport ]
]

{ #category : #accessing }
GitMetricExporter >> projectEntities [

	^ entities select: [ :entity | entity class = GLHProject ]
]

{ #category : #accessing }
GitMetricExporter >> projectMetrics [

	^ metrics select: [ :metric | metric inheritsFrom: ProjectMetric ]
]

{ #category : #setup }
GitMetricExporter >> setupAnalysisForProjectsWithIds: projectIds [

	| projects |
	projects := glhImporter importProjects: projectIds.

	entities addAll: projects
]

{ #category : #setup }
GitMetricExporter >> setupAnalysisForUsersWithNames: userNames [
	"import all the project since a certain time"

	| users |
	users := userNames collect: [ :username |
		         glhImporter importUserByUsername: username ].

	glhImporter userCatalogue scrapeAuthorNamesForUsers: users.
	
	users do: [ :user |
		|projects |
		projects := glhImporter importContributedProjectsOfUser: user.
				projects do: [ :project |
				glhImporter completeImportProject: project ].	 
		
	].

	entities addAll: users.

	^ self
]

{ #category : #accessing }
GitMetricExporter >> userAnalyses [

	^ analyses select: [ :analysis | analysis class = UserAnalysisReport ]
]

{ #category : #accessing }
GitMetricExporter >> userEntities [

	^ entities select: [ :entity | entity class = GLHUser ]
]

{ #category : #accessing }
GitMetricExporter >> userMetrics [

	^ metrics select: [ :metric | metric inheritsFrom: UserMetric ]
]

{ #category : #setup }
GitMetricExporter >> withEmailDomain: anEmailDomain [

	"define the email domain of your Git user. Usefull to link them between service (i.e. Jira)"
	emailDomain := anEmailDomain
]
