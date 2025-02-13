"
A ClosedTicketsMetricTest is a test class for testing the behavior of ClosedTicketsMetric
"
Class {
	#name : #ClosedTicketsMetricTest,
	#superclass : #TestCase,
	#category : #'GitLabHealth-Model-Analysis-Tests'
}

{ #category : #tests }
ClosedTicketsMetricTest >> testCalculate [

	| result glhImporter user closedTicket jiraImporter |
	"Given"
	user := GLHUser new
		        username: 'test';
		        contributedProjects:
			        { (GLHProject new repository: GLHRepository new) }.

	glhImporter := GLPHImporterMock new.
	glhImporter mergeRequests: { (GLHMergeRequest new
			 author: user;
			 created_at: '2024-09-05';
			 title: '205 feat do something') }.

	jiraImporter := JiraImporterMock new.
	jiraImporter issues: { (JPIssue new key: '205') }.


	closedTicket := ClosedTicketsMetric new
		                user: user;
		                glhImporter: glhImporter;
		                jiraImporter: jiraImporter;
		                setPeriodSince: '2024-09-04' until: '2024-09-04';
		                over: Week.

	"When"
	result := closedTicket calculate.

	"Then"
	self assert: result equals: 1
]
