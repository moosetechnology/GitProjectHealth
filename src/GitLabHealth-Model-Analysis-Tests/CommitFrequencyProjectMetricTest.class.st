"
A CommitFrequencyProjectMetricTest is a test class for testing the behavior of CommitFrequencyProjectMetric
"
Class {
	#name : #CommitFrequencyProjectMetricTest,
	#superclass : #ProjectMetricTest,
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

{ #category : #tests }
CommitFrequencyProjectMetricTest >> testCalculate2Commits1DifferentProject [

	| glhImporter result commitFrequency |
	"Given"
	glhImporter := GLPHImporterMock new.
	glhImporter commits: { (GLHCommit new
			 created_at: createdAt;
			 repository: project1 repository).
		(GLHCommit new
			 created_at: createdAt + 1 hours;
			 repository: project1 repository).
		(GLHCommit new
			 created_at: createdAt + 2 hours;
			 repository: project2 repository)
				
			 }.


	commitFrequency := CommitFrequencyProjectMetric new
		                   project: project1;
		                   glhImporter: glhImporter;
		                   setPeriodSince: since until: until;
		                   over: Week.

	"When"
	result := commitFrequency calculate.

	"Then"
	self assert: result equals: 2
]

{ #category : #tests }
CommitFrequencyProjectMetricTest >> testCalculate3Commits [

	| glhImporter result commitFrequency |
	"Given"
	glhImporter := GLPHImporterMock new.
	glhImporter commits: { (GLHCommit new
			 created_at: createdAt;
			 repository: project1 repository).
		(GLHCommit new
			 created_at: createdAt + 1 hours;
			 repository: project1 repository).
		(GLHCommit new
			 created_at: createdAt + 2 hours;
			 repository: project1 repository)
				
			 }.


	commitFrequency := CommitFrequencyProjectMetric new
		                   project: project1;
		                   glhImporter: glhImporter;
		                   setPeriodSince: since until: until;
		                   over: Week.

	"When"
	result := commitFrequency calculate.

	"Then"
	self assert: result equals: 3
]

{ #category : #tests }
CommitFrequencyProjectMetricTest >> testCalculateNoCommitInProject [

	| glhImporter result commitFrequency |
	"Given"
	glhImporter := GLPHImporterMock new.
	glhImporter commits: {
			(GLHCommit new
				 created_at: createdAt;
				 repository: project2 repository).
			(GLHCommit new
				 created_at: createdAt + 1 hours;
				 repository: project2 repository).
			(GLHCommit new
				 created_at: createdAt + 2 hours;
				 repository: project2 repository) }.


	commitFrequency := CommitFrequencyProjectMetric new
		                   project: project1;
		                   glhImporter: glhImporter;
		                   setPeriodSince: since until: until;
		                   over: Week.

	"When"
	result := commitFrequency calculate.

	"Then"
	self assert: result equals: 0
]

{ #category : #tests }
CommitFrequencyProjectMetricTest >> testCalculateNoCommits [

	| glhImporter result commitFrequency |
	"Given"
	glhImporter := GLPHImporterMock new.
	glhImporter commits: {
				
			 }.


	commitFrequency := CommitFrequencyProjectMetric new
		                   project: project1;
		                   glhImporter: glhImporter;
		                   setPeriodSince: since until: until;
		                   over: Week.

	"When"
	result := commitFrequency calculate.

	"Then"
	self assert: result equals: 0
]
