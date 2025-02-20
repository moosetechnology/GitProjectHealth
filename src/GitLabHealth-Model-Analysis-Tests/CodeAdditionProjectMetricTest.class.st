"
A CodeAdditionProjectMetricTest is a test class for testing the behavior of CodeAdditionProjectMetric
"
Class {
	#name : #CodeAdditionProjectMetricTest,
	#superclass : #TestCase,
	#category : #'GitLabHealth-Model-Analysis-Tests'
}

{ #category : #tests }
CodeAdditionProjectMetricTest >> testCalculate [

	| project glhImporter codeAddition result |
	"Given"
	project := GLHProject new name: 'test';repository: GLHRepository new. 

	glhImporter := GLPHImporterMock new.
	glhImporter commits: {
			(GLHCommit new
				 id: 1;
				 project: 'test';
				 created_at: '04-09-2024';
				 additions: 5).
			(GLHCommit new
				 id: 2;
				 project: project ;
				 created_at: '04-09-2024';
				 additions: 5) }.


	codeAddition := CodeAdditionMetric new
		                
		                glhImporter: glhImporter;
		                setPeriodSince: '04-09-2024' until: '04-09-2024';
		                over: Week.

	"When"
	result := codeAddition calculate.

	"Then"
	self assert: result equals: 10
]
