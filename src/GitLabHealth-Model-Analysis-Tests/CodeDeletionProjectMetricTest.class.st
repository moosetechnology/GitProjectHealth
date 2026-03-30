"
A CodeAdditionByCommitProjectMetricTest is a test class for testing the behavior of CodeAdditionByCommitProjectMetric
"
Class {
	#name : #CodeDeletionProjectMetricTest,
	#superclass : #ProjectMetricTest,
	#category : #'GitLabHealth-Model-Analysis-Tests'
}

{ #category : #tests }
CodeDeletionProjectMetricTest >> testCalculate [

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
				 created_at: createdAt + 5 minutes;
				 additions: 3;
				 deletions: 5).
			(GLHCommit new
				 id: 3;
				 repository: project1 repository;
				 created_at: createdAt + 10 minutes;
				 additions: 3;
				 deletions: 5) }.


	codeAddition := CodeDeletionProjectMetric new
		                project: project1;
		                glhImporter: glhImporter;
		                setPeriodSince: since until: until;
		                over: Week.

	"When"
	result := codeAddition calculate.

	"Then"
	self assert: result equals: 15
]

{ #category : #tests }
CodeDeletionProjectMetricTest >> testCalculate2commits1OutsidePeriod [

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
				 created_at: createdAt + 5 minutes;
				 additions: 1;
				 deletions: 5).
			(GLHCommit new
				 id: 3;
				 repository: project1 repository;
				 created_at: createdAt - 1 years;
				 additions: 1;
				 deletions: 5) }.


	codeAddition := CodeDeletionProjectMetric new
		                project: project1;
		                glhImporter: glhImporter;
		                setPeriodSince: since until: until;
		                over: Week.

	"When"
	result := codeAddition calculate.

	"Then"
	self assert: result equals: 10
]

{ #category : #tests }
CodeDeletionProjectMetricTest >> testCalculate3commits [

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
				 created_at: createdAt + 5 minutes;
				 additions: 1;
				 deletions: 5).
			(GLHCommit new
				 id: 3;
				 repository: project1 repository;
				 created_at: createdAt + 10 minutes;
				 additions: 1;
				 deletions: 5) }.


	codeAddition := CodeDeletionProjectMetric new
		                project: project1;
		                glhImporter: glhImporter;
		                setPeriodSince: since until: until;
		                over: Week.

	"When"
	result := codeAddition calculate.

	"Then"
	self assert: result equals: 15
]

{ #category : #tests }
CodeDeletionProjectMetricTest >> testCalculateNoCommits [

	| result glhImporter codeAddition |
	glhImporter := GLPHImporterMock new.
	glhImporter mergeRequests: { (GLHMergeRequest new
			 project: project1;
			 created_at: createdAt;
			 merged_at: mergedAt;
			 state: #merged) }.

	glhImporter commits: {  }.


	codeAddition := CodeDeletionProjectMetric new
		                project: project1;
		                glhImporter: glhImporter;
		                setPeriodSince: since until: until;
		                over: Week.

	"When"
	result := codeAddition calculate.

	"Then"
	self assert: result equals: 0
]
