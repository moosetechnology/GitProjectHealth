"
A MetricTest is a test class for testing the behavior of Metric
"
Class {
	#name : #MetricTest,
	#superclass : #TestCase,
	#instVars : [
		'createdAt',
		'mergedAt',
		'closedAt',
		'since',
		'until',
		'updatedAt'
	],
	#category : #'GitLabHealth-Model-Analysis-Tests'
}

{ #category : #running }
MetricTest >> setUp [

	super setUp.

	"Put here a common initialization logic for tests"
	createdAt := '2024-09-04T10:24:11.803' asDateAndTime.
	closedAt := '2024-09-04T11:24:11.803' asDateAndTime.
	mergedAt := '2024-09-04T11:24:11.803' asDateAndTime.
	updatedAt := '2024-09-04T11:24:11.803' asDateAndTime.
	"mm-dd-yyyy"
	since := '09-04-2024'.
	until := '09-05-2024'
]

{ #category : #tests }
MetricTest >> testName [

	"Given"
	| projectMetric name |
	projectMetric := ProjectMetric new.
	
	"When"
	name := projectMetric name.
	
	"Then"
	self assert: name equals: 'ProjectMetric'.
]

{ #category : #tests }
MetricTest >> testTransformDateTo [

	| metric startingDate aWeekDateAndTime |
	metric := Metric new.
	aWeekDateAndTime := '2024-09-04T11:24:11.803+02:00' asDateAndTime.

	startingDate := Date starting:
		                '2024-09-01T00:00:00.000+00:00' asDateAndTime.

	self
		assert: (metric transformDate: aWeekDateAndTime to: Week)
		equals: startingDate
]

{ #category : #tests }
MetricTest >> testTransformDateToMonth [

	| metric startingDate aWeekDateAndTime |
	metric := Metric new.
	aWeekDateAndTime := '2024-09-17T00:00:00.000+00:00' asDateAndTime.

	startingDate := Date starting:
		                '2024-09-01T00:00:00.000+00:00' asDateAndTime.

	self
		assert: (metric transformDate: aWeekDateAndTime to: Month)
		equals: startingDate
]

{ #category : #tests }
MetricTest >> testTransformDateToSameDate [

	| metric startingDate aWeekDateAndTime |
	metric := Metric new.
	aWeekDateAndTime := '2024-09-01T00:00:00.000+00:00' asDateAndTime.

	startingDate := Date starting:
		                '2024-09-01T00:00:00.000+00:00' asDateAndTime.

	self
		assert: (metric transformDate: aWeekDateAndTime to: Week)
		equals: startingDate
]

{ #category : #tests }
MetricTest >> testTransformDateToSameDateWithOffset [

	| metric startingDate aWeekDateAndTime |
	metric := Metric new.
	aWeekDateAndTime := '2024-09-01T00:00:00.000+02:00' asDateAndTime.

	startingDate := Date starting:
		                '2024-09-01T00:00:00.000+00:00' asDateAndTime.

	self
		assert: (metric transformDate: aWeekDateAndTime to: Week)
		equals: startingDate
]

{ #category : #tests }
MetricTest >> testTransformDateToWithDate [

	| metric startingDate aWeekDateAndTime |
	metric := Metric new.
	aWeekDateAndTime := Date starting: '2024-09-04T11:24:11.803+02:00' asDateAndTime.

	startingDate := Date starting:
		                '2024-09-01T00:00:00.000+00:00' asDateAndTime.

	self
		assert: (metric transformDate: aWeekDateAndTime to: Week)
		equals: startingDate
]
