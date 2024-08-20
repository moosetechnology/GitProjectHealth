Class {
	#name : #GitMetric,
	#superclass : #Object,
	#instVars : [
		'user',
		'glhImporter',
		'itsProjects',
		'gitAnalyzer',
		'glhModel'
	],
	#category : #'GitLabHealth-Model-Analysis'
}

{ #category : #setup }
GitMetric class >> setupGroupedDateFrom: since to: until over: aDateWeekMonthOrYear [

	| groupedByDate start end over increment |
	groupedByDate := OrderedDictionary new.

	increment := 1.
	start := self transformDate: since to: aDateWeekMonthOrYear.
	end := self transformDate: until to: aDateWeekMonthOrYear.

	groupedByDate
		at: start printString
		ifAbsentPut: [ OrderedCollection new ].

	over := aDateWeekMonthOrYear name asLowercase asSymbol.
	over = #date ifTrue: [ over := #day ].
	over = #month ifTrue: [
		increment := 32.
		over := #day ].


	[ groupedByDate keys last asDateAndTime < end ] whileTrue: [
		| index |
		index := groupedByDate keys last asDateAndTime
		         + (increment perform: over).
		index := self transformDate: index to: aDateWeekMonthOrYear.
		groupedByDate
			at: index printString
			ifAbsentPut: [ OrderedCollection new ] ].


	over = #day ifTrue: [
		groupedByDate keysDo: [ :date |
			| aWeekday |
			aWeekday := date asDate weekday.
			(aWeekday = #Sunday or: [ aWeekday = #Saturday ]) ifTrue: [
				groupedByDate removeKey: date ] ] ].


	groupedByDate
		at: end printString
		ifAbsentPut: [ OrderedCollection new ].

	^ groupedByDate
]

{ #category : #'as yet unclassified' }
GitMetric class >> transformDate: date to: aWeekOrMonthOrYear [

	aWeekOrMonthOrYear = Month ifTrue: [ ^ date asDate month asDate ].

	^ (date asDate perform: ('as' , aWeekOrMonthOrYear name) asSymbol)
		  asDate
]

{ #category : #'as yet unclassified' }
GitMetric >> cacheSymbolFor: anEntityType since: since until: until [

	^ (anEntityType printString , ' since ' , since printString , ' to '
	   , until printString) asSymbol
]

{ #category : #'as yet unclassified' }
GitMetric >> findUserNamed: aUsername [

	user := glhImporter importUserByUsername: aUsername.
	^ user
]

{ #category : #accessing }
GitMetric >> glhImporter: aGLPHModelImporter [ 
	glhImporter := aGLPHModelImporter
]

{ #category : #churn }
GitMetric >> loadCommitsFromProjectsIds: aCollection since: since until: until [

	| allCommits period size i|
	period := self cacheSymbolFor: GLHCommit since: since until: until.

	"download commits unless project cache is not empty"
	allCommits := aCollection collect: [ :idProject |
		              | project |
		              project := itsProjects at: idProject.
		              project repository cacheAt: period ifAbsentPut: [
			              | foundCommits |
			              foundCommits := glhImporter
				                              importCommitsOProject: project
				                              since: since
				                              until: until.
			              foundCommits ] ].

	allCommits := allCommits flatten.

	i := 0. 
	size := allCommits size.
	allCommits do: [ :commit |
		('import commit creators [',  (i:=i+1) printString,  '/', size printString) recordInfo. 

		glhImporter importCreatorOfCommit: commit ].

	glhImporter chainsCommitsFrom: allCommits.

	^ allCommits
]

{ #category : #churn }
GitMetric >> loadMergeRequestsFromProjectsIds: aCollection since: since until: until [

	| allMr period |
	"itsMergeRequests ifNil: [ itsMergeRequests := Dictionary new ]."
	period := self
		          cacheSymbolFor: GLPHEMergeRequest
		          since: since
		          until: until.

	allMr := aCollection collect: [ :idProject |
		         | project mr |
		         project := itsProjects at: idProject.
		         project cacheAt: period ifAbsentPut: [
			         mr := glhImporter
				               importMergeRequests: project
				               since: since
				               until: until.
			         mr ] ].

	^ allMr flattened
]

{ #category : #loading }
GitMetric >> loadProjectsFromIds: projectIds [

	projectIds do: [ :id |
		
		itsProjects at: id ifAbsentPut: [ glhImporter importProject: id ] ].

	^ itsProjects
]

{ #category : #setup }
GitMetric >> setupGroupedDateFrom: since to: until over: aDateWeekMonthOrYear [

	| groupedByDate start end over increment |
	groupedByDate := OrderedDictionary new.

	increment := 1.
	start := self transformDate: since to: aDateWeekMonthOrYear.
	end := self transformDate: until to: aDateWeekMonthOrYear.

	groupedByDate
		at: start printString
		ifAbsentPut: [ OrderedCollection new ].

	over := aDateWeekMonthOrYear name asLowercase asSymbol.
	over = #date ifTrue: [ over := #day ].
	over = #month ifTrue: [
		increment := 32.
		over := #day ].


	[ groupedByDate keys last asDateAndTime < end ] whileTrue: [
		| index |
		index := groupedByDate keys last asDateAndTime
		         + (increment perform: over).
		index := self transformDate: index to: aDateWeekMonthOrYear.
		groupedByDate
			at: index printString
			ifAbsentPut: [ OrderedCollection new ] ].


	over = #day ifTrue: [
		
	 groupedByDate := 	(groupedByDate associations select: [ :date |
			| aWeekday |
			aWeekday := date key asDate weekday.
			(aWeekday = #Sunday or: [ aWeekday = #Saturday ]) not ]) asOrderedDictionary ].


	groupedByDate
		at: end printString
		ifAbsentPut: [ OrderedCollection new ].

	^ groupedByDate
]

{ #category : #'as yet unclassified' }
GitMetric >> transformDate: date to: aWeekOrMonthOrYear [

	aWeekOrMonthOrYear = Month ifTrue: [ ^ date asDate month asDate ].

	^ (date asDate perform: ('as' , aWeekOrMonthOrYear name) asSymbol)
		  asDate
]
