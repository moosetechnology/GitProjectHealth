"
A CodeAdditionMetricTest is a test class for testing the behavior of CodeAdditionMetric
"
Class {
	#name : #CodeAdditionMetricTest,
	#superclass : #TestCase,
	#category : #'GitLabHealth-Model-Analysis-Tests'
}

{ #category : #tests }
CodeAdditionMetricTest >> testCalculate [
	"Given"

	| user glhImporter codeAddition result |
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
				 additions: 5).
			(GLHCommit new
				 id: 2;
				 created_at: '04-09-2024';
				 commitCreator: user;
				 additions: 5) }.


	codeAddition := CodeAdditionMetric new
		                user: user;
		                glhImporter: glhImporter;
		                setPeriodSince: '04-09-2024' until: '04-09-2024';
		                over: Week.

	"Given"
	result := codeAddition calculate.

	"Then"
	self assert: result equals: 10
]
