"
A ReviewedByUserMergeRequestMetricTest is a test class for testing the behavior of ReviewedByUserMergeRequestMetric
"
Class {
	#name : #ReviewedByUserMergeRequestMetricTest,
	#superclass : #TestCase,
	#category : #'GitLabHealth-Model-Analysis-Tests'
}

{ #category : #test }
ReviewedByUserMergeRequestMetricTest >> testCalculate [

	| result glhImporter user mergeRequests user2|
	"Given"
	user := GLHUser new
		        name: 'testUser';
		        contributedProjects:
			        { (GLHProject new repository: GLHRepository new) }.
				user2 := GLHUser new
		        name: 'testUser2';
		        contributedProjects:
			        { (GLHProject new repository: GLHRepository new) }.

	glhImporter := GLPHImporterMock new.
	glhImporter mergeRequests: {
			(GLPHEMergeRequest new
				 author: user;
				 merge_user: user;
				 reviewers: { user };
				 created_at: '09-05-2024:00-00-00' asDateAndTime;
				 merged_at: '09-05-2024:00-00-01' asDateAndTime).
			(GLPHEMergeRequest new
				 author: user;
				merge_user: nil;
				 created_at: '09-05-2024:00-00-00' asDateAndTime;
				 merged_at: '09-05-2024:00-00-01' asDateAndTime) }.


	mergeRequests := ReviewedByUserMergeRequestMetric
		                                   new
		                                   user: user;
		                                   glhImporter: glhImporter;
		                                   setPeriodSince: '09-04-2024'
		                                   until: '09-04-2024';
		                                   over: Week.

	"When"
	result := mergeRequests calculate.

	"Then"
	self assert: result equals: 1
]

{ #category : #test }
ReviewedByUserMergeRequestMetricTest >> testCalculateNoMergeRequests [ 

	| result glhImporter user mergeRequests |
	"Given"
	user := GLHUser new
		        username: 'test';
		        contributedProjects:
			        { (GLHProject new repository: GLHRepository new) }.

	glhImporter := GLPHImporterMock new.
	glhImporter mergeRequests: { }.


	mergeRequests := ReviewedByUserMergeRequestMetric
		                                   new
		                                   user: user;
		                                   glhImporter: glhImporter;
		                                   setPeriodSince: '09-04-2024'
		                                   until: '09-04-2024';
		                                   over: Week.

	"When"
	result := mergeRequests calculate.

	"Then"
	self assert: result equals: 0
]

{ #category : #test }
ReviewedByUserMergeRequestMetricTest >> testCalculateReviewByOther [

	| result glhImporter user mergedMergeRequestWithoutReview user2|
	"Given"
	user := GLHUser new
		        name: 'testUser';
		        contributedProjects:
			        { (GLHProject new repository: GLHRepository new) }.
				user2 := GLHUser new
		        name: 'testUser2';
		        contributedProjects:
			        { (GLHProject new repository: GLHRepository new) }.

	glhImporter := GLPHImporterMock new.
	glhImporter mergeRequests: {
			(GLPHEMergeRequest new
				 author: user;
				 merge_user: user;
				 reviewers: { user2 };
				 created_at: '09-05-2024:00-00-00' asDateAndTime;
				 merged_at: '09-05-2024:00-00-01' asDateAndTime).
			(GLPHEMergeRequest new
				 author: user;
				 merge_user: user2;
				 reviewers: { user2 };
				 created_at: '09-05-2024:00-00-00' asDateAndTime;
				 merged_at: '09-05-2024:00-00-01' asDateAndTime). }.


	mergedMergeRequestWithoutReview := ReviewedByUserMergeRequestMetric 
		                                   new
		                                   user: user;
		                                   glhImporter: glhImporter;
		                                   setPeriodSince: '09-04-2024'
		                                   until: '09-04-2024';
		                                   over: Week.

	"When"
	result := mergedMergeRequestWithoutReview calculate.

	"Then"
	self assert: result equals: 0
]