"
A CodeDeletionByMRMetricTest is a test class for testing the behavior of CodeDeletionByMRMetric
"
Class {
	#name : #CodeDeletionByMRMetricTest,
	#superclass : #UserMetricTest,
	#category : #'GitLabHealth-Model-Analysis-Tests'
}

{ #category : #tests }
CodeDeletionByMRMetricTest >> testCalculate [

	| result glhImporter  codeDeletion |


	glhImporter := GLPHImporterMock new.
	glhImporter mergeRequests: { (GLHMergeRequest new
			 author: user;
			 project: project1;
			 created_at: createdAt ;
			 merged_at: mergedAt ;
			 state: #merged;
			 title: '205 feat do something') }.

	glhImporter commits: {
			(GLHCommit new
				 id: 1;
				repository: project1 repository;
			 created_at: createdAt ;
				 additions: 7;
				 commitCreator: user;
				 deletions: 5).
			(GLHCommit new
				 id: 2;
				repository: project1 repository;
			 created_at: createdAt ;
				 additions: 3;
				 commitCreator: user;
				 deletions: 5) }.

	codeDeletion := CodeDeletionByMRMetric new
		                user: user;
		                glhImporter: glhImporter;
		                setPeriodSince: since until: until;
		                over: Week.

	"When"
	result := codeDeletion calculate.

	"Then"
	self assert: result equals: 10
]

{ #category : #tests }
CodeDeletionByMRMetricTest >> testCalculateNoCommits [

	| result glhImporter codeDeletion |
	"Given"
	glhImporter := GLPHImporterMock new.
	glhImporter mergeRequests: { (GLHMergeRequest new
			 author: user;
			 created_at: createdAt ;
			 state: #opened;
			 title: '205 feat do something') }.

	codeDeletion := CodeDeletionByMRMetric new
		                user: user;
		                glhImporter: glhImporter;
		                setPeriodSince: since until: until;
		                over: Week.

	"When"
	result := codeDeletion calculate.

	"Then"
	self assert: result equals: 0
]

{ #category : #tests }
CodeDeletionByMRMetricTest >> testCalculateNoMergeRequests [

	| result glhImporter codeDeletion |
	"Given"
	glhImporter := GLPHImporterMock new.
	glhImporter mergeRequests: {  }.

	codeDeletion := CodeDeletionByMRMetric new
		                user: user;
		                glhImporter: glhImporter;
		                setPeriodSince: since until: until;
		                over: Week.

	"When"
	result := codeDeletion calculate.

	"Then"
	self assert: result equals: 0
]
