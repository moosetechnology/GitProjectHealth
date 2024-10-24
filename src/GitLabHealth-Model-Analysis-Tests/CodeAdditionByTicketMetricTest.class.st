"
A CodeAdditionByTicketMetricTest is a test class for testing the behavior of CodeAdditionByTicketMetric
"
Class {
	#name : 'CodeAdditionByTicketMetricTest',
	#superclass : 'TestCase',
	#category : 'GitLabHealth-Model-Analysis-Tests',
	#package : 'GitLabHealth-Model-Analysis-Tests'
}

{ #category : 'tests' }
CodeAdditionByTicketMetricTest >> testCalculate [

	| result glhImporter user jiraImporter codeAddition |
	"Given"
	user := GLHUser new
		        username: 'test';
		        contributedProjects:
			        { (GLHProject new repository: GLHRepository new) }.

	glhImporter := GLPHImporterMock new.
	glhImporter mergeRequests: { (GLHMergeRequest new
			 author: user;
			 created_at: '09-05-2024';
			 merged_at: '09-06-2024' asDate;
			 title: '205 feat do something') }.

	glhImporter commits: { (GLHCommit new
			 id: 1;
			 created_at: '09-05-2024' asDate;
			 additions: 7;
			 commitCreator: user;
			 deletions: 5). (GLHCommit new
			 id: 2;
			 created_at: '09-05-2024' asDate;
			 additions: 3;
			 commitCreator: user;
			 deletions: 5) }.

	jiraImporter := JiraImporterMock new.
	jiraImporter issues: { (JPIssue new
			 key: '205';
			 timeEstimate: 25 hours asDuration) }.


	codeAddition := CodeAdditionByTicketMetric new
		                user: user;
		                glhImporter: glhImporter;
		                jiraImporter: jiraImporter;
		                setPeriodSince: '09-04-2024' until: '09-04-2024';
		                over: Week.

	"When"
	result := codeAddition calculate.

	"Then"
	self assert: result equals: 10
]

{ #category : 'tests' }
CodeAdditionByTicketMetricTest >> testCalculateNoCommits [

	| result glhImporter user jiraImporter codeAddition |
	"Given"
	user := GLHUser new
		        username: 'test';
		        contributedProjects:
			        { (GLHProject new repository: GLHRepository new) }.

	glhImporter := GLPHImporterMock new.
	glhImporter mergeRequests: { (GLHMergeRequest new
			 author: user;
			 created_at: '09-05-2024';
			 merged_at: '09-06-2024' asDate;
			 title: '205 feat do something') }.


	jiraImporter := JiraImporterMock new.
	jiraImporter issues: { (JPIssue new
			 key: '205';
			 timeEstimate: 25 hours asDuration) }.


	codeAddition := CodeAdditionByTicketMetric new
		                user: user;
		                glhImporter: glhImporter;
		                jiraImporter: jiraImporter;
		                setPeriodSince: '09-04-2024' until: '09-04-2024';
		                over: Week.

	"When"
	result := codeAddition calculate.

	"Then"
	self assert: result equals: 0
]

{ #category : 'tests' }
CodeAdditionByTicketMetricTest >> testCalculateNoMergeRequests [

	| result glhImporter user jiraImporter codeAddition |
	"Given"
	user := GLHUser new
		        username: 'test';
		        contributedProjects:
			        { (GLHProject new repository: GLHRepository new) }.

	glhImporter := GLPHImporterMock new.
	
	jiraImporter := JiraImporterMock new.
	jiraImporter issues: { (JPIssue new
			 key: '205';
			 timeEstimate: 25 hours asDuration) }.


	codeAddition := CodeAdditionByTicketMetric new
		                user: user;
		                glhImporter: glhImporter;
		                jiraImporter: jiraImporter;
		                setPeriodSince: '09-04-2024' until: '09-04-2024';
		                over: Week.

	"When"
	result := codeAddition calculate.

	"Then"
	self assert: result equals: 0
]
