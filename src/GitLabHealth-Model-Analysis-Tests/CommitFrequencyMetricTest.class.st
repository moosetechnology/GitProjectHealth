"
A CommitFrequencyMetricTest is a test class for testing the behavior of CommitFrequencyMetric
"
Class {
	#name : #CommitFrequencyMetricTest,
	#superclass : #TestCase,
	#category : #'GitLabHealth-Model-Analysis-Tests'
}

{ #category : #tests }
CommitFrequencyMetricTest >> testCalculate [

	| user glhImporter result commitFrequency |
	"Given"
	user := GLHUser new
		        username: 'test';
		        contributedProjects:
			        { (GLHProject new repository: GLHRepository new) }.

	glhImporter := GLPHImporterMock new.


	commitFrequency := CommitFrequencyMetric new
		                   userWithId: user;
		                   glhImporter: glhImporter;
		                   setPeriodSince: '04-09-2024' until: '04-09-2024';
		                   over: Week.

	"When"
	result := commitFrequency calculate.

	"Then"
	self assert: result equals: 0
]

{ #category : #tests }
CommitFrequencyMetricTest >> testCalculateNoCommits [

	| user glhImporter result commitFrequency |
	"Given"
	user := GLHUser new
		        username: 'test';
		        contributedProjects:
			        { (GLHProject new repository: GLHRepository new) }.

	glhImporter := GLPHImporterMock new.


	commitFrequency := CommitFrequencyMetric new
		                   userWithId: user;
		                   glhImporter: glhImporter;
		                   setPeriodSince: '04-09-2024' until: '04-09-2024';
		                   over: Week.

	"When"
	result := commitFrequency calculate.

	"Then"
	self assert: result equals: 0
]
