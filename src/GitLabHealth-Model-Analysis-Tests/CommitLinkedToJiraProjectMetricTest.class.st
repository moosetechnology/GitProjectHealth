"
A MergeRequestLinkedToJiraProjectMetricTest is a test class for testing the behavior of MergeRequestLinkedToJiraProjectMetric
"
Class {
	#name : #CommitLinkedToJiraProjectMetricTest,
	#superclass : #ProjectMetricTest,
	#category : #'GitLabHealth-Model-Analysis-Tests'
}

{ #category : #tests }
CommitLinkedToJiraProjectMetricTest >> testCalculate [

	| result glhImporter jiraImporter commitsLinked jiraIssue commitMerged commit1 |
	glhImporter := GLPHImporterMock new.

	commit1 := GLHCommit new
		           id: 1;
		           message: '[TI-202] hello world';
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
	"those commits will be added to the MR with the mock importer"
	glhImporter commits: { commit1 }.

	jiraImporter := JiraImporterMock new.
	jiraIssue := JPIssue new
		             id: 'TI-202';
		             key: 'TI-202';
		             timeEstimate: 25 hours;
		             yourself.
	jiraImporter issues: { jiraIssue }.

	commitsLinked := CommitLinkedToJiraProjectMetric new
		                    project: project1;
		                    glhImporter: glhImporter;
		                    jiraImporter: jiraImporter;
		                    setPeriodSince: since until: until;
		                    over: Week.

	result := commitsLinked calculate.

	self assert: result equals: 1
]

{ #category : #tests }
CommitLinkedToJiraProjectMetricTest >> testCalculateSeveral [

	| result glhImporter jiraImporter jiraIssue commitMerged commit1 jiraIssue2 commitMerged2 jiraLinked |
	glhImporter := GLPHImporterMock new.

	commit1 := GLHCommit new
		           id: 1;
		           message: '';
		           created_at: createdAt;
		           committed_date: createdAt;
		           repository: project1 repository;
		           deletions: 5.

	commitMerged := GLHCommit new
		                id: 2;
		                message: 'TI-206 hello';
		                created_at: createdAt + 1 minutes;
		                committed_date: createdAt + 1 minutes;
		                repository: project1 repository;
		                deletions: 5.

	commitMerged2 := GLHCommit new
		                 id: 3;
		                 message: 'TI-205 blip blop';
		                 created_at: createdAt + 1 minutes;
		                 committed_date: createdAt + 1 minutes;
		                 repository: project1 repository;
		                 deletions: 5.

	"those commits will be added to the MR with the mock importer"
	glhImporter commits: {
			commit1.
			commitMerged.
			commitMerged2 }.

	jiraImporter := JiraImporterMock new.
	jiraIssue := JPIssue new
		             id: 'TI-205';
		             key: 'TI-205';
		             timeEstimate: 25 hours;
		             yourself.
	jiraIssue2 := JPIssue new
		              id: 'TI-206';
		              key: 'TI-206';
		              timeEstimate: 25 hours;
		              yourself.
	jiraImporter issues: {
			jiraIssue.
			jiraIssue2 }.

	jiraLinked := CommitLinkedToJiraProjectMetric new
		              project: project1;
		              glhImporter: glhImporter;
		              jiraImporter: jiraImporter;
		              setPeriodSince: since until: until;
		              over: Week.

	result := jiraLinked calculate.

	self assert: result equals: 2
]

{ #category : #tests }
CommitLinkedToJiraProjectMetricTest >> testCalculateSeveralWithOnlyError [

	| result glhImporter jiraImporter jiraIssue commitMerged commit1 jiraIssue2 commitMerged2 jiraLinked |
	glhImporter := GLPHImporterMock new.

	commit1 := GLHCommit new
		           id: 1;
		           message: '';
		           created_at: createdAt;
		           committed_date: createdAt;
		           repository: project1 repository;
		           deletions: 5.

	commitMerged := GLHCommit new
		                id: 2;
		                message: '';
		                created_at: createdAt + 1 minutes;
		                committed_date: createdAt + 1 minutes;
		                repository: project1 repository;
		                deletions: 5.

	commitMerged2 := GLHCommit new
		                 id: 3;
		                 message: '';
		                 created_at: createdAt + 1 minutes;
		                 committed_date: createdAt + 1 minutes;
		                 repository: project1 repository;
		                 deletions: 5.

	"those commits will be added to the MR with the mock importer"
	glhImporter commits: {
			commit1.
			commitMerged.
			commitMerged2 }.

	jiraImporter := JiraImporterMock new.
	jiraIssue := JPIssue new
		             id: 'TI-202';
		             "TI-202 does not exist it is normal here"key: 'TI-202';
		             timeEstimate: 25 hours;
		             yourself.
	jiraIssue2 := JPIssue new
		              id: 'Hello world';
		              key: 'Hello world';
		              timeEstimate: 25 hours;
		              yourself.
	jiraImporter issues: {
			jiraIssue.
			jiraIssue2 }.

	jiraLinked := CommitLinkedToJiraProjectMetric new
		              project: project1;
		              glhImporter: glhImporter;
		              jiraImporter: jiraImporter;
		              setPeriodSince: since until: until;
		              over: Week.

	result := jiraLinked calculate.

	self assert: result equals: 0
]
