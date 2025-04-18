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
	createdAt := '2024-09-04T10:24:11.803+02:00' asDateAndTime.
	closedAt := '2024-09-04T11:24:11.803+02:00' asDateAndTime.
	mergedAt := '2024-09-04T11:24:11.803+02:00' asDateAndTime.
	updatedAt := '2024-09-04T11:24:11.803+02:00' asDateAndTime.

	since := '2024-09-04'.
	until := '2024-09-05'
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
