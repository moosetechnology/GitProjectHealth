"
A JiraTimeMRTimeDifferenceMetricTest is a test class for testing the behavior of JiraTimeMRTimeDifferenceMetric
"
Class {
	#name : #JiraTimeMRTimeDifferenceMetricTest,
	#superclass : #TestCase,
	#category : #'GitLabHealth-Model-Analysis-Tests'
}

{ #category : #tests }
JiraTimeMRTimeDifferenceMetricTest >> testCalculate [

	| result glhImporter user jiraImporter jiraMRDifference |
	"Given"
	user := GLHUser new
		        username: 'test';
		        contributedProjects:
			        { (GLHProject new repository: GLHRepository new) }.

	glhImporter := GLPHImporterMock new.
	glhImporter mergeRequests: { (GLHMergeRequest new
			 author: user;
			 created_at: '2024-09-05';
			 merged_at: '2024-09-06' asDate;
			 title: '205 feat do something') }.

	glhImporter commits: { (GLHCommit new
			 id: 1;
			 created_at: '2024-09-05' asDate;
			 commitCreator: user;
			 deletions: 5) }.

	jiraImporter := JiraImporterMock new.
	jiraImporter issues: { (JPIssue new
			 key: '205';
			 timeEstimate: 25 hours asDuration) }.


	jiraMRDifference := JiraTimeMRTimeDifferenceMetric new
		                    user: user;
		                    glhImporter: glhImporter;
		                    jiraImporter: jiraImporter;
		                    setPeriodSince: '2024-09-04'
		                    until: '2024-09-04';
		                    over: Week.

	"When"
	result := jiraMRDifference calculate.

	"Then"
	self assert: result equals: 1 hours asSeconds
]

{ #category : #tests }
JiraTimeMRTimeDifferenceMetricTest >> testCalculate2PeriodWith1EmptyPeriod [

	| result glhImporter user jiraImporter jiraMRDifference |
	"Given"
	user := GLHUser new
		        username: 'test';
		        contributedProjects:
			        { (GLHProject new repository: GLHRepository new) }.

	glhImporter := GLPHImporterMock new.
	glhImporter mergeRequests: { (GLHMergeRequest new
			 author: user;
			 created_at: '2024-09-05';
			 merged_at: '2024-09-06' asDate;
			 title: '205 feat do something') }.

	glhImporter commits: { (GLHCommit new
			 id: 1;
			 created_at: '2024-09-05' asDate;
			 commitCreator: user;
			 deletions: 5) }.

	jiraImporter := JiraImporterMock new.
	jiraImporter issues: { (JPIssue new
			 key: '205';
			 timeEstimate: 25 hours asDuration) }.


	jiraMRDifference := JiraTimeMRTimeDifferenceMetric new
		                    user: user;
		                    glhImporter: glhImporter;
		                    jiraImporter: jiraImporter;
		                    setPeriodSince: '2024-09-04'
		                    until: '2024-09-09';
		                    over: Week.

	"When"
	result := jiraMRDifference calculate.

	"Then"
	self assert: result equals: 1 hours /2 asSeconds
]

{ #category : #tests }
JiraTimeMRTimeDifferenceMetricTest >> testCalculateNoMergeRequests [

	| result glhImporter user jiraImporter jiraMRDifference |
	"Given"
	user := GLHUser new
		        username: 'test';
		        contributedProjects:
			        { (GLHProject new repository: GLHRepository new) }.

	glhImporter := GLPHImporterMock new.

	jiraImporter := JiraImporterMock new.


	jiraMRDifference := JiraTimeMRTimeDifferenceMetric new
		                    user: user;
		                    glhImporter: glhImporter;
		                    jiraImporter: jiraImporter;
		                    setPeriodSince: '2024-09-04'
		                    until: '2024-09-04';
		                    over: Week.

	"When"
	result := jiraMRDifference calculate.

	"Then"
	self assert: result equals: nil
]

{ #category : #tests }
JiraTimeMRTimeDifferenceMetricTest >> testCalculateWithNoEstimatedTime [

	| result glhImporter user jiraImporter jiraMRDifference |
	"Given"
	user := GLHUser new
		        username: 'test';
		        contributedProjects:
			        { (GLHProject new repository: GLHRepository new) }.

	glhImporter := GLPHImporterMock new.
	glhImporter mergeRequests: { (GLHMergeRequest new
			 author: user;
			 created_at: '2024-09-05';
			 merged_at: '2024-09-06' asDate;
			 title: '205 feat do something') }.

	glhImporter commits: { (GLHCommit new
			 id: 1;
			 created_at: '2024-09-05' asDate;
			 commitCreator: user;
			 deletions: 5) }.

	jiraImporter := JiraImporterMock new.
	jiraImporter issues: { (JPIssue new key: '205') }.


	jiraMRDifference := JiraTimeMRTimeDifferenceMetric new
		                    user: user;
		                    glhImporter: glhImporter;
		                    jiraImporter: jiraImporter;
		                    setPeriodSince: '2024-09-04'
		                    until: '2024-09-04';
		                    over: Week.

	"When"
	result := jiraMRDifference calculate.

	"Then"
	self assert: result equals: nil
]

{ #category : #tests }
JiraTimeMRTimeDifferenceMetricTest >> testCalculateWithTimeOriginalEstimateAndNoTimeEstimate [

	| result glhImporter user jiraImporter jiraMRDifference |
	"Given"
	user := GLHUser new
		        username: 'test';
		        contributedProjects:
			        { (GLHProject new repository: GLHRepository new) }.

	glhImporter := GLPHImporterMock new.
	glhImporter mergeRequests: { (GLHMergeRequest new
			 author: user;
			 created_at: '2024-09-05';
			 merged_at: '2024-09-06' asDate;
			 title: '205 feat do something') }.

	glhImporter commits: { (GLHCommit new
			 id: 1;
			 created_at: '2024-09-05' asDate;
			 commitCreator: user;
			 deletions: 5) }.

	jiraImporter := JiraImporterMock new.
	jiraImporter issues: { (JPIssue new
			 key: '205';
			 timeEstimate: nil; timeOriginalEstimate: 25 hours asDuration)}.


	jiraMRDifference := JiraTimeMRTimeDifferenceMetric new
		                    user: user;
		                    glhImporter: glhImporter;
		                    jiraImporter: jiraImporter;
		                    setPeriodSince: '2024-09-04'
		                    until: '2024-09-04';
		                    over: Week.

	"When"
	result := jiraMRDifference calculate.

	"Then"
	self assert: result equals: 1 hours asSeconds
]
