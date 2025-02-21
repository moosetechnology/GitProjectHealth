"
A ClosedTicketsMetricTest is a test class for testing the behavior of ClosedTicketsMetric
"
Class {
	#name : #ClosedTicketsMetricTest,
	#superclass : #TestCase,
	#instVars : [
		'project1',
		'user'
	],
	#category : #'GitLabHealth-Model-Analysis-Tests'
}

{ #category : #running }
ClosedTicketsMetricTest >> setUp [

	project1 := GLHProject new
		            repository: GLHRepository new;
		            name: 'project1'.
	user := GLHUser new
		        username: 'test';
		        contributedProjects: { project1 }
]

{ #category : #tests }
ClosedTicketsMetricTest >> testCalculate [

	| result glhImporter  closedTicket jiraImporter |


	glhImporter := GLPHImporterMock new.
	glhImporter mergeRequests: { (GLHMergeRequest new
			 author: user;
			 project: project1;
			 created_at: '2024-09-05T10:24:11.803+02:00' asDateAndTime;
			 title: '205 feat do something') }.

	jiraImporter := JiraImporterMock new.
	jiraImporter issues: { (JPIssue new key: '205') }.


	closedTicket := ClosedTicketsMetric new
		                user: user;
		                glhImporter: glhImporter;
		                jiraImporter: jiraImporter;
		                setPeriodSince: '09-04-2024' until: '09-05-2024';
		                over: Week.

	"When"
	result := closedTicket calculate.

	"Then"
	self assert: result equals: 1
]
