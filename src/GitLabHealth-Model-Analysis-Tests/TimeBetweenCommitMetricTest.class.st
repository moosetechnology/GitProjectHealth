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
				 created_at: (DateAndTime year: 2024 month: 09 day: 04 hour: 01 minute: 0 second: 0);
				 committed_date: (DateAndTime year: 2024 month: 09 day: 04 hour: 01 minute: 0 second: 0);
				 commitCreator: user;
				 additions: 5).
			(GLHCommit new
				 id: 2;
				repository: project1 repository;
				 created_at: '09-04-2024';
				 committed_date: '09-05-2024' asDate;
				 commitCreator: user;
				 additions: 5) }.


	timeBetweenCommit := TimeBetweenCommitMetric new
		                     user: user;
		                     glhImporter: glhImporter;
		                     setPeriodSince: '09-04-2024'
		                     until: '09-04-2024';
		                     over: Week.

	"When"
	result := timeBetweenCommit calculate.

	"Then"
	self assert: result equals: (23 hours asSeconds)
]

{ #category : #tests }
TimeBetweenCommitMetricTest >> testCalculateNoCommits [

	| glhImporter result timeBetweenCommit |
	"Given"

	glhImporter := GLPHImporterMock new.


	timeBetweenCommit := TimeBetweenCommitMetric new
		                     user: user;
		                     glhImporter: glhImporter;
		                     setPeriodSince: '09-04-2024'
		                     until: '09-04-2024';
		                     over: Week.

	"When"
	result := timeBetweenCommit calculate.

	"Then"
	self assert: result equals: nil
]
