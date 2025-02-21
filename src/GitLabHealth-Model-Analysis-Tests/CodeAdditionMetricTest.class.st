"
A CodeAdditionMetricTest is a test class for testing the behavior of CodeAdditionMetric
"
Class {
	#name : #CodeAdditionMetricTest,
	#superclass : #UserMetricTest,
	#category : #'GitLabHealth-Model-Analysis-Tests'
}

{ #category : #tests }
CodeAdditionMetricTest >> testCalculate [

	| glhImporter codeAddition result |
	glhImporter := GLPHImporterMock new.
	glhImporter commits: {
			(GLHCommit new
				 id: 1;
				 created_at: createdAt ;
				 repository: project1 repository;
				 commitCreator: user;
				 additions: 5).
			(GLHCommit new
				 id: 2;
				 repository: project1 repository;
				 created_at: createdAt ;
				 commitCreator: user;
				 additions: 5) }.


	codeAddition := CodeAdditionMetric new
		                user: user;
		                glhImporter: glhImporter;
		                setPeriodSince: since until: since;
		                over: Week.

	"When"
	result := codeAddition calculate.

	"Then"
	self assert: result equals: 10
]

{ #category : #tests }
CodeAdditionMetricTest >> testCalculateNoCommits [

	| glhImporter codeAddition result |
	glhImporter := GLPHImporterMock new.


	codeAddition := CodeAdditionMetric new
		                user: user;
		                glhImporter: glhImporter;
		                setPeriodSince: since until: until;
		                over: Week.

	"When"
	result := codeAddition calculate.

	"Then"
	self assert: result equals: 0
]
