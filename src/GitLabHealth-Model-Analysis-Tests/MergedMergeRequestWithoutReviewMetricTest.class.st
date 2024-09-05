"
A MergedMergeRequestWithoutReviewMetricTest is a test class for testing the behavior of MergedMergeRequestWithoutReviewMetric
"
Class {
	#name : #MergedMergeRequestWithoutReviewMetricTest,
	#superclass : #TestCase,
	#category : #'GitLabHealth-Model-Analysis-Tests'
}

{ #category : #tests }
MergedMergeRequestWithoutReviewMetricTest >> testCalculate [

	| result glhImporter user mergedMergeRequestWithoutReview |
	"Given"
	user := GLHUser new
		        username: 'test';
		        contributedProjects:
			        { (GLHProject new repository: GLHRepository new) }.

	glhImporter := GLPHImporterMock new.
	glhImporter mergeRequests: {
			(GLPHEMergeRequest new
				 author: user;
				 merge_user: user;
				 created_at: '09-05-2024:00-00-00' asDateAndTime;
				 merged_at: '09-05-2024:00-00-01' asDateAndTime).
			(GLPHEMergeRequest new
				 author: user;
				merge_user: nil;
				 created_at: '09-05-2024:00-00-00' asDateAndTime;
				 merged_at: '09-05-2024:00-00-01' asDateAndTime) }.


	mergedMergeRequestWithoutReview := MergedMergeRequestWithoutReviewMetric
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
MergedMergeRequestWithoutReviewMetricTest >> testCalculateNoMergeRequests [

	| result glhImporter user mergedMergeRequestWithoutReview |
	"Given"
	user := GLHUser new
		        username: 'test';
		        contributedProjects:
			        { (GLHProject new repository: GLHRepository new) }.

	glhImporter := GLPHImporterMock new.

	mergedMergeRequestWithoutReview := MergedMergeRequestWithoutReviewMetric
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
