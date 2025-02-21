"
A TimeBetweenCommitMetricTest is a test class for testing the behavior of TimeBetweenCommitMetric
"
Class {
	#name : #TimeBetweenCommitMetricTest,
	#superclass : #UserMetricTest,
	#category : #'GitLabHealth-Model-Analysis-Tests'
}

{ #category : #tests }
TimeBetweenCommitMetricTest >> testCalculate [

	| glhImporter result timeBetweenCommit |
	"Given"
	glhImporter := GLPHImporterMock new.
	glhImporter commits: {
			(GLHCommit new
				 id: 1;
				 repository: project1 repository;
				 created_at: createdAt ;
				 committed_date: createdAt ;
				 commitCreator: user;
				 additions: 5).
			(GLHCommit new
				 id: 2;
				 repository: project1 repository;
				 created_at: createdAt + 23 hours ;
				 committed_date: createdAt + 23 hours ;
				 commitCreator: user;
				 additions: 5) }.


	timeBetweenCommit := TimeBetweenCommitMetric new
		                     user: user;
		                     glhImporter: glhImporter;
		                     setPeriodSince: since
		                     until: until;
		                     over: Week.

	"When"
	result := timeBetweenCommit calculate.

	"Then"
	self assert: result equals: 23 hours asSeconds
]

{ #category : #tests }
TimeBetweenCommitMetricTest >> testCalculateNoCommits [

	| glhImporter result timeBetweenCommit |
	"Given"
	glhImporter := GLPHImporterMock new.


	timeBetweenCommit := TimeBetweenCommitMetric new
		                     user: user;
		                     glhImporter: glhImporter;
		                     setPeriodSince: since
		                     until: until;
		                     over: Week.

	"When"
	result := timeBetweenCommit calculate.

	"Then"
	self assert: result equals: nil
]
