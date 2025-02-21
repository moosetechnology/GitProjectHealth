"
A CommitFrequencyProjectMetricTest is a test class for testing the behavior of CommitFrequencyProjectMetric
"
Class {
	#name : #CommitFrequencyProjectMetricTest,
	#superclass : #UserMetricTest,
	#category : #'GitLabHealth-Model-Analysis-Tests'
}

{ #category : #tests }
CommitFrequencyProjectMetricTest >> testCalculate [

	| glhImporter result commitFrequency  |
	"Given"

	glhImporter := GLPHImporterMock new.
	glhImporter commits: { 
	(GLHCommit new created_at: '04-10-2024'; repository: project1 repository )
	 }.


	commitFrequency := CommitFrequencyProjectMetric new
		                   project: project1;
		                   glhImporter: glhImporter;
		                   setPeriodSince: '04-09-2024' until: '04-11-2024';
		                   over: Week.

	"When"
	result := commitFrequency calculate.

	"Then"
	self assert: result equals: 1
]
