"
A CodeAdditionByCommitProjectMetricTest is a test class for testing the behavior of CodeAdditionByCommitProjectMetric
"
Class {
	#name : #CodeAdditionByCommitProjectMetricTest,
	#superclass : #ProjectMetricTest,
	#category : #'GitLabHealth-Model-Analysis-Tests'
}

{ #category : #tests }
CodeAdditionByCommitProjectMetricTest >> testCalculate [

	| result glhImporter codeAddition |
	glhImporter := GLPHImporterMock new.
	glhImporter mergeRequests: { (GLHMergeRequest new
			 project: project1;
			 created_at: createdAt;
			 merged_at: mergedAt;
			 state: #merged) }.

	glhImporter commits: {
			(GLHCommit new
				 id: 1;
				 repository: project1 repository;
				created_at: createdAt;
				 additions: 7;
				 deletions: 5).
			(GLHCommit new
				 id: 2;
				  repository: project1 repository;
								created_at: createdAt+5 minutes;
				 additions: 3;
				 deletions: 5).
			(GLHCommit new
				 id: 3;
				 repository: project1 repository;
								created_at: createdAt + 10 minutes;
				 additions: 3;
				 deletions: 5) }.


	codeAddition := CodeAdditionByCommitProjectMetric new
		                project: project1;
		                glhImporter: glhImporter;
		                setPeriodSince: since until: until;
		                over: Week.

	"When"
	result := codeAddition calculate.

	"Then"
	self assert: result equals: 13
]

{ #category : #tests }
CodeAdditionByCommitProjectMetricTest >> testCalculate2commits1OutsidePeriod [

	| result glhImporter codeAddition |
	glhImporter := GLPHImporterMock new.
	glhImporter mergeRequests: { (GLHMergeRequest new
			 project: project1;
			 created_at: createdAt;
			 merged_at: mergedAt;
			 state: #merged) }.

	glhImporter commits: {
			(GLHCommit new
				 id: 1;
				 repository: project1 repository;
				created_at: createdAt;
				 additions: 1;
				 deletions: 5).
			(GLHCommit new
				 id: 2;
				  repository: project1 repository;
								created_at: createdAt+5 minutes;
				 additions: 1;
				 deletions: 5).
			(GLHCommit new
				 id: 3;
				 repository: project1 repository;
								created_at: createdAt - 1 years;
				 additions: 1;
				 deletions: 5) }.


	codeAddition := CodeAdditionByCommitProjectMetric new
		                project: project1;
		                glhImporter: glhImporter;
		                setPeriodSince: since until: until;
		                over: Week.

	"When"
	result := codeAddition calculate.

	"Then"
	self assert: result equals: 2
]

{ #category : #tests }
CodeAdditionByCommitProjectMetricTest >> testCalculate3commits [

	| result glhImporter codeAddition |
	glhImporter := GLPHImporterMock new.
	glhImporter mergeRequests: { (GLHMergeRequest new
			 project: project1;
			 created_at: createdAt;
			 merged_at: mergedAt;
			 state: #merged) }.

	glhImporter commits: {
			(GLHCommit new
				 id: 1;
				 repository: project1 repository;
				created_at: createdAt;
				 additions: 1;
				 deletions: 5).
			(GLHCommit new
				 id: 2;
				  repository: project1 repository;
								created_at: createdAt+5 minutes;
				 additions: 1;
				 deletions: 5).
			(GLHCommit new
				 id: 3;
				 repository: project1 repository;
								created_at: createdAt + 10 minutes;
				 additions: 1;
				 deletions: 5) }.


	codeAddition := CodeAdditionByCommitProjectMetric new
		                project: project1;
		                glhImporter: glhImporter;
		                setPeriodSince: since until: until;
		                over: Week.

	"When"
	result := codeAddition calculate.

	"Then"
	self assert: result equals: 3
]

{ #category : #tests }
CodeAdditionByCommitProjectMetricTest >> testCalculateNoCommits [

	| result glhImporter codeAddition |
	glhImporter := GLPHImporterMock new.
	glhImporter mergeRequests: { (GLHMergeRequest new
			 project: project1;
			 created_at: createdAt;
			 merged_at: mergedAt;
			 state: #merged) }.

	glhImporter commits: {
			}.


	codeAddition := CodeAdditionByCommitProjectMetric new
		                project: project1;
		                glhImporter: glhImporter;
		                setPeriodSince: since until: until;
		                over: Week.

	"When"
	result := codeAddition calculate.

	"Then"
	self assert: result equals: 0
]
