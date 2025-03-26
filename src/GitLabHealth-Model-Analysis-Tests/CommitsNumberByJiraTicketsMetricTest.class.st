"
A CommitsNumberByJiraTicketsMetricTest is a test class for testing the behavior of CommitsNumberByJiraTicketsMetric
"
Class {
	#name : #CommitsNumberByJiraTicketsMetricTest,
	#superclass : #UserMetricTest,
	#category : #'GitLabHealth-Model-Analysis-Tests'
}

{ #category : #tests }
CommitsNumberByJiraTicketsMetricTest >> testCalculate [

	| result glhImporter  jiraImporter commitsNumber |
	"Given"


	glhImporter := GLPHImporterMock new.
	glhImporter mergeRequests: { (GLHMergeRequest new
			 author: user;
			 project: project1;
			 created_at: createdAt ;
			 merged_at: mergedAt ;
			 title: '205 feat do something') }.

	glhImporter commits: { (GLHCommit new
			 id: 1;
			 repository: project1 repository;
			 created_at: createdAt ;
			 commitCreator: user;
			 deletions: 5) }.

	jiraImporter := JiraImporterMock new.
	jiraImporter issues: { (JPIssue new
			 key: '205';
			 timeEstimate: 25 hours asDuration) }.


	commitsNumber := CommitsNumberByJiraTicketsMetric new
		                 user: user;
		                 glhImporter: glhImporter;
		                 jiraImporter: jiraImporter;
		                 setPeriodSince: since until: until ;
		                 over: Week.

	"When"
	result := commitsNumber calculate.

	"Then"
	self assert: result equals: 1
]

{ #category : #tests }
CommitsNumberByJiraTicketsMetricTest >> testCalculateNoCommits [

	| result glhImporter  jiraImporter commitsNumber |
	"Given"


	glhImporter := GLPHImporterMock new.
	glhImporter mergeRequests: { (GLHMergeRequest new
			 author: user;
			 project: project1;
			 created_at: createdAt ;
			 merged_at: mergedAt ;
			 state: #merged;
			 title: '205 feat do something') }.

	jiraImporter := JiraImporterMock new.
	jiraImporter issues: { (JPIssue new
			 key: '205';
			 timeEstimate: 25 hours asDuration) }.


	commitsNumber := CommitsNumberByJiraTicketsMetric new
		                 user: user;
		                 glhImporter: glhImporter;
		                 jiraImporter: jiraImporter;
		                 setPeriodSince: since until: until;
		                 over: Week.

	"When"
	result := commitsNumber calculate.

	"Then"
	self assert: result equals: 0
]

{ #category : #tests }
CommitsNumberByJiraTicketsMetricTest >> testCalculateNoMergeRequests [

	| result glhImporter jiraImporter commitsNumber |
	"Given"


	glhImporter := GLPHImporterMock new.

	jiraImporter := JiraImporterMock new.
	jiraImporter issues: { (JPIssue new
			 key: '205';
			 timeEstimate: 25 hours asDuration) }.


	commitsNumber := CommitsNumberByJiraTicketsMetric new
		                 user: user;
		                 glhImporter: glhImporter;
		                 jiraImporter: jiraImporter;
		                 setPeriodSince: since until: until;
		                 over: Week.

	"When"
	result := commitsNumber calculate.

	"Then"
	self assert: result equals: 0
]
