"
A MergeFrequencyProjectMetricTest is a test class for testing the behavior of MergeFrequencyProjectMetric
"
Class {
	#name : #CreatedMergeRequestProjectMetricTest,
	#superclass : #ProjectMetricTest,
	#category : #'GitLabHealth-Model-Analysis-Tests'
}

{ #category : #tests }
CreatedMergeRequestProjectMetricTest >> testCalculate [

	| glhImporter result mergeFrequency |
	"Given"
	glhImporter := GLPHImporterMock new.
	glhImporter mergeRequests: { (GLHMergeRequest new
			 created_at: '2024-09-04T10:24:11.803+02:00' asDateAndTime;
			 state: 'opened';
			 project: project) }.


	mergeFrequency := CreatedMergeRequestProjectMetric new
		                  project: project;
		                  glhImporter: glhImporter;
		                  setPeriodSince: '2024-09-04' until: '2024-09-05';
		                  over: Week.

	"When"
	result := mergeFrequency calculate.

	"Then"
	self assert: result equals: 1
]
