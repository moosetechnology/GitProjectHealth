"
A CodeDeletionMetricTest is a test class for testing the behavior of CodeDeletionMetric
"
Class {
	#name : #CodeDeletionMetricTest,
	#superclass : #TestCase,
	#category : #'GitLabHealth-Model-Analysis-Tests'
}

{ #category : #tests }
CodeDeletionMetricTest >> testCalculate [

	| user glhImporter result codeDeletion |
	"Given"
	user := GLHUser new
		        username: 'test';
		        contributedProjects:
			        { (GLHProject new repository: GLHRepository new) }.

	glhImporter := GLPHImporterMock new.
	glhImporter commits: {
			(GLHCommit new
				 id: 1;
				 created_at: '04-09-2024';
				 commitCreator: user;
				 deletions: 5).
			(GLHCommit new
				 id: 2;
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

	| user glhImporter result codeDeletion |
	"Given"
	user := GLHUser new
		        username: 'test';
		        contributedProjects:
			        { (GLHProject new repository: GLHRepository new) }.

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
