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
				created_at: createdAt ;
				merged_at: mergedAt ;
			 state: #merged) }.


	mergeFrequency := MergedMergeRequestProjectMetric new
		                  project: project;
		                  glhImporter: glhImporter;
		                  setPeriodSince: since until: until;
		                  over: Week.

	"When"
	result := mergeFrequency calculate.

	"Then"
	self assert: result equals: 1
]
