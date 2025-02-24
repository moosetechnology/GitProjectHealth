"
A MergedMergeFrequencyProjectMetricTest is a test class for testing the behavior of MergedMergeFrequencyProjectMetric
"
Class {
	#name : #MergedMergeRequestProjectMetricTest,
	#superclass : #ProjectMetricTest,
	#category : #'GitLabHealth-Model-Analysis-Tests'
}

{ #category : #tests }
MergedMergeRequestProjectMetricTest >> testCalculate [

	| glhImporter result mergeFrequency |
	"Given"
	glhImporter := GLPHImporterMock new.


	glhImporter mergeRequests: { (GLHMergeRequest new
				project: project;
				created_at: '2024-09-04T10:24:11.803+02:00' asDateAndTime;
				merged_at: '2024-09-04T11:24:11.803+02:00' asDateAndTime;
			 state: #merged) }.


	mergeFrequency := MergedMergeRequestProjectMetric new
		                  project: project;
		                  glhImporter: glhImporter;
		                  setPeriodSince: '2024-09-04' until: '2024-09-05';
		                  over: Week.

	"When"
	result := mergeFrequency calculate.

	"Then"
	self assert: result equals: 1
]
