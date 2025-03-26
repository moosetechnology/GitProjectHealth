"
A CommentContributionMetricTest is a test class for testing the behavior of CommentContributionMetric
"
Class {
	#name : #CommentContributionMetricTest,
	#superclass : #UserMetricTest,
	#category : #'GitLabHealth-Model-Analysis-Tests'
}

{ #category : #tests }
CommentContributionMetricTest >> testCalculate [

	| glhImporter result commitDiff commentContribution |
	commitDiff := GLHDiff new diffRanges: { (GLHDiffRange new changes:
			               { (GLHAddition new sourceCode: '// test') }) }.

	glhImporter := GLPHImporterMock new.
	glhImporter commits: { (GLHCommit new
			 id: 1;
			 repository: project1 repository;
			 created_at: createdAt ;
			 commitCreator: user;
			 diffs: { commitDiff }) }.


	commentContribution := CommentContributionMetric new
		                       user: user;
		                       glhImporter: glhImporter;
		                       setPeriodSince: since
		                       until: until;
		                       over: Week.
	"When"
	result := commentContribution calculate.

	"Then"
	self assert: result equals: 1
]

{ #category : #tests }
CommentContributionMetricTest >> testCalculateNoCommits [

	| glhImporter result commentContribution |
	glhImporter := GLPHImporterMock new.


	commentContribution := CommentContributionMetric new
		                       user: user;
		                       glhImporter: glhImporter;
		                       setPeriodSince: since
		                       until: until;
		                       over: Week.
	"When"
	result := commentContribution calculate.

	"Then"
	self assert: result equals: 0
]

{ #category : #tests }
CommentContributionMetricTest >> testCalculateOneCommentAddedAndDeleted [

	| glhImporter result commitDiff commitDiff2 commentContribution |
	commitDiff := GLHDiff new diffRanges: { (GLHDiffRange new changes:
			               { (GLHAddition new sourceCode: '// test') }) }.
	commitDiff2 := GLHDiff new diffRanges: { (GLHDiffRange new changes:
			               { (GLHDeletion new sourceCode: '// test') }) }.

	glhImporter := GLPHImporterMock new.
	glhImporter commits: { (GLHCommit new
			 id: 1;
			 repository: project1 repository;
			 created_at: createdAt;
			 commitCreator: user;
			 diffs: { commitDiff . commitDiff2 }) }.


	commentContribution := CommentContributionMetric new
		                       user: user;
		                       glhImporter: glhImporter;
		                       setPeriodSince: since until: until;
		                       over: Week.
	"When"
	result := commentContribution calculate.

	"Then"
	self assert: result equals: 1
]

{ #category : #tests }
CommentContributionMetricTest >> testCalculateOneCommentAddedAndDeletedOnSeperateCommit [

	| glhImporter result commitDiff commitDiff2 commentContribution |
	commitDiff := GLHDiff new diffRanges: { (GLHDiffRange new changes:
			               { (GLHAddition new sourceCode: '// test') }) }.
	commitDiff2 := GLHDiff new diffRanges: { (GLHDiffRange new changes:
			               { (GLHDeletion new sourceCode: '// test') }) }.

	glhImporter := GLPHImporterMock new.
	glhImporter commits: { (GLHCommit new
			 id: 1;
			 repository: project1 repository;
			 created_at: createdAt;
			 commitCreator: user;
			 diffs: { commitDiff  }).
			
			(GLHCommit new
			 id: 2;
			 repository: project1 repository;
			 created_at: createdAt;
			 commitCreator: user;
			 diffs: { commitDiff2 }) }.


	commentContribution := CommentContributionMetric new
		                       user: user;
		                       glhImporter: glhImporter;
		                       setPeriodSince: since until: until;
		                       over: Week.
	"When"
	result := commentContribution calculate.

	"Then"
	self assert: result equals: 1
]

{ #category : #tests }
CommentContributionMetricTest >> testCalculateOneCommentDeleted [

	| glhImporter result commitDiff commentContribution |
	commitDiff := GLHDiff new diffRanges: { (GLHDiffRange new changes:
			               { (GLHDeletion new sourceCode: '// test') }) }.

	glhImporter := GLPHImporterMock new.
	glhImporter commits: { (GLHCommit new
			 id: 1;
			 repository: project1 repository;
			 created_at: createdAt;
			 commitCreator: user;
			 diffs: { commitDiff }) }.


	commentContribution := CommentContributionMetric new
		                       user: user;
		                       glhImporter: glhImporter;
		                       setPeriodSince: since until: until;
		                       over: Week.
	"When"
	result := commentContribution calculate.

	"Then"
	self assert: result equals: 0
]
