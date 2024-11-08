"
A TimeBetweenCommitMetricTest is a test class for testing the behavior of TimeBetweenCommitMetric
"
Class {
	#name : #TimeBetweenCommitMetricTest,
	#superclass : #TestCase,
	#category : 'GitLabHealth-Model-Analysis-Tests'
}

{ #category : #tests }
TimeBetweenCommitMetricTest >> testCalculate [

	| user glhImporter result timeBetweenCommit |
	"Given"
	user := GLHUser new
		        username: 'test';
		        contributedProjects:
			        { (GLHProject new repository: GLHRepository new) }.

	glhImporter := GLPHImporterMock new.
	glhImporter commits: {
			(GLHCommit new
				 id: 1;
				 created_at: '09-04-2024:01:00:00';
				 committed_date: '09-04-2024:01:00:00' asDateAndTime;
				 commitCreator: user;
				 additions: 5).
			(GLHCommit new
				 id: 2;
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

	| user glhImporter result timeBetweenCommit |
	"Given"
	user := GLHUser new
		        username: 'test';
		        contributedProjects:
			        { (GLHProject new repository: GLHRepository new) }.

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
