"
A CodeAdditionByTicketMetricTest is a test class for testing the behavior of CodeAdditionByTicketMetric
"
Class {
	#name : #CodeAdditionByTicketMetricTest,
	#superclass : #UserMetricTest,
	#category : #'GitLabHealth-Model-Analysis-Tests'
}

{ #category : #tests }
CodeAdditionByTicketMetricTest >> testCalculate [

	| result glhImporter jiraImporter codeAddition |
	glhImporter := GLPHImporterMock new.
	glhImporter mergeRequests: { (GLHMergeRequest new
			 author: user;
			 created_at: createdAt ;
			 merged_at: closedAt ;
			 project: project1;
			 state: 'merged';
			 title: '205 feat do something') }.

	glhImporter commits: {
			(GLHCommit new
				 id: 1;
				 repository: project1 repository;
				 created_at: createdAt ;
				 additions: 7;
				 commitCreator: user;
				 deletions: 5).
			(GLHCommit new
				 id: 2;
				 repository: project1 repository;
				 created_at: createdAt ;
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
		                setPeriodSince: since until: until;
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
			 created_at: createdAt ;
			 merged_at: mergedAt ;
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
		                setPeriodSince: since until: until;
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
		                setPeriodSince: since until: until;
		                over: Week.

	"When"
	result := codeAddition calculate.

	"Then"
	self assert: result equals: 0
]
