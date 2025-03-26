"
A ClosedMergeFrequencyProjectMetricTest is a test class for testing the behavior of ClosedMergeFrequencyProjectMetric
"
Class {
	#name : #ClosedMergeRequestProjectMetricTest,
	#superclass : #ProjectMetricTest,
	#category : #'GitLabHealth-Model-Analysis-Tests'
}

{ #category : #tests }
ClosedMergeRequestProjectMetricTest >> testCalculate [

	| glhImporter result mergeFrequency |
	"Given"
	
	glhImporter := GLPHImporterMock new.
	glhImporter mergeRequests: { (GLHMergeRequest new
			 project: project;
			 created_at: createdAt;
			 closed_at: closedAt ;
			 state: 'closed') }.

	mergeFrequency := ClosedMergeRequestProjectMetric new
		                  project: project;
		                  glhImporter: glhImporter;
		                  setPeriodSince: since until: until;
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
				 created_at: createdAt ;
				 closed_at: closedAt ;
				 state: 'closed').
		}.

	mergeFrequency := ClosedMergeRequestProjectMetric new
		                  project: project1;
		                  glhImporter: glhImporter;
		                  setPeriodSince: since until: until;
		                  over: Week.

	"When"
	result := mergeFrequency calculate.

	"Then"
	self assert: result equals: 0
]
