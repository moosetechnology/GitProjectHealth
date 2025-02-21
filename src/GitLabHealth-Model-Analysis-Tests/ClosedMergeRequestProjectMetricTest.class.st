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
		{
			(GLHMergeRequest new
				 project: project;
				 created_at: '2024-09-04T10:24:11.803+02:00' asDateAndTime;
				 closed_at: '2024-09-04T11:24:11.803+02:00' asDateAndTime;
				 state: 'closed').
		}.

	mergeFrequency := ClosedMergeRequestProjectMetric new
		                  project: project;
		                  glhImporter: glhImporter;
		                  setPeriodSince: '2024-09-04' until: '2024-09-04';
		                  over: Week.

	"When"
	result := mergeFrequency calculate.

	"Then"
	self assert: result equals: 1
]

{ #category : #tests }
ClosedMergeRequestProjectMetricTest >> testCalculate1MRNotInProject [

	| glhImporter result mergeFrequency project1 project2 |
	"Given"
	project1 := GLHProject new
		           name: 'project1';
		           repository: GLHRepository new.
		
	
	project2 := 	GLHProject new
		           name: 'project2';
		           repository: GLHRepository new.
	
	glhImporter := GLPHImporterMock new.
	glhImporter mergeRequests:
		{
			(GLHMergeRequest new
				 project: project2;
				 created_at: '2024-09-04T10:24:11.803+02:00' asDateAndTime;
				 closed_at: '2024-09-04T11:24:11.803+02:00' asDateAndTime;
				 state: 'closed').
		}.

	mergeFrequency := ClosedMergeRequestProjectMetric new
		                  project: project1;
		                  glhImporter: glhImporter;
		                  setPeriodSince: '2024-09-04' until: '2024-09-04';
		                  over: Week.

	"When"
	result := mergeFrequency calculate.

	"Then"
	self assert: result equals: 0
]
