"
A MergedMergeRequestMetricTest is a test class for testing the behavior of MergedMergeRequestMetric
"
Class {
	#name : #MergedMergeRequestMetricTest,
	#superclass : #TestCase,
	#category : #'GitLabHealth-Model-Analysis-Tests'
}

{ #category : #tests }
MergedMergeRequestMetricTest >> testCalculate [

	| result glhImporter user mergedMergeRequest |
	"Given"
	user := GLHUser new
		        username: 'test';
		        contributedProjects:
			        { (GLHProject new repository: GLHRepository new) }.

	glhImporter := GLPHImporterMock new.
	glhImporter mergeRequests: { (GLPHEMergeRequest new
			 author: user;
			 created_at: '09-05-2024';
			 merged_at: '09-05-2024')
			}.


	mergedMergeRequest := MergedMergeRequestMetric new
		                      user: user;
		                      glhImporter: glhImporter;
		                      setPeriodSince: '09-01-2024'
		                      until: '09-07-2024';
		                      over: Week.

	"When"
	result := mergedMergeRequest calculate.

	"Then"
	self assert: result equals: 1
]

{ #category : #tests }
MergedMergeRequestMetricTest >> testCalculate1MRInPeriod1Outside [

	| result glhImporter user mergedMergeRequest |
	"Given"
	user := GLHUser new
		        username: 'test';
		        contributedProjects:
			        { (GLHProject new repository: GLHRepository new) }.

	glhImporter := GLPHImporterMock new.
	glhImporter mergeRequests: { 
		"open and merge during the same week"
	(GLPHEMergeRequest new
			 author: user;
			 created_at: '09-05-2024';
			 merged_at: '09-05-2024')
			"open but merged anotherWeek"
			.(GLPHEMergeRequest new
			 author: user;
			 created_at: '09-05-2024';
			 merged_at: '09-10-2024')}.


	mergedMergeRequest := MergedMergeRequestMetric new
		                      user: user;
		                      glhImporter: glhImporter;
		                      setPeriodSince: '09-01-2024'
		                      until: '09-07-2024';
		                      over: Week.

	"When"
	result := mergedMergeRequest calculate.

	"Then"
	self assert: result equals: 1
]

{ #category : #tests }
MergedMergeRequestMetricTest >> testCalculate1MROpenedButNotMerged [

	| result glhImporter user mergedMergeRequest |
	"Given"
	user := GLHUser new
		        username: 'test';
		        contributedProjects:
			        { (GLHProject new repository: GLHRepository new) }.

	glhImporter := GLPHImporterMock new.
	glhImporter mergeRequests: { (GLPHEMergeRequest new
			 author: user;
			 created_at: '09-05-2024';
			 merged_at: '09-05-2024')
			.(GLPHEMergeRequest new
			 author: user;
			 created_at: '09-05-2024';
			 merged_at: nil)}.


	mergedMergeRequest := MergedMergeRequestMetric new
		                      user: user;
		                      glhImporter: glhImporter;
		                      setPeriodSince: '09-01-2024'
		                      until: '09-07-2024';
		                      over: Week.

	"When"
	result := mergedMergeRequest calculate.

	"Then"
	self assert: result equals: 1
]

{ #category : #tests }
MergedMergeRequestMetricTest >> testCalculateNoMergeRequests [ 

	| result glhImporter user mergedMergeRequest |
	"Given"
	user := GLHUser new
		        username: 'test';
		        contributedProjects:
			        { (GLHProject new repository: GLHRepository new) }.

	glhImporter := GLPHImporterMock new.


	mergedMergeRequest := MergedMergeRequestMetric new
		                      user: user;
		                      glhImporter: glhImporter;
		                      setPeriodSince: '09-04-2024'
		                      until: '09-04-2024';
		                      over: Week.

	"When"
	result := mergedMergeRequest calculate.

	"Then"
	self assert: result equals: 0
]
