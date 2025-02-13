"
A CodeAdditionByMRMetricTest is a test class for testing the behavior of CodeAdditionByMRMetric
"
Class {
	#name : #CodeAdditionByMRMetricTest,
	#superclass : #TestCase,
	#category : #'GitLabHealth-Model-Analysis-Tests'
}

{ #category : #tests }
CodeAdditionByMRMetricTest >> testCalculate [

	| result glhImporter user codeAddition |
	"Given"
	user := GLHUser new
		        username: 'test';
		        contributedProjects:
			        { (GLHProject new repository: GLHRepository new) }.

	glhImporter := GLPHImporterMock new.
	glhImporter mergeRequests: { (GLHMergeRequest new
			 author: user;
			 created_at: '2024-09-05';
			 merged_at: '2024-09-06' asDate;
			 title: '205 feat do something') }.

	glhImporter commits: {
			(GLHCommit new
				 id: 1;
				 created_at: '2024-09-05' asDate;
				 additions: 7;
				 commitCreator: user;
				 deletions: 5).
			(GLHCommit new
				 id: 2;
				 created_at: '2024-09-05' asDate;
				 additions: 3;
				 commitCreator: user;
				 deletions: 5) }.


	codeAddition := CodeAdditionByMRMetric new
		                user: user;
		                glhImporter: glhImporter;
		                setPeriodSince: '2024-09-04' until: '2024-09-04';
		                over: Week.

	"When"
	result := codeAddition calculate.

	"Then"
	self assert: result equals: 10
]

{ #category : #tests }
CodeAdditionByMRMetricTest >> testCalculateNoCommits [

	| result glhImporter user codeAddition |
	"Given"
	user := GLHUser new
		        username: 'test';
		        contributedProjects:
			        { (GLHProject new repository: GLHRepository new) }.

	glhImporter := GLPHImporterMock new.
	glhImporter mergeRequests: { (GLHMergeRequest new
			 author: user;
			 created_at: '2024-09-05';
			 merged_at: '2024-09-06' asDate;
			 title: '205 feat do something') }.

	codeAddition := CodeAdditionByMRMetric new
		                user: user;
		                glhImporter: glhImporter;
		                setPeriodSince: '2024-09-04' until: '2024-09-04';
		                over: Week.

	"When"
	result := codeAddition calculate.

	"Then"
	self assert: result equals: 0
]

{ #category : #tests }
CodeAdditionByMRMetricTest >> testCalculateNoMergeRequests [

	| result glhImporter user codeAddition |
	"Given"
	user := GLHUser new
		        username: 'test';
		        contributedProjects:
			        { (GLHProject new repository: GLHRepository new) }.

	glhImporter := GLPHImporterMock new.

	codeAddition := CodeAdditionByMRMetric new
		                user: user;
		                glhImporter: glhImporter;
		                setPeriodSince: '2024-09-04' until: '2024-09-04';
		                over: Week.

	"When"
	result := codeAddition calculate.

	"Then"
	self assert: result equals: 0
]
