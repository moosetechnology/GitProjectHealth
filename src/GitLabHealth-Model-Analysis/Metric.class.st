Class {
	#name : #Metric,
	#superclass : #Object,
	#instVars : [
		'period',
		'over',
		'glhImporter',
		'jiraImporter'
	],
	#category : #'GitLabHealth-Model-Analysis'
}

{ #category : #testing }
Metric class >> isAbstract [

	^ self == Metric
]

{ #category : #'as yet unclassified' }
Metric >> accronym [
	^ (self name first uppercase asString), (self name select: #isUppercase) 
]

{ #category : #'as yet unclassified' }
Metric >> cacheSymbolFor: anEntityType since: since until: until [

	^ (anEntityType printString , ' since ' , since printString , ' to '
	   , until printString) asSymbol
]

{ #category : #calculating }
Metric >> calculate [ 
 ^self subclassResponsibility 
]

{ #category : #accessing }
Metric >> description [

	^ self subclassResponsibility
]

{ #category : #churn }
Metric >> foundSuccessorOf: commits andCompleteImportForMax: commitLimit [

	| analyzingCommits i size |
	analyzingCommits := Set new.
	glhImporter withCommitDiffs: true.

	commits do: [ :c |
		GitAnalyzer new
			visitChildCommits: c childCommits
			toStoreThemIn: analyzingCommits
			upto: commitLimit.
		analyzingCommits add: c.
		 ].

	i := 0.
	size := analyzingCommits size.
	analyzingCommits do: [ :c | glhImporter completeImportedCommit: c ].

	^ analyzingCommits
]

{ #category : #accessing }
Metric >> glhImporter: anObject [

	glhImporter := anObject
]

{ #category : #accessing }
Metric >> jiraImporter: anObject [

	jiraImporter := anObject
]

{ #category : #loading }
Metric >> load [
	^self subclassResponsibility
]

{ #category : #accessing }
Metric >> name [

	^ self class name asString
]

{ #category : #accessing }
Metric >> over: anObject [

	over := anObject
]

{ #category : #'utils - date' }
Metric >> readDate: aDateString [
	"date is supposed to the the format mm-dd-yyyy for compatibility with Moose 12"
	
	^ Date readFrom: aDateString pattern: 'mm-dd-yyyy'
]

{ #category : #initialization }
Metric >> setPeriodSince: since until: until [

	period := {
		          (#since -> (self readDate: since)).
		          (#until -> (self readDate: until)) } asDictionary
]

{ #category : #'utils - date' }
Metric >> setupGroupedDate [

	| groupedByDate start end increment overSymbol |
	groupedByDate := OrderedDictionary new.

	increment := 1.
	start := self transformDate: (period at: #since) to: over.
	end := self transformDate: (period at: #until) to: over.

	groupedByDate
		at: start
		ifAbsentPut: [ OrderedCollection new ].

	overSymbol := over name asLowercase asSymbol.
	overSymbol = #date ifTrue: [ over := #day ].
	overSymbol = #month ifTrue: [
		increment := 32.
		over := #day ].


	[ groupedByDate keys last < end ] whileTrue: [
		| index |
		index := groupedByDate keys last
		         + (increment perform: overSymbol).
		index := self transformDate: index to: over.
		groupedByDate
			at: index
			ifAbsentPut: [ OrderedCollection new ] ].


	over = #day ifTrue: [
		groupedByDate := (groupedByDate associations select: [ :date |
			                  | aWeekday |
			                  aWeekday :=  date key weekday.
			                  (aWeekday = #Sunday or: [ aWeekday = #Saturday ])
				                  not ]) asOrderedDictionary ].


	groupedByDate
		at: end
		ifAbsentPut: [ OrderedCollection new ].

	^ groupedByDate
]

{ #category : #'utils - date' }
Metric >> transformDate: date to: aWeekOrMonthOrYear [

	aWeekOrMonthOrYear = Month ifTrue: [ ^ date asDate month asDate ].

	^ (date asDate perform: ('as' , aWeekOrMonthOrYear name) asSymbol)
		  asDate
]
