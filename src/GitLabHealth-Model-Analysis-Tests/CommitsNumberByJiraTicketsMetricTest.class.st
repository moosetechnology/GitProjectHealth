"
A CommitsNumberByJiraTicketsMetricTest is a test class for testing the behavior of CommitsNumberByJiraTicketsMetric
"
Class {
	#name : #CommitsNumberByJiraTicketsMetricTest,
	#superclass : #TestCase,
	#category : #'GitLabHealth-Model-Analysis-Tests'
}

{ #category : #tests }
CommitsNumberByJiraTicketsMetricTest >> testCalculate [

	| result glhImporter user jiraImporter commitsNumber |
	"Given"
	user := GLHUser new
		        username: 'test';
		        contributedProjects:
			        { (GLHProject new repository: GLHRepository new) }.

	glhImporter := GLPHImporterMock new.
	glhImporter mergeRequests: { (GLPHEMergeRequest new
			 author: user;
			 created_at: '09-05-2024';
			 merged_at: '09-06-2024' asDate;
			 title: '205 feat do something') }.

	glhImporter commits: { (GLHCommit new
			 id: 1;
			 created_at: '09-05-2024' asDate;
			 commitCreator: user;
			 deletions: 5) }.

	jiraImporter := JiraImporterMock new.
	jiraImporter issues: { (JPIssue new
			 key: '205';
			 timeEstimate: 25 hours asDuration) }.


	commitsNumber := CommitsNumberByJiraTicketsMetric new
		                 userWithId: user;
		                 glhImporter: glhImporter;
		                 jiraImporter: jiraImporter;
		                 setPeriodSince: '09-04-2024' until: '09-04-2024';
		                 over: Week.

	"When"
	result := commitsNumber calculate.

	"Then"
	self assert: result equals: 1
]

{ #category : #tests }
CommitsNumberByJiraTicketsMetricTest >> testCalculateNoCommits [

	| result glhImporter user jiraImporter commitsNumber |
	"Given"
	user := GLHUser new
		        username: 'test';
		        contributedProjects:
			        { (GLHProject new repository: GLHRepository new) }.

	glhImporter := GLPHImporterMock new.
	glhImporter mergeRequests: { (GLPHEMergeRequest new
			 author: user;
			 created_at: '09-05-2024';
			 merged_at: '09-06-2024' asDate;
			 title: '205 feat do something') }.

	jiraImporter := JiraImporterMock new.
	jiraImporter issues: { (JPIssue new
			 key: '205';
			 timeEstimate: 25 hours asDuration) }.


	commitsNumber := CommitsNumberByJiraTicketsMetric new
		                 userWithId: user;
		                 glhImporter: glhImporter;
		                 jiraImporter: jiraImporter;
		                 setPeriodSince: '09-04-2024' until: '09-04-2024';
		                 over: Week.

	"When"
	result := commitsNumber calculate.

	"Then"
	self assert: result equals: 0
]

{ #category : #tests }
CommitsNumberByJiraTicketsMetricTest >> testCalculateNoMergeRequests [

	| result glhImporter user jiraImporter commitsNumber |
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


	commitsNumber := CommitsNumberByJiraTicketsMetric new
		                 userWithId: user;
		                 glhImporter: glhImporter;
		                 jiraImporter: jiraImporter;
		                 setPeriodSince: '09-04-2024' until: '09-04-2024';
		                 over: Week.

	"When"
	result := commitsNumber calculate.

	"Then"
	self assert: result equals: 0
]
