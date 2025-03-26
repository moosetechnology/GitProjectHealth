"
A JiraTimeMRTimeDifferenceMetricTest is a test class for testing the behavior of JiraTimeMRTimeDifferenceMetric
"
Class {
	#name : #JiraTimeMRTimeDifferenceMetricTest,
	#superclass : #UserMetricTest,
	#category : #'GitLabHealth-Model-Analysis-Tests'
}

{ #category : #tests }
JiraTimeMRTimeDifferenceMetricTest >> testCalculate [

	| result glhImporter jiraImporter jiraMRDifference |
	
	"Given"
	"a Merge request with 24h difference between creation and merge"
	glhImporter := GLPHImporterMock new.
	glhImporter mergeRequests: { (GLHMergeRequest new
			 author: user;
			 created_at: createdAt;
			 merged_at: createdAt + 24 hours;
			 state: #merged;
			 project: project1;
			 title: '205 feat do something') }.

	glhImporter commits: { (GLHCommit new
			 id: 1;
			 created_at: createdAt;
			 committed_date: createdAt;
			 repository: project1 repository;
			 commitCreator: user;
			 deletions: 5) }.
	
	"and a Jira ticket estimated at 25 hours"
	jiraImporter := JiraImporterMock new.
	jiraImporter issues: { (JPIssue new
			 key: '205';
			 timeEstimate: 25 hours asDuration) }.


	jiraMRDifference := JiraTimeMRTimeDifferenceMetric new
		                    user: user;
		                    glhImporter: glhImporter;
		                    jiraImporter: jiraImporter;
		                    setPeriodSince: since until: until;
		                    over: Week.

	"When"
	result := jiraMRDifference calculate.

	"Then"
	"the time difference must be 1h "
	self assert: result equals: 1 hours asSeconds
]

{ #category : #tests }
JiraTimeMRTimeDifferenceMetricTest >> testCalculate2PeriodWith1EmptyPeriod [

	| result glhImporter jiraImporter jiraMRDifference |
	"Given"
	glhImporter := GLPHImporterMock new.
	glhImporter mergeRequests: { (GLHMergeRequest new
			 author: user;
			 project: project1;
			 state: #merged;
			 created_at: createdAt;
			 merged_at: createdAt + 24 hours;
			 title: '205 feat do something') }.

	glhImporter commits: { (GLHCommit new
			 id: 1;
			 repository: project1 repository;
			 created_at: createdAt;
			 commitCreator: user;
			 deletions: 5) }.

	jiraImporter := JiraImporterMock new.
	jiraImporter issues: { (JPIssue new
			 key: '205';
			 timeEstimate: 25 hours asDuration) }.


	"period correspond to 2 weeks"
	jiraMRDifference := JiraTimeMRTimeDifferenceMetric new
		                    user: user;
		                    glhImporter: glhImporter;
		                    jiraImporter: jiraImporter;
		                    setPeriodSince: '2024-09-01'
		                    until: '2024-09-09';
		                   over: Week.

	"When"
	result := jiraMRDifference calculate.

	"Then"
	"half an hours"
	self assert: result equals: 1 hours / 2 asSeconds "1800"
]

{ #category : #tests }
JiraTimeMRTimeDifferenceMetricTest >> testCalculateNoMergeRequests [

	| result glhImporter jiraImporter jiraMRDifference |
	"Given"


	glhImporter := GLPHImporterMock new.

	jiraImporter := JiraImporterMock new.


	jiraMRDifference := JiraTimeMRTimeDifferenceMetric new
		                    user: user;
		                    glhImporter: glhImporter;
		                    jiraImporter: jiraImporter;
		                    setPeriodSince: since
		                    until: until;
		                    over: Week.

	"When"
	result := jiraMRDifference calculate.

	"Then"
	self assert: result equals: nil
]

{ #category : #tests }
JiraTimeMRTimeDifferenceMetricTest >> testCalculateWithNoEstimatedTime [

	| result glhImporter jiraImporter jiraMRDifference |
	"Given"


	glhImporter := GLPHImporterMock new.
	glhImporter mergeRequests: { (GLHMergeRequest new
			 author: user;
			 created_at: createdAt ;
			 merged_at: mergedAt ;
			 title: '205 feat do something') }.

	glhImporter commits: { (GLHCommit new
			 id: 1;
			 created_at: createdAt ;
			 commitCreator: user;
			 deletions: 5) }.

	jiraImporter := JiraImporterMock new.
	jiraImporter issues: { (JPIssue new key: '205') }.


	jiraMRDifference := JiraTimeMRTimeDifferenceMetric new
		                    user: user;
		                    glhImporter: glhImporter;
		                    jiraImporter: jiraImporter;
		                    setPeriodSince: since
		                    until: until;
		                    over: Week.

	"When"
	result := jiraMRDifference calculate.

	"Then"
	self assert: result equals: nil
]

{ #category : #tests }
JiraTimeMRTimeDifferenceMetricTest >> testCalculateWithTimeOriginalEstimateAndNoTimeEstimate [

	| result glhImporter jiraImporter jiraMRDifference |
	"Given"

	glhImporter := GLPHImporterMock new.
	glhImporter mergeRequests: { (GLHMergeRequest new
			 author: user;
			 project: project1;
			 created_at: createdAt ;
			 merged_at: (createdAt + 24 hours);
			 state: #merged;
			 title: '205 feat do something') }.

	glhImporter commits: { (GLHCommit new
			 id: 1;
			 created_at: createdAt ;
			 committed_date: createdAt ;
			 repository: project1 repository ;
			 commitCreator: user;
			 deletions: 5) }.

	jiraImporter := JiraImporterMock new.
	jiraImporter issues: { (JPIssue new
			 key: '205';
			 timeEstimate: nil;
			 timeOriginalEstimate: 25 hours asDuration) }.

	jiraMRDifference := JiraTimeMRTimeDifferenceMetric new
		                    user: user;
		                    glhImporter: glhImporter;
		                    jiraImporter: jiraImporter;
		                    setPeriodSince: since
		                    until: until;
		                    over: Week.

	"When"
	result := jiraMRDifference calculate.

	"Then"
	self assert: result equals: 1 hours asSeconds
]
