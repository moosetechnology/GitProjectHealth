"
A CodeAdditionByMRMetricTest is a test class for testing the behavior of CodeAdditionByMRMetric
"
Class {
	#name : #CodeAdditionByMRMetricTest,
	#superclass : #TestCase,
	#instVars : [
		'project1',
		'user'
	],
	#category : #'GitLabHealth-Model-Analysis-Tests'
}

{ #category : #running }
CodeAdditionByMRMetricTest >> setUp [

	project1 := GLHProject new
		            repository: GLHRepository new;
		            name: 'project1'.
	user := GLHUser new
		        username: 'test';
		        contributedProjects: { project1 }
]

{ #category : #tests }
CodeAdditionByMRMetricTest >> testCalculate [

	| result glhImporter codeAddition |
	glhImporter := GLPHImporterMock new.
	glhImporter mergeRequests: { (GLHMergeRequest new
			 author: user;
			 project: project1;
			 created_at: '2024-09-05T10:24:11.803+02:00' asDateAndTime;
			 merged_at: '2024-09-05T11:24:11.803+02:00' asDateAndTime;
			 state: 'merged';
			 title: '205 feat do something') }.

	glhImporter commits: {
			(GLHCommit new
				 id: 1;
				 repository: project1 repository;
			 	 created_at: '2024-09-05T10:24:11.803+02:00' asDateAndTime;
				 additions: 7;
				 commitCreator: user;
				 deletions: 5).
			(GLHCommit new
				 id: 2;
				 repository: project1 repository;
			     created_at: '2024-09-05T10:34:11.803+02:00' asDateAndTime;
			 	 additions: 3;
				 commitCreator: user;
				 deletions: 5) }.


	codeAddition := CodeAdditionByMRMetric new
		                user: user;
		                glhImporter: glhImporter;
		                setPeriodSince: '09-04-2024' until: '09-05-2024';
		                over: Week.

	"When"
	result := codeAddition calculate.

	"Then"
	self assert: result equals: 10
]

{ #category : #tests }
CodeAdditionByMRMetricTest >> testCalculateNoCommits [

	| result glhImporter  codeAddition |


	glhImporter := GLPHImporterMock new.
	glhImporter mergeRequests: { (GLHMergeRequest new
			 author: user;
			project: project1;
			 created_at: '2024-09-05T10:24:11.803+02:00' asDateAndTime;
			 merged_at: '2024-09-05T11:24:11.803+02:00' asDateAndTime;
			state: 'merged';
			 title: '205 feat do something') }.

	codeAddition := CodeAdditionByMRMetric new
		                user: user;
		                glhImporter: glhImporter;
		                setPeriodSince: '09-04-2024' until: '09-04-2024';
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
		                setPeriodSince: '09-04-2024' until: '09-04-2024';
		                over: Week.

	"When"
	result := codeAddition calculate.

	"Then"
	self assert: result equals: 0
]
