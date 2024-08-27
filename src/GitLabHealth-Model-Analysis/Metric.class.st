Class {
	#name : #Metric,
	#superclass : #Object,
	#instVars : [
		'name',
		'description',
		'period',
		'over',
		'glhImporter'
	],
	#category : #'GitLabHealth-Model-Analysis'
}

{ #category : #'as yet unclassified' }
Metric >> calculate [

	^self subclassResponsibility
]

{ #category : #accessing }
Metric >> description [

	^ self subclassResponsibility
]

{ #category : #accessing }
Metric >> glhImporter: anObject [

	glhImporter := anObject
]

{ #category : #loading }
Metric >> load [
	^self subclassResponsibility
]

{ #category : #accessing }
Metric >> name [

	^ self subclassResponsibility
]

{ #category : #accessing }
Metric >> over: anObject [

	over := anObject
]

{ #category : #initialization }
Metric >> setPeriodSince: since until: until [

	period :=  {
			(#since -> since asDate).
			(#until -> until asDate) } asDictionary
]

{ #category : #'as yet unclassified' }
Metric >> setupGroupedDate [

	| groupedByDate start end increment overSymbol |
	groupedByDate := OrderedDictionary new.

	increment := 1.
	start := self transformDate: (period at: #since) to: over.
	end := self transformDate: (period at: #until) to: over.

	groupedByDate
		at: start printString
		ifAbsentPut: [ OrderedCollection new ].

	overSymbol := over name asLowercase asSymbol.
	overSymbol = #date ifTrue: [ over := #day ].
	overSymbol = #month ifTrue: [
		increment := 32.
		over := #day ].


	[ groupedByDate keys last asDateAndTime < end ] whileTrue: [
		| index |
		index := groupedByDate keys last asDateAndTime
		         + (increment perform: overSymbol).
		index := self transformDate: index to: over.
		groupedByDate
			at: index printString
			ifAbsentPut: [ OrderedCollection new ] ].


	over = #day ifTrue: [
		groupedByDate := (groupedByDate associations select: [ :date |
			                  | aWeekday |
			                  aWeekday := date key asDate weekday.
			                  (aWeekday = #Sunday or: [ aWeekday = #Saturday ])
				                  not ]) asOrderedDictionary ].


	groupedByDate
		at: end printString
		ifAbsentPut: [ OrderedCollection new ].

	^ groupedByDate
]

{ #category : #'as yet unclassified' }
Metric >> transformDate: date to: aWeekOrMonthOrYear [

	aWeekOrMonthOrYear = Month ifTrue: [ ^ date asDate month asDate ].

	^ (date asDate perform: ('as' , aWeekOrMonthOrYear name) asSymbol)
		  asDate
]