"
A ReviewedByUserMergeRequestMetricTest is a test class for testing the behavior of ReviewedByUserMergeRequestMetric
"
Class {
	#name : #ReviewedByUserMergeRequestMetricTest,
	#superclass : #UserMetricTest,
	#instVars : [
		'user2'
	],
	#category : #'GitLabHealth-Model-Analysis-Tests'
}

{ #category : #running }
ReviewedByUserMergeRequestMetricTest >> setUp [

	super setUp.

	user2 := GLHUser new
		         name: 'testUser2';
		         contributedProjects:
			         { project1 }.
]

{ #category : #test }
ReviewedByUserMergeRequestMetricTest >> testCalculate [

	| result glhImporter mergeRequests |
	"Given"
	glhImporter := GLPHImporterMock new.
	glhImporter mergeRequests: {
			(GLHMergeRequest new
				 author: user;
				 merge_user: user;
				 reviewers: { user };
				 project: project1;
				 created_at: createdAt ;
				 state: #merged;
				 merged_at: mergedAt ).
			(GLHMergeRequest new
				 author: user;
				 merge_user: user2;
				 reviewers: { user2 };
				 project: project1;
				 state: #merged;
				 created_at: createdAt ;
				 merged_at: mergedAt ) }.


	mergeRequests := ReviewedByUserMergeRequestMetric new
		                 user: user;
		                 glhImporter: glhImporter;
		                 setPeriodSince: since until: until;
		                 over: Week.

	"When"
	result := mergeRequests calculate.

	"Then"
	self assert: result equals: 1
]

{ #category : #test }
ReviewedByUserMergeRequestMetricTest >> testCalculateNoMergeRequests [

	| result glhImporter  mergeRequests |
	"Given"

	glhImporter := GLPHImporterMock new.
	glhImporter mergeRequests: {  }.


	mergeRequests := ReviewedByUserMergeRequestMetric new
		                 user: user;
		                 glhImporter: glhImporter;
		                 setPeriodSince: since until: until;
		                 over: Week.

	"When"
	result := mergeRequests calculate.

	"Then"
	self assert: result equals: 0
]

{ #category : #tests }
ReviewedByUserMergeRequestMetricTest >> testCalculateReviewButNotCreated [

	| result glhImporter  mergedMergeRequestWithoutReview  |
	"Given"


	glhImporter := GLPHImporterMock new.
	glhImporter mergeRequests: { (GLHMergeRequest new
			 author: user2;
			 merge_user: user2;
			 reviewers: { user };
			 project: project1;
			 state: #merged;
			 created_at: createdAt ;
			 merged_at: mergedAt ) }.


	mergedMergeRequestWithoutReview := ReviewedByUserMergeRequestMetric
		                                   new
		                                   user: user;
		                                   glhImporter: glhImporter;
		                                   setPeriodSince: since
		                                   until: until;
		                                   over: Week.

	"When"
	result := mergedMergeRequestWithoutReview calculate.

	"Then"
	self assert: result equals: 1
]

{ #category : #test }
ReviewedByUserMergeRequestMetricTest >> testCalculateReviewByOther [

	| result glhImporter  mergedMergeRequestWithoutReview  |
	"Given"


	glhImporter := GLPHImporterMock new.
	glhImporter mergeRequests: {
			(GLHMergeRequest new
				 author: user;
				 project: project1;
				 merge_user: user;
				 reviewers: { user2 };
				 created_at: createdAt ;
				 merged_at: mergedAt ).
			(GLHMergeRequest new
				 author: user;
				 merge_user: user2;
				 project: project1;
				 reviewers: { user2 };
				 created_at: createdAt ;
				 merged_at: mergedAt ) }.


	mergedMergeRequestWithoutReview := ReviewedByUserMergeRequestMetric
		                                   new
		                                   user: user;
		                                   glhImporter: glhImporter;
		                                   setPeriodSince: since 
		                                   until: until ;
		                                   over: Week.

	"When"
	result := mergedMergeRequestWithoutReview calculate.

	"Then"
	self assert: result equals: 0
]
