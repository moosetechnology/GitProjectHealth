"
A PendingMergeRequestMetricTest is a test class for testing the behavior of PendingMergeRequestMetric
"
Class {
	#name : #PendingMergeRequestMetricTest,
	#superclass : #TestCase,
	#category : 'GitLabHealth-Model-Analysis-Tests'
}

{ #category : #test }
PendingMergeRequestMetricTest >> testCalculate [

	| result glhImporter user mergedMergeRequestPending|
	"Given"
	user := GLHUser new
		        username: 'test';
		        contributedProjects:
			        { (GLHProject new repository: GLHRepository new) }.

	glhImporter := GLPHImporterMock new.
	glhImporter mergeRequests: {
			(GLHMergeRequest new
				 author: user;
				 merge_user: user;
				 created_at: '09-05-2024:00-00-00' asDateAndTime;
				 state: 'opened'; 
				 merged_at: nil).
			 }.


	mergedMergeRequestPending := PendingMergeRequestMetric 
		                                   new
		                                   user: user;
		                                   glhImporter: glhImporter;
		                                   setPeriodSince: '09-01-2024'
		                                   until: '09-07-2024';
		                                   over: Week.

	"When"
	result := mergedMergeRequestPending calculate.

	"Then"
	self assert: result equals: 1
]

{ #category : #test }
PendingMergeRequestMetricTest >> testCalculate1Pending1Closed [

	| result glhImporter user mergedMergeRequestPending |
	"Given"
	user := GLHUser new
		        username: 'test';
		        contributedProjects:
			        { (GLHProject new repository: GLHRepository new) }.

	glhImporter := GLPHImporterMock new.
	glhImporter mergeRequests: {
			(GLHMergeRequest new
				 author: user;
				 created_at: '09-05-2024:00-00-00' asDateAndTime;
				 state: 'opened';
				 merged_at: nil).
			(GLHMergeRequest new
				 author: user;
				 created_at: '09-01-2024:00-00-00' asDateAndTime;
				 state: 'closed';
				 merged_at: '09-02-2024:00-00-00' asDateAndTime) }.


	mergedMergeRequestPending := PendingMergeRequestMetric new
		                             user: user;
		                             glhImporter: glhImporter;
		                             setPeriodSince: '09-01-2024'
		                             until: '09-07-2024';
		                             over: Week.

	"When"
	result := mergedMergeRequestPending calculate.

	"Then"
	self assert: result equals: 1
]

{ #category : #test }
PendingMergeRequestMetricTest >> testCalculate1PendingByUser [

	| result glhImporter user mergedMergeRequestPending user2 |
	"Given"
	user := GLHUser new
		        username: 'user';
		        name: 'user';
		        contributedProjects:
			        { (GLHProject new repository: GLHRepository new) }.

	user2 := GLHUser new
		         username: 'user2';
		         name: 'user2';
		         contributedProjects:
			         { (GLHProject new repository: GLHRepository new) }.

	glhImporter := GLPHImporterMock new.
	glhImporter mergeRequests: {
			(GLHMergeRequest new
				 author: user;
				 created_at: '09-05-2024:00-00-00' asDateAndTime;
				 state: 'opened';
				 merged_at: nil).
			(GLHMergeRequest new
				 author: user2;
				 created_at: '09-01-2024:00-00-00' asDateAndTime;
				 state: 'opened';
				 merged_at: nil) }.

	mergedMergeRequestPending := PendingMergeRequestMetric new
		                             user: user;
		                             glhImporter: glhImporter;
		                             setPeriodSince: '09-01-2024'
		                             until: '09-07-2024';
		                             over: Week.

	"When"
	result := mergedMergeRequestPending calculate.

	"Then"
	self assert: result equals: 1
]

{ #category : #test }
PendingMergeRequestMetricTest >> testCalculate2Pending [

	| result glhImporter user mergedMergeRequestPending user2 |
	"Given"
	user := GLHUser new
		        username: 'user';
		        name: 'user';
		        contributedProjects:
			        { (GLHProject new repository: GLHRepository new) }.

	user2 := GLHUser new
		         username: 'user2';
		         name: 'user2';
		         contributedProjects:
			         { (GLHProject new repository: GLHRepository new) }.

	glhImporter := GLPHImporterMock new.
	glhImporter mergeRequests: {
			(GLHMergeRequest new
				 author: user;
				 created_at: '09-05-2024:00-00-00' asDateAndTime;
				 state: 'opened';
				 merged_at: nil).
			(GLHMergeRequest new
				 author: user;
				 created_at: '09-02-2024:00-00-00' asDateAndTime;
				 state: 'opened';
				 merged_at: nil) }.

	mergedMergeRequestPending := PendingMergeRequestMetric new
		                             user: user;
		                             glhImporter: glhImporter;
		                             setPeriodSince: '09-01-2024'
		                             until: '09-07-2024';
		                             over: Week.

	"When"
	result := mergedMergeRequestPending calculate.

	"Then"
	self assert: result equals: 2
]
