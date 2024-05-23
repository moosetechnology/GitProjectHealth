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
		
		commits ifNotEmpty: [ 
				" convert the date as its week date. For some english reason, the week start in sunday so we should add a + 1 day "
		overDate := (date asDate perform:
			             ('as' , aWeekOrMonthOrYear name) asSymbol) asDate.
		aggregatedFrequencies
			at: overDate printString
			ifPresent: [ :collection | collection addAll: commits ]
			ifAbsentPut: [ commits ] 
			
			 ]

	
			
			].

	^ aggregatedFrequencies
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

{ #category : #loading }
GitMetric4User >> loadProjects: aCollection [

	aCollection do: [ :id |
		itsProjects at: id ifAbsentPut: (glhImporter importProject: id) ].

	^ itsProjects
]

{ #category : #accessing }
GitMetric4User >> user [
	^ user
]

{ #category : #accessing }
GitMetric4User >> user: anUser [
	user := anUser. 
]
