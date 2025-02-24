"
A MergedMergeRequestWithoutReviewMetricTest is a test class for testing the behavior of MergedMergeRequestWithoutReviewMetric
"
Class {
	#name : #SelfMergedUnderAMinuteMergeRequestMetricTest,
	#superclass : #UserMetricTest,
	#instVars : [
		'user2'
	],
	#category : #'GitLabHealth-Model-Analysis-Tests'
}

{ #category : #running }
SelfMergedUnderAMinuteMergeRequestMetricTest >> setUp [

	super setUp.

	user2 := GLHUser new
		         name: 'user2';
		         contributedProjects:
			         { project1 }.
]

{ #category : #tests }
SelfMergedUnderAMinuteMergeRequestMetricTest >> testCalculate [

	| result glhImporter mergedMergeRequestWithoutReview |
	"Given"
	glhImporter := GLPHImporterMock new.
	glhImporter mergeRequests: {
			(GLHMergeRequest new
				 author: user;
				 merge_user: user;
				 project: project1;
				 reviewers: { user };
				 created_at: createdAt;
				 state: #merged;
				 merged_at: createdAt + 30 seconds).
			(GLHMergeRequest new
				 author: user;
				 reviewers: { user };
				 merge_user: user;
				 project: project1;
				 state: #merged;
				 created_at: createdAt;
				 merged_at: createdAt + 2 minutes) }.


	mergedMergeRequestWithoutReview := SelfMergedUnderAMinuteMergeRequestMetric
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

{ #category : #tests }
SelfMergedUnderAMinuteMergeRequestMetricTest >> testCalculateMergeButNotCreated [

	| result glhImporter  mergedMergeRequestWithoutReview  |
	"Given"

	glhImporter := GLPHImporterMock new.
	glhImporter mergeRequests: {
			(GLHMergeRequest new
				 author: user2;
				 merge_user: user;
				 project: project1;
				 state: #merged;
				 reviewers: { user };
				 created_at: createdAt ;
				 merged_at: mergedAt ).
			(GLHMergeRequest new
				 author: user2;
				 merge_user: user;
				 project: project1;
				 state: #merged;
				 created_at: createdAt ;
				 merged_at: mergedAt ) 
			}.


	mergedMergeRequestWithoutReview := SelfMergedUnderAMinuteMergeRequestMetric
		                                   new
		                                   user: user;
		                                   glhImporter: glhImporter;
		                                   setPeriodSince: since
		                                   until: until;
		                                   over: Week.

	"When"
	result := mergedMergeRequestWithoutReview calculate.

	"Then"
	self assert: result equals: 0
]

{ #category : #tests }
SelfMergedUnderAMinuteMergeRequestMetricTest >> testCalculateNoMergeRequests [

	| result glhImporter mergedMergeRequestWithoutReview |
	"Given"

	glhImporter := GLPHImporterMock new.

	mergedMergeRequestWithoutReview := SelfMergedUnderAMinuteMergeRequestMetric
		                                   new
		                                   user: user;
		                                   glhImporter: glhImporter;
		                                   setPeriodSince: since
		                                   until: until;
		                                   over: Week.

	"When"
	result := mergedMergeRequestWithoutReview calculate.

	"Then"
	self assert: result equals: 0
]
