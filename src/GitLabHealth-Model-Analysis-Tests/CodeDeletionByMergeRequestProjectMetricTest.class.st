"
A CodeAdditionByMergeRequestProjectMetricTest is a test class for testing the behavior of CodeAdditionByMergeRequestProjectMetric
"
Class {
	#name : #CodeDeletionByMergeRequestProjectMetricTest,
	#superclass : #ProjectMetricTest,
	#category : #'GitLabHealth-Model-Analysis-Tests'
}

{ #category : #tests }
CodeDeletionByMergeRequestProjectMetricTest >> testCalculate [

	| result glhImporter codeDeletion mergedCommit |
	glhImporter := GLPHImporterMock new.
	mergedCommit := GLHCommit new
		                id: 4;
		                additions: 42;
		                deletions: 78.
	glhImporter mergeRequests: { (GLHMergeRequest new
			 project: project2;
			 created_at: createdAt;
			 merged_at: mergedAt;
			 mergedCommit: mergedCommit;
			 state: #merged) }.

	glhImporter commits: {
			(GLHCommit new
				 id: 1;
				 additions: 7;
				 deletions: 5).
			(GLHCommit new
				 id: 2;
				 additions: 3;
				 deletions: 5).
			(GLHCommit new
				 id: 3;
				 additions: 3;
				 deletions: 5) }.


	codeDeletion := CodeDeletionByMergeRequestProjectMetric new
		                project: project2;
		                glhImporter: glhImporter;
		                setPeriodSince: since until: until;
		                over: Week.

	"When"
	result := codeDeletion calculate.

	"Then"
	self assert: result equals: 78
]

{ #category : #tests }
CodeDeletionByMergeRequestProjectMetricTest >> testCalculateMROpenOnly [

	| result glhImporter codeDeletion |
	glhImporter := GLPHImporterMock new.
	glhImporter mergeRequests: { (GLHMergeRequest new
			 project: project1;
			 created_at: createdAt ;
			 merged_at: mergedAt ;
			 state: #opened ) }.

	codeDeletion := CodeDeletionByMergeRequestProjectMetric new
		                project: project1;
		                glhImporter: glhImporter;
		                setPeriodSince: since until: until;
		                over: Week.

	"When"
	result := codeDeletion calculate.

	"Then"
	self assert: result equals: 0
]

{ #category : #tests }
CodeDeletionByMergeRequestProjectMetricTest >> testCalculateMergedWithMergeRequestCommit [

	| result glhImporter codeDeletion commit |
	glhImporter := GLPHImporterMock new.
	commit := GLHCommit new
		                id: 4;
		                additions: 42;
		                deletions: 78.
	glhImporter mergeRequests: { (GLHMergeRequest new
			 project: project2;
			 created_at: createdAt;
			 merged_at: mergedAt;
			 mergeRequestCommit: commit;
			 state: #merged) }.

	glhImporter commits: {
			(GLHCommit new
				 id: 1;
				 additions: 7;
				 deletions: 5).
			(GLHCommit new
				 id: 2;
				 additions: 3;
				 deletions: 5).
			(GLHCommit new
				 id: 3;
				 additions: 3;
				 deletions: 5) }.


	codeDeletion := CodeDeletionByMergeRequestProjectMetric new
		                project: project2;
		                glhImporter: glhImporter;
		                setPeriodSince: since until: until;
		                over: Week.

	"When"
	result := codeDeletion calculate.

	"Then"
	self assert: result equals: 78
]

{ #category : #tests }
CodeDeletionByMergeRequestProjectMetricTest >> testCalculateNoCommits [

	| result glhImporter codeDeletion |
	glhImporter := GLPHImporterMock new.
	glhImporter mergeRequests: { (GLHMergeRequest new
			 project: project1;
			 created_at: createdAt ;
			 merged_at: mergedAt ;
			 state: #closed ) }.

	codeDeletion := CodeDeletionByMergeRequestProjectMetric new
		                project: project1;
		                glhImporter: glhImporter;
		                setPeriodSince: since until: until;
		                over: Week.

	"When"
	result := codeDeletion calculate.

	"Then"
	self assert: result equals: 0
]

{ #category : #tests }
CodeDeletionByMergeRequestProjectMetricTest >> testCalculateNoMergeRequests [

	| result glhImporter codeDeletion |
	glhImporter := GLPHImporterMock new.

	codeDeletion := CodeDeletionByMergeRequestProjectMetric new
		                project: project1 ;
		                glhImporter: glhImporter;
		                setPeriodSince: since until: until;
		                over: Week.

	"When"
	result := codeDeletion calculate.

	"Then"
	self assert: result equals: 0
]

{ #category : #tests }
CodeDeletionByMergeRequestProjectMetricTest >> testCalculateWithSquashCommit [

	| result glhImporter codeDeletion squashCommit |
	glhImporter := GLPHImporterMock new.
	squashCommit := GLHCommit new
		                id: 4;
		                additions: 42;
		                deletions: 78.
	glhImporter mergeRequests: { (GLHMergeRequest new
			 project: project2;
			 created_at: createdAt;
			 merged_at: mergedAt;
			 squashCommit: squashCommit;
			 state: #merged) }.

	glhImporter commits: {
			(GLHCommit new
				 id: 1;
				 additions: 7;
				 deletions: 5).
			(GLHCommit new
				 id: 2;
				 additions: 3;
				 deletions: 5).
			(GLHCommit new
				 id: 3;
				 additions: 3;
				 deletions: 5) }.


	codeDeletion := CodeDeletionByMergeRequestProjectMetric new
		                project: project2;
		                glhImporter: glhImporter;
		                setPeriodSince: since until: until;
		                over: Week.

	"When"
	result := codeDeletion calculate.

	"Then"
	self assert: result equals: 78
]
