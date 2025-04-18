"
A MergeRequestLinkedToJiraProjectMetricTest is a test class for testing the behavior of MergeRequestLinkedToJiraProjectMetric
"
Class {
	#name : #MergeRequestLinkedToJiraProjectMetricTest,
	#superclass : #ProjectMetricTest,
	#category : #'GitLabHealth-Model-Analysis-Tests'
}

{ #category : #tests }
MergeRequestLinkedToJiraProjectMetricTest >> testCalculate [

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



	jiraMRDifference := MergeRequestLinkedToJiraProjectMetric new
		                    project: project1;
		                    glhImporter: glhImporter;
		                    jiraImporter: jiraImporter;
		                    setPeriodSince: since until: until;
		                    over: Week.


	result := jiraMRDifference calculate.


	self assert: result equals: 1
]

{ #category : #tests }
MergeRequestLinkedToJiraProjectMetricTest >> testCalculateSeveral [

	| result glhImporter jiraImporter jiraIssue commitMerged commit1 jiraIssue2 commitMerged2 jiraLinked |
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

	commitMerged2 := GLHCommit new
		                 id: 3;
		                 created_at: createdAt + 1 minutes;
		                 committed_date: createdAt + 1 minutes;
		                 repository: project1 repository;
		                 deletions: 5.

	glhImporter mergeRequests: {
			(GLHMergeRequest new
				 project: project1;
				 created_at: createdAt;
				 merged_at: createdAt + 24 hours;
				 state: #merged;
				 mergedCommit: commitMerged;
				 title: '[TI-205] feat do something').
			(GLHMergeRequest new
				 project: project1;
				 created_at: createdAt;
				 merged_at: createdAt + 24 hours;
				 state: #merged;
				 mergedCommit: commitMerged2;
				 title: '[TI-206] feat do something') }.

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



	jiraLinked := MergeRequestLinkedToJiraProjectMetric new
		              project: project1;
		              glhImporter: glhImporter;
		              jiraImporter: jiraImporter;
		              setPeriodSince: since until: until;
		              over: Week.


	result := jiraLinked calculate.


	self assert: result equals: 2
]

{ #category : #tests }
MergeRequestLinkedToJiraProjectMetricTest >> testCalculateSeveralWithOneError [

	| result glhImporter jiraImporter jiraIssue commitMerged commit1 jiraIssue2 commitMerged2 jiraLinked |
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

	commitMerged2 := GLHCommit new
		                 id: 3;
		                 created_at: createdAt + 1 minutes;
		                 committed_date: createdAt + 1 minutes;
		                 repository: project1 repository;
		                 deletions: 5.

	glhImporter mergeRequests: {
			(GLHMergeRequest new
				 project: project1;
				 created_at: createdAt;
				 merged_at: createdAt + 24 hours;
				 state: #merged;
				 mergedCommit: commitMerged;
				 title: '[TI-205] feat do something').
			(GLHMergeRequest new
				 project: project1;
				 created_at: createdAt;
				 merged_at: createdAt + 24 hours;
				 state: #merged;
				 mergedCommit: commitMerged2;
				 title: '[TI-206] feat do something') }.

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
		              id: 'Hello world';
		              key: 'Hello world';
		              timeEstimate: 25 hours;
		              yourself.
	jiraImporter issues: {
			jiraIssue.
			jiraIssue2 }.



	jiraLinked := MergeRequestLinkedToJiraProjectMetric new
		              project: project1;
		              glhImporter: glhImporter;
		              jiraImporter: jiraImporter;
		              setPeriodSince: since until: until;
		              over: Week.


	result := jiraLinked calculate.


	self assert: result equals: 1
]

{ #category : #tests }
MergeRequestLinkedToJiraProjectMetricTest >> testCalculateSeveralWithOnlyError [

	| result glhImporter jiraImporter jiraIssue commitMerged commit1 jiraIssue2 commitMerged2 jiraLinked |
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

	commitMerged2 := GLHCommit new
		                 id: 3;
		                 created_at: createdAt + 1 minutes;
		                 committed_date: createdAt + 1 minutes;
		                 repository: project1 repository;
		                 deletions: 5.

	glhImporter mergeRequests: {
			(GLHMergeRequest new
				 project: project1;
				 created_at: createdAt;
				 merged_at: createdAt + 24 hours;
				 state: #merged;
				 mergedCommit: commitMerged;
				 title: '[TI-205] feat do something').
			(GLHMergeRequest new
				 project: project1;
				 created_at: createdAt;
				 merged_at: createdAt + 24 hours;
				 state: #merged;
				 mergedCommit: commitMerged2;
				 title: '[TI-206] feat do something') }.

	"those commits will be added to the MR with the mock importer"
	glhImporter commits: {
			commit1.
			commitMerged.
			commitMerged2 }.



	jiraImporter := JiraImporterMock new.
	jiraIssue := JPIssue new
		             id: 'TI-202'; "TI-202 does not exist it is normal here"
		             key: 'TI-202';
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



	jiraLinked := MergeRequestLinkedToJiraProjectMetric new
		              project: project1;
		              glhImporter: glhImporter;
		              jiraImporter: jiraImporter;
		              setPeriodSince: since until: until;
		              over: Week.


	result := jiraLinked calculate.


	self assert: result equals: 0
]
