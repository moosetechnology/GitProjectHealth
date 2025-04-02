"
A CodeAdditionByMergeRequestProjectMetricTest is a test class for testing the behavior of CodeAdditionByMergeRequestProjectMetric
"
Class {
	#name : #CodeAdditionDuringAndByMergeRequestProjectMetricTest,
	#superclass : #ProjectMetricTest,
	#category : #'GitLabHealth-Model-Analysis-Tests'
}

{ #category : #'as yet unclassified' }
CodeAdditionDuringAndByMergeRequestProjectMetricTest >> testCalculate [

	| result glhImporter codeAddition mergedCommit |
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


	codeAddition := CodeAdditionDuringAndByMergeRequestProjectMetric new
		                project: project2;
		                glhImporter: glhImporter;
		                setPeriodSince: since until: until;
		                over: Week.

	"When"
	result := codeAddition calculate.

	"Then"
	self assert: result equals: 13
]

{ #category : #'as yet unclassified' }
CodeAdditionDuringAndByMergeRequestProjectMetricTest >> testCalculateMROpenOnly [

	| result glhImporter codeAddition |
	glhImporter := GLPHImporterMock new.
	glhImporter mergeRequests: { (GLHMergeRequest new
			 project: project1;
			 created_at: createdAt ;
			 merged_at: mergedAt ;
			 state: #opened ) }.

	codeAddition := CodeAdditionDuringAndByMergeRequestProjectMetric new
		                project: project1;
		                glhImporter: glhImporter;
		                setPeriodSince: since until: until;
		                over: Week.

	"When"
	result := codeAddition calculate.

	"Then"
	self assert: result equals: 0
]

{ #category : #'as yet unclassified' }
CodeAdditionDuringAndByMergeRequestProjectMetricTest >> testCalculateNoCommits [

	| result glhImporter codeAddition |
	glhImporter := GLPHImporterMock new.
	glhImporter mergeRequests: { (GLHMergeRequest new
			 project: project1;
			 created_at: createdAt ;
			 merged_at: mergedAt ;
			 state: #closed ) }.

	codeAddition := CodeAdditionDuringAndByMergeRequestProjectMetric new
		                project: project1;
		                glhImporter: glhImporter;
		                setPeriodSince: since until: until;
		                over: Week.

	"When"
	result := codeAddition calculate.

	"Then"
	self assert: result equals: 0
]

{ #category : #'as yet unclassified' }
CodeAdditionDuringAndByMergeRequestProjectMetricTest >> testCalculateNoMergeRequests [

	| result glhImporter codeAddition |
	glhImporter := GLPHImporterMock new.

	codeAddition := CodeAdditionDuringAndByMergeRequestProjectMetric new
		                project: project1 ;
		                glhImporter: glhImporter;
		                setPeriodSince: since until: until;
		                over: Week.

	"When"
	result := codeAddition calculate.

	"Then"
	self assert: result equals: 0
]

{ #category : #'as yet unclassified' }
CodeAdditionDuringAndByMergeRequestProjectMetricTest >> testCalculateWithMergeRequestCommit [

	| result glhImporter codeAddition commit |
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


	codeAddition := CodeAdditionDuringAndByMergeRequestProjectMetric new
		                project: project2;
		                glhImporter: glhImporter;
		                setPeriodSince: since until: until;
		                over: Week.

	"When"
	result := codeAddition calculate.

	"Then"
	self assert: result equals: 13
]

{ #category : #'as yet unclassified' }
CodeAdditionDuringAndByMergeRequestProjectMetricTest >> testCalculateWithSquashCommit [

	| result glhImporter codeAddition squashCommit |
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


	codeAddition := CodeAdditionDuringAndByMergeRequestProjectMetric new
		                project: project2;
		                glhImporter: glhImporter;
		                setPeriodSince: since until: until;
		                over: Week.

	"When"
	result := codeAddition calculate.

	"Then"
	self assert: result equals: 13
]
