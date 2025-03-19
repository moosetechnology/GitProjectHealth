"
A CommentLinesAddedProjectMetricTest is a test class for testing the behavior of CommentLinesAddedProjectMetric
"
Class {
	#name : #CommentLinesAddedProjectMetricTest,
	#superclass : #ProjectMetricTest,
	#category : #'GitLabHealth-Model-Analysis-Tests'
}

{ #category : #tests }
CommentLinesAddedProjectMetricTest >> testCalculate [

	| glhImporter result commitDiff commentContribution |
	commitDiff := GLHDiff new diffRanges: { (GLHDiffRange new changes:
			               { (GLHAddition new sourceCode: '// test') }) }.

	glhImporter := GLPHImporterMock new.
	glhImporter commits: { (GLHCommit new
			 id: 1;
			 repository: project1 repository;
			 created_at: createdAt;
			 diffs: { commitDiff }) }.


	commentContribution := CommentLinesAddedProjectMetric new
		                       project: project1 ;
		                       glhImporter: glhImporter;
		                       setPeriodSince: since until: until;
		                       over: Week.
	"When"
	result := commentContribution calculate.

	"Then"
	self assert: result equals: 1
]

{ #category : #tests }
CommentLinesAddedProjectMetricTest >> testCalculate2Commits [

	| glhImporter result commitDiff commitDiff2 commentContribution |
	commitDiff := GLHDiff new diffRanges: { (GLHDiffRange new changes:
			               { (GLHAddition new sourceCode: '// test') }) }.
	commitDiff2 := GLHDiff new diffRanges: { (GLHDiffRange new changes:
			                { (GLHAddition new sourceCode: '// test') . (GLHAddition new sourceCode: '// test')}) .  }.

	glhImporter := GLPHImporterMock new.
	glhImporter commits: {
			(GLHCommit new
				 id: 1;
				 repository: project1 repository;
				 created_at: createdAt;
				 diffs: {
						 commitDiff }).

			(GLHCommit new
				 id: 2;
				 repository: project1 repository;
				 created_at: createdAt;
				 diffs: { commitDiff2 }) }.


	commentContribution := CommentLinesAddedProjectMetric new
		                       project: project1;
		                       glhImporter: glhImporter;
		                       setPeriodSince: since until: until;
		                       over: Week.
	"When"
	result := commentContribution calculate.

	"Then"
	self assert: result equals: 3
]

{ #category : #tests }
CommentLinesAddedProjectMetricTest >> testCalculate2CommitsDifferentProject [

	| glhImporter result commitDiff commitDiff2 commentContribution |
	commitDiff := GLHDiff new diffRanges:
		              { (GLHDiffRange new changes:
			               { (GLHAddition new sourceCode: '// test') }) }.
	commitDiff2 := GLHDiff new diffRanges:
		               { (GLHDiffRange new changes: {
				                (GLHAddition new sourceCode: '// test').
				                (GLHAddition new sourceCode: '// test') }) }.

	glhImporter := GLPHImporterMock new.
	glhImporter commits: {
			(GLHCommit new
				 id: 1;
				 repository: project repository;
				 created_at: createdAt;
				 diffs: { commitDiff }).

			(GLHCommit new
				 id: 2;
				 repository: project1 repository;
				 created_at: createdAt;
				 diffs: { commitDiff2 }) }.


	commentContribution := CommentLinesAddedProjectMetric new
		                       project: project1;
		                       glhImporter: glhImporter;
		                       setPeriodSince: since until: until;
		                       over: Week.
	"When"
	result := commentContribution calculate.

	"Then"
	self assert: result equals: 2
]

{ #category : #tests }
CommentLinesAddedProjectMetricTest >> testCalculate2CommitsNoComment [

	| glhImporter result commitDiff commitDiff2 commentContribution |
	commitDiff := GLHDiff new diffRanges: { (GLHDiffRange new changes:
			               { (GLHAddition new sourceCode: ' test') }) }.
	commitDiff2 := GLHDiff new diffRanges: { (GLHDiffRange new changes:
			                { (GLHAddition new sourceCode: ' test') . (GLHAddition new sourceCode: ' test')}) .  }.

	glhImporter := GLPHImporterMock new.
	glhImporter commits: {
			(GLHCommit new
				 id: 1;
				 repository: project1 repository;
				 created_at: createdAt;
				 diffs: {
						 commitDiff }).

			(GLHCommit new
				 id: 2;
				 repository: project1 repository;
				 created_at: createdAt;
				 diffs: { commitDiff2 }) }.


	commentContribution := CommentLinesAddedProjectMetric new
		                       project: project1;
		                       glhImporter: glhImporter;
		                       setPeriodSince: since until: until;
		                       over: Week.
	"When"
	result := commentContribution calculate.

	"Then"
	self assert: result equals: 0
]

{ #category : #tests }
CommentLinesAddedProjectMetricTest >> testCalculate2CommitsNoCommentNotInProject [

	| glhImporter result commitDiff commitDiff2 commentContribution |
	commitDiff := GLHDiff new diffRanges:
		              { (GLHDiffRange new changes:
			               { (GLHAddition new sourceCode: ' test') }) }.
	commitDiff2 := GLHDiff new diffRanges:
		               { (GLHDiffRange new changes: {
				                (GLHAddition new sourceCode: ' test').
				                (GLHAddition new sourceCode: ' test') }) }.

	glhImporter := GLPHImporterMock new.
	glhImporter commits: {
			(GLHCommit new
				 id: 1;
				 repository: project repository;
				 created_at: createdAt;
				 diffs: { commitDiff }).

			(GLHCommit new
				 id: 2;
				 repository: project repository;
				 created_at: createdAt;
				 diffs: { commitDiff2 }) }.


	commentContribution := CommentLinesAddedProjectMetric new
		                       project: project1;
		                       glhImporter: glhImporter;
		                       setPeriodSince: since until: until;
		                       over: Week.
	"When"
	result := commentContribution calculate.

	"Then"
	self assert: result equals: 0
]

{ #category : #tests }
CommentLinesAddedProjectMetricTest >> testCalculate2CommitsNotInPeriod [

	| glhImporter result commitDiff commitDiff2 commentContribution |
	commitDiff := GLHDiff new diffRanges:
		              { (GLHDiffRange new changes:
			               { (GLHAddition new sourceCode: ' test') }) }.
	commitDiff2 := GLHDiff new diffRanges:
		               { (GLHDiffRange new changes: {
				                (GLHAddition new sourceCode: ' test').
				                (GLHAddition new sourceCode: ' test') }) }.

	glhImporter := GLPHImporterMock new.
	glhImporter commits: {
			(GLHCommit new
				 id: 1;
				 repository: project1 repository;
				 created_at: createdAt - 1 years;
				 diffs: { commitDiff }).

			(GLHCommit new
				 id: 2;
				 repository: project1 repository;
				 created_at: createdAt - 1 years;
				 diffs: { commitDiff2 }) }.


	commentContribution := CommentLinesAddedProjectMetric new
		                       project: project1;
		                       glhImporter: glhImporter;
		                       setPeriodSince: since until: until;
		                       over: Week.
	"When"
	result := commentContribution calculate.

	"Then"
	self assert: result equals: 0
]

{ #category : #tests }
CommentLinesAddedProjectMetricTest >> testCalculate2CommitsNotInProject [

	| glhImporter result commitDiff commitDiff2 commentContribution |
	commitDiff := GLHDiff new diffRanges:
		              { (GLHDiffRange new changes:
			               { (GLHAddition new sourceCode: '// test') }) }.
	commitDiff2 := GLHDiff new diffRanges:
		               { (GLHDiffRange new changes: {
				                (GLHAddition new sourceCode: '// test').
				                (GLHAddition new sourceCode: '// test') }) }.

	glhImporter := GLPHImporterMock new.
	glhImporter commits: {
			(GLHCommit new
				 id: 1;
				 repository: project repository;
				 created_at: createdAt;
				 diffs: { commitDiff }).

			(GLHCommit new
				 id: 2;
				 repository: project repository;
				 created_at: createdAt;
				 diffs: { commitDiff2 }) }.


	commentContribution := CommentLinesAddedProjectMetric new
		                       project: project1;
		                       glhImporter: glhImporter;
		                       setPeriodSince: since until: until;
		                       over: Week.
	"When"
	result := commentContribution calculate.

	"Then"
	self assert: result equals: 0
]

{ #category : #tests }
CommentLinesAddedProjectMetricTest >> testCalculate2CommitsOneBlockCOmment [

	| glhImporter result commitDiff commitDiff2 commentContribution |
	commitDiff := GLHDiff new diffRanges: { (GLHDiffRange new changes:
			               { (GLHAddition new sourceCode: ' test') }) }.
	commitDiff2 := GLHDiff new diffRanges: { (GLHDiffRange new changes:
			                { (GLHAddition new sourceCode: '/* test') . (GLHAddition new sourceCode: ' test */')}) .  }.

	glhImporter := GLPHImporterMock new.
	glhImporter commits: {
			(GLHCommit new
				 id: 1;
				 repository: project1 repository;
				 created_at: createdAt;
				 diffs: {
						 commitDiff }).

			(GLHCommit new
				 id: 2;
				 repository: project1 repository;
				 created_at: createdAt;
				 diffs: { commitDiff2 }) }.


	commentContribution := CommentLinesAddedProjectMetric new
		                       project: project1;
		                       glhImporter: glhImporter;
		                       setPeriodSince: since until: until;
		                       over: Week.
	"When"
	result := commentContribution calculate.

	"Then"
	self assert: result equals: 1
]

{ #category : #tests }
CommentLinesAddedProjectMetricTest >> testCalculateOneCommentAddedAndDeleted [

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

			 diffs: {
					 commitDiff.
					 commitDiff2 }) }.


	commentContribution := CommentLinesAddedProjectMetric new
		                       project: project1;
		                       glhImporter: glhImporter;
		                       setPeriodSince: since until: until;
		                       over: Week.
	"When"
	result := commentContribution calculate.

	"Then"
	self assert: result equals: 1
]

{ #category : #tests }
CommentLinesAddedProjectMetricTest >> testCalculateOneCommentAddedAndDeletedOnSeperateCommit [

	| glhImporter result commitDiff commitDiff2 commentContribution |
	commitDiff := GLHDiff new diffRanges: { (GLHDiffRange new changes:
			               { (GLHAddition new sourceCode: '// test') }) }.
	commitDiff2 := GLHDiff new diffRanges: { (GLHDiffRange new changes:
			                { (GLHDeletion new sourceCode: '// test') }) }.

	glhImporter := GLPHImporterMock new.
	glhImporter commits: {
			(GLHCommit new
				 id: 1;
				 repository: project1 repository;
				 created_at: createdAt;
				 diffs: {
						 commitDiff }).

			(GLHCommit new
				 id: 2;
				 repository: project1 repository;
				 created_at: createdAt;
				 diffs: { commitDiff2 }) }.


	commentContribution := CommentLinesAddedProjectMetric new
		                       project: project1;
		                       glhImporter: glhImporter;
		                       setPeriodSince: since until: until;
		                       over: Week.
	"When"
	result := commentContribution calculate.

	"Then"
	self assert: result equals: 1
]
