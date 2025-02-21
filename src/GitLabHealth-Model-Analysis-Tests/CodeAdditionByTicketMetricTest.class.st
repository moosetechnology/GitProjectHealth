"
A CodeAdditionByTicketMetricTest is a test class for testing the behavior of CodeAdditionByTicketMetric
"
Class {
	#name : #CodeAdditionByTicketMetricTest,
	#superclass : #UserMetricTest,
	#category : #'GitLabHealth-Model-Analysis-Tests'
}

{ #category : #running }
CodeAdditionByTicketMetricTest >> setUp [

	project1 := GLHProject new
		            repository: GLHRepository new;
		            name: 'project1'.
	user := GLHUser new
		        username: 'test';
		        contributedProjects: { project1 }
]

{ #category : #tests }
CodeAdditionByTicketMetricTest >> testCalculate [

	| result glhImporter jiraImporter codeAddition |
	glhImporter := GLPHImporterMock new.
	glhImporter mergeRequests: { (GLHMergeRequest new
			 author: user;
			 created_at: '2024-09-05T10:24:11.803+02:00' asDateAndTime;
			 merged_at: '2024-09-05T11:24:11.803+02:00' asDateAndTime;
			 project: project1;
			 state: 'merged';
			 title: '205 feat do something') }.

	glhImporter commits: {
			(GLHCommit new
				 id: 1;
				 repository: project1 repository;
				 created_at: '2024-09-05T10:24:11.803+02:00' asDateAndTime;
				 additions: 7;
				 commitCreator: user;
				 deletions: 5).
			(GLHCommit new
				 id: 2;
				 repository: project1 repository;
				 created_at: '2024-09-05T10:26:11.803+02:00' asDateAndTime;
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
		                setPeriodSince: '2024-09-04' until: '2024-09-04';
		                over: Week.

	"When"
	result := codeAddition calculate.

	"Then"
	self assert: result equals: 10
]

{ #category : #tests }
CodeAdditionByTicketMetricTest >> testCalculateNoCommits [

	| result glhImporter  jiraImporter codeAddition |


	glhImporter := GLPHImporterMock new.
	glhImporter mergeRequests: { (GLHMergeRequest new
			 author: user;
			 created_at: '2024-09-05T10:24:11.803+02:00' asDateAndTime;
			 merged_at: '2024-09-05T11:24:11.803+02:00' asDateAndTime;
			 project: project1;
			 state: 'merged';
			 title: '205 feat do something') }.


	jiraImporter := JiraImporterMock new.
	jiraImporter issues: { (JPIssue new
			 key: '205';
			 timeEstimate: 25 hours asDuration) }.


	codeAddition := CodeAdditionByTicketMetric new
		                user: user;
		                glhImporter: glhImporter;
		                jiraImporter: jiraImporter;
		                setPeriodSince: '2024-09-04' until: '2024-09-05';
		                over: Week.

	"When"
	result := codeAddition calculate.

	"Then"
	self assert: result equals: 0
]

{ #category : #tests }
CodeAdditionByTicketMetricTest >> testCalculateNoMergeRequests [

	| result glhImporter jiraImporter codeAddition |

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
