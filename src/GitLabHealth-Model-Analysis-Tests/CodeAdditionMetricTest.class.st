"
A CodeAdditionMetricTest is a test class for testing the behavior of CodeAdditionMetric
"
Class {
	#name : #CodeAdditionMetricTest,
	#superclass : #UserMetricTest,
	#category : #'GitLabHealth-Model-Analysis-Tests'
}

{ #category : #running }
CodeAdditionMetricTest >> setUp [

	project1 := GLHProject new
		            repository: GLHRepository new;
		            name: 'project1'.
	user := GLHUser new
		        username: 'test';
		        contributedProjects: { project1 }
]

{ #category : #tests }
CodeAdditionMetricTest >> testCalculate [

	|  glhImporter codeAddition result |


	glhImporter := GLPHImporterMock new.
	glhImporter commits: {
			(GLHCommit new
				 id: 1;
				 created_at: '04-09-2024';
				 repository: project1 repository;
				 commitCreator: user;
				 additions: 5).
			(GLHCommit new
				 id: 2;
				 repository: project1 repository;
				 created_at: '04-09-2024';
				 commitCreator: user;
				 additions: 5) }.


	codeAddition := CodeAdditionMetric new
		                user: user;
		                glhImporter: glhImporter;
		                setPeriodSince: '04-09-2024' until: '04-09-2024';
		                over: Week.

	"When"
	result := codeAddition calculate.

	"Then"
	self assert: result equals: 10
]

{ #category : #tests }
CodeAdditionMetricTest >> testCalculateNoCommits [

	|  glhImporter codeAddition result |


	glhImporter := GLPHImporterMock new.


	codeAddition := CodeAdditionMetric new
		                user: user;
		                glhImporter: glhImporter;
		                setPeriodSince: '04-09-2024' until: '04-09-2024';
		                over: Week.

	"When"
	result := codeAddition calculate.

	"Then"
	self assert: result equals: 0
]
