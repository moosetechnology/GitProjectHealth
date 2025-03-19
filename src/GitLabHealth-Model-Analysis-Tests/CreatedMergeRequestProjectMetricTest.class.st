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
			 created_at: createdAt ;
			 state: 'opened';
			 project: project) }.


	mergeFrequency := CreatedMergeRequestProjectMetric new
		                  project: project;
		                  glhImporter: glhImporter;
		                  setPeriodSince: since until: until;
		                  over: Week.

	"When"
	result := mergeFrequency calculate.

	"Then"
	self assert: result equals: 1
]
