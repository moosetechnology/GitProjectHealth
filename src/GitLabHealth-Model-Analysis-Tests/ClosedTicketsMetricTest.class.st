"
A ClosedTicketsMetricTest is a test class for testing the behavior of ClosedTicketsMetric
"
Class {
	#name : #ClosedTicketsMetricTest,
	#superclass : #UserMetricTest,
	#category : #'GitLabHealth-Model-Analysis-Tests'
}

{ #category : #tests }
ClosedTicketsMetricTest >> testCalculate [

	| result glhImporter closedTicket jiraImporter |
	glhImporter := GLPHImporterMock new.
	glhImporter mergeRequests: { (GLHMergeRequest new
			 author: user;
			 project: project1;
			 created_at: createdAt ;
			 title: '205 feat do something') }.

	jiraImporter := JiraImporterMock new.
	jiraImporter issues: { (JPIssue new key: '205') }.


	closedTicket := ClosedTicketsMetric new
		                user: user;
		                glhImporter: glhImporter;
		                jiraImporter: jiraImporter;
		                setPeriodSince: since until: until;
		                over: Week.

	"When"
	result := closedTicket calculate.

	"Then"
	self assert: result equals: 1
]
