"
A CommitsLinkWithTicketMetricTest is a test class for testing the behavior of CommitsLinkWithTicketMetric
"
Class {
	#name : #CommitsLinkWithTicketMetricTest,
	#superclass : #UserMetricTest,
	#category : #'GitLabHealth-Model-Analysis-Tests'
}

{ #category : #tests }
CommitsLinkWithTicketMetricTest >> testCalculate [
	"Given"

	| glhImporter jiraImporter commitLinkWithTicket result |
	glhImporter := GLPHImporterMock new.

	glhImporter commits: {
			(GLHCommit new
				 id: 1;
				 repository: project1 repository;
				 created_at: createdAt;
				 message: 'test';
				 additions: 7;
				 commitCreator: user;
				 deletions: 5).
			(GLHCommit new
				 id: 2;
				 repository: project1 repository;
				 created_at: createdAt;
				 message: '205';
				 additions: 3;
				 commitCreator: user;
				 deletions: 5) }.

	jiraImporter := JiraImporterMock new.
	jiraImporter issues: { (JPIssue new
			 key: '205';
			 timeEstimate: 25 hours asDuration) }.


	commitLinkWithTicket := CommitsLinkWithTicketMetric new
		                        user: user;
		                        glhImporter: glhImporter;
		                        jiraImporter: jiraImporter;
		                        setPeriodSince: since
		                        until: until;
		                        over: Week.

	"When"
	result := commitLinkWithTicket calculate.

	"Then"
	self assert: result equals: 1
]
