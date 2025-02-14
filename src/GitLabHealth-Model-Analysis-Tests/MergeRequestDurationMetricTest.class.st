"
A MergeRequestDurationMetricTest is a test class for testing the behavior of MergeRequestDurationMetric
"
Class {
	#name : #MergeRequestDurationMetricTest,
	#superclass : #TestCase,
	#category : #'GitLabHealth-Model-Analysis-Tests'
}

{ #category : #tests }
MergeRequestDurationMetricTest >> testCalculate [

	| result glhImporter user mergeRequestDuration |
	"Given"
	user := GLHUser new
		        username: 'test';
		        contributedProjects:
			        { (GLHProject new repository: GLHRepository new) }.

	glhImporter := GLPHImporterMock new.
	glhImporter mergeRequests: {
			(GLHMergeRequest new
				 author: user;
				 created_at: (DateAndTime year: 2024 month: 09 day: 05 hour: 00 minute: 0 second: 0);
				 merged_at: (DateAndTime year: 2024 month: 09 day: 05 hour: 10 minute: 0 second: 0)).
			(GLHMergeRequest new
				 author: user;
				 created_at: '09-05-2024' asDate;
				 merged_at: nil) }.


	mergeRequestDuration := MergeRequestDurationMetric new
		                        user: user;
		                        glhImporter: glhImporter;
		                        setPeriodSince: '09-04-2024'
		                        until: '09-04-2024';
		                        over: Week.

	"When"
	result := mergeRequestDuration calculate.

	"Then"
	self assert: result equals: (10 * 60 * 60)
]

{ #category : #tests }
MergeRequestDurationMetricTest >> testCalculateNoMergeRequests [

	| result glhImporter user mergeRequestDuration |
	"Given"
	user := GLHUser new
		        username: 'test';
		        contributedProjects:
			        { (GLHProject new repository: GLHRepository new) }.

	glhImporter := GLPHImporterMock new.

	mergeRequestDuration := MergeRequestDurationMetric new
		                        user: user;
		                        glhImporter: glhImporter;
		                        setPeriodSince: '09-04-2024'
		                        until: '09-04-2024';
		                        over: Week.

	"When"
	result := mergeRequestDuration calculate.

	"Then"
	self assert: result equals: nil
]
