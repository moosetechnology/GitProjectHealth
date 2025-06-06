"
A JiraTimeMRTimeDifferenceProjectMetricTest is a test class for testing the behavior of JiraTimeMRTimeDifferenceProjectMetric
"
Class {
	#name : #JiraTimeMRTimeDifferenceProjectMetricTest,
	#superclass : #ProjectMetricTest,
	#category : #'GitLabHealth-Model-Analysis-Tests'
}

{ #category : #tests }
JiraTimeMRTimeDifferenceProjectMetricTest >> testCalculate [

	| result glhImporter jiraImporter jiraMRDifference jiraIssue commitMerged commit1|
	glhImporter := GLPHImporterMock new.
	
	
	commit1 := (GLHCommit new
			 id: 1;
			 created_at: createdAt;
			 committed_date: createdAt;
			 repository: project1 repository;
			 deletions: 5).
			
	commitMerged := (GLHCommit new
			 id: 2;
			 created_at: createdAt + 1 minutes ;
			 committed_date: createdAt + 1 minutes;
			 repository: project1 repository;
			 deletions: 5).
	
	glhImporter mergeRequests: { (GLHMergeRequest new
			 project: project1;
			 created_at: createdAt;
			 merged_at: createdAt + 24 hours;
			 state: #merged;
			 mergedCommit: commitMerged; 
			 title: '[TI-205] feat do something') }.

	"those commits will be added to the MR with the mock importer"
	glhImporter commits: { commit1 }.



	jiraImporter := JiraImporterMock new.
	jiraIssue := JPIssue new
		             id: 'TI-205';
		             key: 'TI-205';
		             timeEstimate: 25 hours;
		             yourself.
	jiraImporter issues: { jiraIssue }.



	jiraMRDifference := JiraTimeMRTimeDifferenceProjectMetric new
		                    project: project1;
		                    glhImporter: glhImporter;
		                    jiraImporter: jiraImporter;
		                    setPeriodSince: since until: until;
		                    over: Week.


	result := jiraMRDifference calculate.


	self assert: result equals: 1 hours asSeconds
]

{ #category : #tests }
JiraTimeMRTimeDifferenceProjectMetricTest >> testCalculateNoMergeRequests [

	| result glhImporter jiraImporter jiraMRDifference |
	"Given"


	glhImporter := GLPHImporterMock new.

	jiraImporter := JiraImporterMock new.


	jiraMRDifference := JiraTimeMRTimeDifferenceProjectMetric new
		                    project: project1 ;
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
JiraTimeMRTimeDifferenceProjectMetricTest >> testCalculateWithNoEstimatedTime [

	| result glhImporter jiraImporter jiraMRDifference commitMerged commit1 |
	glhImporter := GLPHImporterMock new.


	commit1 := GLHCommit new
		           id: 1;
		           created_at: createdAt;
		           committed_date: createdAt;
		           repository: project1 repository;
		           deletions: 5.

	commitMerged := GLHCommit new
		                id: 2;
		                created_at: createdAt + 1 minutes;
		                committed_date: createdAt + 1 minutes;
		                repository: project1 repository;
		                deletions: 5.

	glhImporter mergeRequests: {
			
			(GLHMergeRequest new
				 project: project1;
				 iid: 2;
				 created_at: createdAt;
				 merged_at: createdAt + 24 hours;
				 state: #merged;
				 mergedCommit: commitMerged;
				 title: '[AZ-123] feat do something') }.


	"those commits will be added to the MR with the mock importer"
	glhImporter commits: { commit1 }.

	jiraImporter := JiraImporterMock new.

	jiraImporter issues: {
			(JPIssue new
				 id: 'AZ-123';
				 key: 'AZ-123';
				 yourself) }.



	jiraMRDifference := JiraTimeMRTimeDifferenceProjectMetric new
		                    project: project1;
		                    glhImporter: glhImporter;
		                    jiraImporter: jiraImporter;
		                    setPeriodSince: since until: until;
		                    over: Week.


	result := jiraMRDifference calculate.


	self assert: result equals: nil
]

{ #category : #tests }
JiraTimeMRTimeDifferenceProjectMetricTest >> testCalculateWithNoEstimatedTimeAndOneTicketWith [

	| result glhImporter jiraImporter jiraMRDifference jiraIssue commitMerged commit1 |
	glhImporter := GLPHImporterMock new.


	commit1 := GLHCommit new
		           id: 1;
		           created_at: createdAt;
		           committed_date: createdAt;
		           repository: project1 repository;
		           deletions: 5.

	commitMerged := GLHCommit new
		                id: 2;
		                created_at: createdAt + 1 minutes;
		                committed_date: createdAt + 1 minutes;
		                repository: project1 repository;
		                deletions: 5.

	glhImporter mergeRequests: { (GLHMergeRequest new
			 project: project1;
			 iid: 1;
			 created_at: createdAt;
			 merged_at: createdAt + 1 hours;
			 state: #merged;
			 mergedCommit: commitMerged;
			 title: '[AZ-654] feat do something').
			
			(GLHMergeRequest new
			 project: project1;
			 iid: 2;
			 created_at: createdAt;
			 merged_at: createdAt + 24 hours;
			 state: #merged;
			 mergedCommit: commitMerged;
			 title: '[AZ-123] feat do something')
			
			 }.


	"those commits will be added to the MR with the mock importer"
	glhImporter commits: { commit1 }.

	jiraImporter := JiraImporterMock new.
	jiraIssue := JPIssue new
		             id: 'AZ-654';
		             key: 'AZ-654';
		             yourself.
	jiraImporter issues: { (JPIssue new
		             id: 'AZ-654';
		             key: 'AZ-654';
						 timeEstimate: 2 hours;
		             yourself). (JPIssue new
		             id: 'AZ-123';
		             key: 'AZ-123';
		             yourself). }.



	jiraMRDifference := JiraTimeMRTimeDifferenceProjectMetric new
		                    project: project1;
		                    glhImporter: glhImporter;
		                    jiraImporter: jiraImporter;
		                    setPeriodSince: since until: until;
		                    over: Week.


	result := jiraMRDifference calculate.


	self assert: result equals: 1 hours asSeconds
]

{ #category : #tests }
JiraTimeMRTimeDifferenceProjectMetricTest >> testCalculateWithNoIssue [

	| result glhImporter jiraImporter jiraMRDifference jiraIssue commitMerged commit1 |
	glhImporter := GLPHImporterMock new.


	commit1 := GLHCommit new
		           id: 1;
		           created_at: createdAt;
		           committed_date: createdAt;
		           repository: project1 repository;
		           deletions: 5.

	commitMerged := GLHCommit new
		                id: 2;
		                created_at: createdAt + 1 minutes;
		                committed_date: createdAt + 1 minutes;
		                repository: project1 repository;
		                deletions: 5.

	glhImporter mergeRequests: { (GLHMergeRequest new
			 project: project1;
			 created_at: createdAt;
			 merged_at: createdAt + 24 hours;
			 state: #merged;
			 mergedCommit: commitMerged;
			 title: 'feat do something') }.


	"those commits will be added to the MR with the mock importer"
	glhImporter commits: { commit1 }.

	jiraImporter := JiraImporterMock new.
	jiraIssue := JPIssue new
		             id: 'AZ-654';
		             key: 'AZ-654';
		             yourself.
	jiraImporter issues: {  }.



	jiraMRDifference := JiraTimeMRTimeDifferenceProjectMetric new
		                    project: project1;
		                    glhImporter: glhImporter;
		                    jiraImporter: jiraImporter;
		                    setPeriodSince: since until: until;
		                    over: Week.


	result := jiraMRDifference calculate.


	self assert: result equals: nil
]
