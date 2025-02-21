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

	| glhImporter result commitFrequency |
	"Given"
	glhImporter := GLPHImporterMock new.
	glhImporter commits: { (GLHCommit new
			 created_at: createdAt ;
			 repository: project1 repository) }.


	commitFrequency := CommitFrequencyProjectMetric new
		                   project: project1;
		                   glhImporter: glhImporter;
		                   setPeriodSince: since until: until;
		                   over: Week.

	"When"
	result := commitFrequency calculate.

	"Then"
	self assert: result equals: 1
]
