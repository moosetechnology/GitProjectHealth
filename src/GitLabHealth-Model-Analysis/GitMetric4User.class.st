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
GitMetric4User >> commitFrequencyOnProject: projectId since: sinceDate until: untilDate [

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
GitMetric4User >> commitFrequencyOnProject: aProjectId since: since until: until overA: aWeekOrMonthOrYear [
	"'aWeekOrMonthOrYear' should be the class of Week, Month or Year"
	
	|frequency aggregatedFrequencies|
	aggregatedFrequencies := OrderedDictionary new. 
	frequency := self commitFrequencyOnProject:  aProjectId since: since until: until.
	
	
	frequency associations do: [ :assoc | 
		|date commits overDate|
		date := assoc key.
		commits := assoc value. 
		
		
		" convert the date as its week date. For some english reason, the week start in sunday so we should add a + 1 day "
		overDate := ((date asDate) perform: (('as', aWeekOrMonthOrYear name) asSymbol )) asDate. 
		aggregatedFrequencies at: (overDate printString) ifPresent: [ :collection | collection addAll: commits ] ifAbsentPut: [ commits ].
		
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
