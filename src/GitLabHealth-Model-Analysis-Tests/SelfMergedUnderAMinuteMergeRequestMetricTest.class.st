"
A MergedMergeRequestWithoutReviewMetricTest is a test class for testing the behavior of MergedMergeRequestWithoutReviewMetric
"
Class {
	#name : #SelfMergedUnderAMinuteMergeRequestMetricTest,
	#superclass : #TestCase,
	#category : 'GitLabHealth-Model-Analysis-Tests'
}

{ #category : #tests }
SelfMergedUnderAMinuteMergeRequestMetricTest >> testCalculate [

	| result glhImporter user mergedMergeRequestWithoutReview |
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
				 reviewers: { user };
				 created_at: (DateAndTime year: 2024 month: 09 day: 05 hour: 00 minute: 0 second: 0);
				 merged_at: (DateAndTime year: 2024 month: 09 day: 05 hour: 00 minute: 0 second: 1)).
			(GLHMergeRequest new
				 author: user;
				 merge_user: nil;
				 created_at: (DateAndTime year: 2024 month: 09 day: 05 hour: 00 minute: 0 second: 0);
				 merged_at: (DateAndTime year: 2024 month: 09 day: 05 hour: 00 minute: 0 second: 1)) }.


	mergedMergeRequestWithoutReview := SelfMergedUnderAMinuteMergeRequestMetric
		                                   new
		                                   user: user;
		                                   glhImporter: glhImporter;
		                                   setPeriodSince: '09-04-2024'
		                                   until: '09-04-2024';
		                                   over: Week.

	"When"
	result := mergedMergeRequestWithoutReview calculate.

	"Then"
	self assert: result equals: 1
]

{ #category : #tests }
SelfMergedUnderAMinuteMergeRequestMetricTest >> testCalculateMergeButNotCreated [

	| result glhImporter user mergedMergeRequestWithoutReview user2 |
	"Given"
	user := GLHUser new
		        username: 'test';
		        contributedProjects:
			        { (GLHProject new repository: GLHRepository new) }.

	user2 := GLHUser new
		         name: 'testUser2';
		         contributedProjects:
			         { (GLHProject new repository: GLHRepository new) }.

	glhImporter := GLPHImporterMock new.
	glhImporter mergeRequests: {
			(GLHMergeRequest new
				 author: user2;
				 merge_user: user;
				 reviewers: { user };
				 created_at: (DateAndTime year: 2024 month: 09 day: 05 hour: 00 minute: 0 second: 0);
				 merged_at: (DateAndTime year: 2024 month: 09 day: 05 hour: 00 minute: 0 second: 1)).
			(GLHMergeRequest new
				 author: user;
				 merge_user: nil;
				 created_at: (DateAndTime year: 2024 month: 09 day: 05 hour: 00 minute: 0 second: 0);
				 merged_at: (DateAndTime year: 2024 month: 09 day: 05 hour: 00 minute: 0 second: 1)) }.


	mergedMergeRequestWithoutReview := SelfMergedUnderAMinuteMergeRequestMetric
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

{ #category : #tests }
SelfMergedUnderAMinuteMergeRequestMetricTest >> testCalculateNoMergeRequests [

	| result glhImporter user mergedMergeRequestWithoutReview |
	"Given"
	user := GLHUser new
		        username: 'test';
		        contributedProjects:
			        { (GLHProject new repository: GLHRepository new) }.

	glhImporter := GLPHImporterMock new.

	mergedMergeRequestWithoutReview := SelfMergedUnderAMinuteMergeRequestMetric
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
