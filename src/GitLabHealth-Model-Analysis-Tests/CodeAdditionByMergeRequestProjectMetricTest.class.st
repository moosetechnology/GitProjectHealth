"
A CodeAdditionByMergeRequestProjectMetricTest is a test class for testing the behavior of CodeAdditionByMergeRequestProjectMetric
"
Class {
	#name : #CodeAdditionByMergeRequestProjectMetricTest,
	#superclass : #ProjectMetricTest,
	#category : #'GitLabHealth-Model-Analysis-Tests'
}

{ #category : #tests }
CodeAdditionByMergeRequestProjectMetricTest >> testCalculate [

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


	codeAddition := CodeAdditionByMergeRequestProjectMetric new
		                project: project2;
		                glhImporter: glhImporter;
		                setPeriodSince: since until: until;
		                over: Week.

	"When"
	result := codeAddition calculate.

	"Then"
	self assert: result equals: 42
]

{ #category : #tests }
CodeAdditionByMergeRequestProjectMetricTest >> testCalculateMROpenOnly [

	| result glhImporter codeAddition |
	glhImporter := GLPHImporterMock new.
	glhImporter mergeRequests: { (GLHMergeRequest new
			 project: project1;
			 created_at: createdAt ;
			 merged_at: mergedAt ;
			 state: #opened ) }.

	codeAddition := CodeAdditionByMergeRequestProjectMetric new
		                project: project1;
		                glhImporter: glhImporter;
		                setPeriodSince: since until: until;
		                over: Week.

	"When"
	result := codeAddition calculate.

	"Then"
	self assert: result equals: 0
]

{ #category : #tests }
CodeAdditionByMergeRequestProjectMetricTest >> testCalculateNoCommits [

	| result glhImporter codeAddition |
	glhImporter := GLPHImporterMock new.
	glhImporter mergeRequests: { (GLHMergeRequest new
			 project: project1;
			 created_at: createdAt ;
			 merged_at: mergedAt ;
			 state: #closed ) }.

	codeAddition := CodeAdditionByMergeRequestProjectMetric new
		                project: project1;
		                glhImporter: glhImporter;
		                setPeriodSince: since until: until;
		                over: Week.

	"When"
	result := codeAddition calculate.

	"Then"
	self assert: result equals: 0
]

{ #category : #tests }
CodeAdditionByMergeRequestProjectMetricTest >> testCalculateNoMergeRequests [

	| result glhImporter codeAddition |
	glhImporter := GLPHImporterMock new.

	codeAddition := CodeAdditionByMergeRequestProjectMetric new
		                project: project1 ;
		                glhImporter: glhImporter;
		                setPeriodSince: since until: until;
		                over: Week.

	"When"
	result := codeAddition calculate.

	"Then"
	self assert: result equals: 0
]