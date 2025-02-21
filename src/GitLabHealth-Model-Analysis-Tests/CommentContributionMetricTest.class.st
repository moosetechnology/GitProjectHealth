"
A CommentContributionMetricTest is a test class for testing the behavior of CommentContributionMetric
"
Class {
	#name : #CommentContributionMetricTest,
	#superclass : #TestCase,
	#instVars : [
		'project1',
		'user'
	],
	#category : #'GitLabHealth-Model-Analysis-Tests'
}

{ #category : #running }
CommentContributionMetricTest >> setUp [ 
	project1 := (GLHProject new repository: GLHRepository new; name: 'project1').
		user := GLHUser new
		        username: 'test';
		        contributedProjects:
			        { project1 }.
]

{ #category : #tests }
CommentContributionMetricTest >> testCalculate [

	|  glhImporter result commitDiff commentContribution |


	commitDiff := GLHDiff new diffRanges: { (GLHDiffRange new changes:
			               { (GLHAddition new sourceCode: '// test') }) }.

	glhImporter := GLPHImporterMock new.
	glhImporter commits: { (GLHCommit new
			 id: 1;
			repository: project1 repository;
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

	|  glhImporter result commentContribution |


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
