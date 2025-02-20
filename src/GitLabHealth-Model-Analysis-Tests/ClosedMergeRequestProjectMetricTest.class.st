"
A ClosedMergeFrequencyProjectMetricTest is a test class for testing the behavior of ClosedMergeFrequencyProjectMetric
"
Class {
	#name : #ClosedMergeRequestProjectMetricTest,
	#superclass : #TestCase,
	#category : #'GitLabHealth-Model-Analysis-Tests'
}

{ #category : #tests }
ClosedMergeRequestProjectMetricTest >> testCalculate [

	| glhImporter result mergeFrequency project |
	"Given"
	project := GLHProject new
		           name: 'test';
		           repository: GLHRepository new.
	glhImporter := GLPHImporterMock new.
	glhImporter mergeRequests:
		{ (GLHMergeRequest new state:#closed ; closed_at: '04-10-2024') }.

	mergeFrequency := ClosedMergeRequestProjectMetric new
		                  project: project;
		                  glhImporter: glhImporter;
		                  setPeriodSince: '04-09-2024' until: '04-11-2024';
		                  over: Week.

	"When"
	result := mergeFrequency calculate.

	"Then"
	self assert: result equals: 1
]
