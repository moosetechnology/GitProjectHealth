"
A ClosedMergeRequestMetricTest is a test class for testing the behavior of ClosedMergeRequestMetric
"
Class {
	#name : #ClosedMergeRequestMetricTest,
	#superclass : #TestCase,
	#category : #'GitLabHealth-Model-Analysis-Tests'
}

{ #category : #tests }
ClosedMergeRequestMetricTest >> testCalculate [

	| result glhImporter user closedMergeRequestMetric |
	"Given"
	user := GLHUser new
		        username: 'test';
		        contributedProjects:
			        { (GLHProject new repository: GLHRepository new) }.

	glhImporter := GLPHImporterMock new.
	glhImporter mergeRequests: {
			(GLPHEMergeRequest new
				 author: user;
				 created_at: '09-05-2024';
				 merged_at: '09-05-2024';
				 state: 'closed').
			(GLPHEMergeRequest new
				 author: user;
				 created_at: '09-05-2024';
				 merged_at: nil;
				 state: 'closed') }.


	closedMergeRequestMetric := ClosedMergeRequestMetric new
		                            user: user;
		                            glhImporter: glhImporter;
		                            setPeriodSince: '09-04-2024'
		                            until: '09-04-2024';
		                            over: Week.

	"When"
	result := closedMergeRequestMetric calculate.

	"Then"
	self assert: result equals: 1
]

{ #category : #tests }
ClosedMergeRequestMetricTest >> testCalculateNoMergeRequests [

	| result glhImporter user closedMergeRequestMetric |
	"Given"
	user := GLHUser new
		        username: 'test';
		        contributedProjects:
			        { (GLHProject new repository: GLHRepository new) }.

	glhImporter := GLPHImporterMock new.

	closedMergeRequestMetric := ClosedMergeRequestMetric new
		                            user: user;
		                            glhImporter: glhImporter;
		                            setPeriodSince: '09-04-2024'
		                            until: '09-04-2024';
		                            over: Week.

	"When"
	result := closedMergeRequestMetric calculate.

	"Then"
	self assert: result equals: 0
]
