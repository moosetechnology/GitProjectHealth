"
A MetricTest is a test class for testing the behavior of Metric
"
Class {
	#name : #MetricTest,
	#superclass : #TestCase,
	#category : #'GitLabHealth-Model-Analysis-Tests'
}

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
