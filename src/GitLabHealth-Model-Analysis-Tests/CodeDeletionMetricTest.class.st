"
A CodeDeletionMetricTest is a test class for testing the behavior of CodeDeletionMetric
"
Class {
	#name : #CodeDeletionMetricTest,
	#superclass : #UserMetricTest,
	#category : #'GitLabHealth-Model-Analysis-Tests'
}

{ #category : #running }
CodeDeletionMetricTest >> setUp [ 

		"Given"
	project1 := (GLHProject new repository: GLHRepository new; name: 'project1').
	user := GLHUser new
		        username: 'test';
		        contributedProjects:
			        { project1 }.
]

{ #category : #tests }
CodeDeletionMetricTest >> testCalculate [

	| glhImporter result codeDeletion |
	"Given"


	glhImporter := GLPHImporterMock new.
	glhImporter commits: {
			(GLHCommit new
				 id: 1;
				repository: project1 repository;
				 created_at: '04-09-2024';
				 commitCreator: user;
				 deletions: 5).
			(GLHCommit new
				 id: 2;
				repository: project1 repository;
				 created_at: '04-09-2024';
				 commitCreator: user;
				 deletions: 5) }.


	codeDeletion := CodeDeletionMetric new
		                user: user;
		                glhImporter: glhImporter;
		                setPeriodSince: '04-09-2024' until: '04-09-2024';
		                over: Week.

	"When"
	result := codeDeletion calculate.

	"Then"
	self assert: result equals: 10
]

{ #category : #tests }
CodeDeletionMetricTest >> testCalculateNoCommits [

	|  glhImporter result codeDeletion |


	glhImporter := GLPHImporterMock new.


	codeDeletion := CodeDeletionMetric new
		                user: user;
		                glhImporter: glhImporter;
		                setPeriodSince: '04-09-2024' until: '04-09-2024';
		                over: Week.

	"When"
	result := codeDeletion calculate.

	"Then"
	self assert: result equals: 0
]
