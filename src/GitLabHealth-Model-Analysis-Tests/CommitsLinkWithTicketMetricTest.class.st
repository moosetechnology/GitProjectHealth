"
A CommitsLinkWithTicketMetricTest is a test class for testing the behavior of CommitsLinkWithTicketMetric
"
Class {
	#name : #CommitsLinkWithTicketMetricTest,
	#superclass : #TestCase,
	#category : #'GitLabHealth-Model-Analysis-Tests'
}

{ #category : #tests }
CommitsLinkWithTicketMetricTest >> testCalculate [

	"Given"
	| user glhImporter jiraImporter commitLinkWithTicket result |
	user := GLHUser new
		        username: 'test';
		        contributedProjects:
			        { (GLHProject new repository: GLHRepository new) }.

	glhImporter := GLPHImporterMock new.
	
	glhImporter commits: {
			(GLHCommit new
				 id: 1;
				 created_at: '09-05-2024' asDate;
					message: 'test';
				 additions: 7;
				 commitCreator: user;
				 deletions: 5).
			(GLHCommit new
				 id: 2;
				 created_at: '09-05-2024' asDate;
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
		                setPeriodSince: '09-04-2024' until: '09-04-2024';
		                over: Week.
		
	"When"
	result := commitLinkWithTicket calculate.
	
	"Then"
	self assert: result equals: 1.
]
