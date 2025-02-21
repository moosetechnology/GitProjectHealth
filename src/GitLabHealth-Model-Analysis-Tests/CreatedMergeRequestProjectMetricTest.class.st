"
A MergeFrequencyProjectMetricTest is a test class for testing the behavior of MergeFrequencyProjectMetric
"
Class {
	#name : #CreatedMergeRequestProjectMetricTest,
	#superclass : #TestCase,
	#category : #'GitLabHealth-Model-Analysis-Tests'
}

{ #category : #tests }
CreatedMergeRequestProjectMetricTest >> testCalculate [

	| glhImporter result mergeFrequency project |
	"Given"
	project := GLHProject new
		           name: 'test';
		           repository: GLHRepository new.
	glhImporter := GLPHImporterMock new.
	glhImporter mergeRequests:
		{ (GLHMergeRequest new created_at: '2024-04-10') }.


	mergeFrequency := CreatedMergeRequestProjectMetric new
		                  project: project;
		                  glhImporter: glhImporter;
		                  setPeriodSince: '2024-04-09' until: '2024-04-11';
		                  over: Week.

	"When"
	result := mergeFrequency calculate.

	"Then"
	self assert: result equals: 1
]
