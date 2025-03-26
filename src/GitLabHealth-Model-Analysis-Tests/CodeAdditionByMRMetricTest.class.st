"
A CodeAdditionByMRMetricTest is a test class for testing the behavior of CodeAdditionByMRMetric
"
Class {
	#name : #CodeAdditionByMRMetricTest,
	#superclass : #UserMetricTest,
	#category : #'GitLabHealth-Model-Analysis-Tests'
}

{ #category : #tests }
CodeAdditionByMRMetricTest >> testCalculate [

	| result glhImporter codeAddition |
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


	codeAddition := CodeAdditionByMRMetric new
		                user: user;
		                glhImporter: glhImporter;
		                setPeriodSince: since until: until;
		                over: Week.

	"When"
	result := codeAddition calculate.

	"Then"
	self assert: result equals: 10
]

{ #category : #tests }
CodeAdditionByMRMetricTest >> testCalculateNoCommits [

	| result glhImporter codeAddition |
	glhImporter := GLPHImporterMock new.
	glhImporter mergeRequests: { (GLHMergeRequest new
			
			 project: project1;
			 created_at: createdAt ;
			 merged_at: mergedAt ;
			 state: #merged;
			 title: '205 feat do something') }.

	codeAddition := CodeAdditionByMRMetric new
		                user: user;
		                glhImporter: glhImporter;
		                setPeriodSince: since until: until;
		                over: Week.

	"When"
	result := codeAddition calculate.

	"Then"
	self assert: result equals: 0
]

{ #category : #tests }
CodeAdditionByMRMetricTest >> testCalculateNoMergeRequests [

	| result glhImporter codeAddition |
	glhImporter := GLPHImporterMock new.

	codeAddition := CodeAdditionByMRMetric new
		                user: user;
		                glhImporter: glhImporter;
		                setPeriodSince: since until: until;
		                over: Week.

	"When"
	result := codeAddition calculate.

	"Then"
	self assert: result equals: 0
]
