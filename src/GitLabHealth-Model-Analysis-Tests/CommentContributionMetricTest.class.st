"
A CommentContributionMetricTest is a test class for testing the behavior of CommentContributionMetric
"
Class {
	#name : #CommentContributionMetricTest,
	#superclass : #TestCase,
	#category : #'GitLabHealth-Model-Analysis-Tests'
}

{ #category : #tests }
CommentContributionMetricTest >> testCalculate [

	| user glhImporter result commitDiff commentContribution |
	"Given"
	user := GLHUser new
		        username: 'test';
		        contributedProjects:
			        { (GLHProject new repository: GLHRepository new) }.

	commitDiff := GLHDiff new diffRanges: { (GLHDiffRange new changes:
			               { (GLHAddition new sourceCode: '// test') }) }.

	glhImporter := GLPHImporterMock new.
	glhImporter commits: { (GLHCommit new
			 id: 1;
			 created_at: '04-09-2024';
			 commitCreator: user;
			 diffs: { commitDiff }) }.


	commentContribution := CommentContributionMetric new
		                       user: user;
		                       glhImporter: glhImporter;
		                       setPeriodSince: '04-09-2024'
		                       until: '04-09-2024';
		                       over: Week.
	"When"
	result := commentContribution calculate.

	"Then"
	self assert: result equals: 1
]

{ #category : #tests }
CommentContributionMetricTest >> testCalculateNoCommits [

	| user glhImporter result commentContribution |
	"Given"
	user := GLHUser new
		        username: 'test';
		        contributedProjects:
			        { (GLHProject new repository: GLHRepository new) }.

	glhImporter := GLPHImporterMock new.


	commentContribution := CommentContributionMetric new
		                       user: user;
		                       glhImporter: glhImporter;
		                       setPeriodSince: '04-09-2024'
		                       until: '04-09-2024';
		                       over: Week.
	"When"
	result := commentContribution calculate.

	"Then"
	self assert: result equals: 0
]
