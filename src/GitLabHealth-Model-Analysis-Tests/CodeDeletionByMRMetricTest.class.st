"
A CodeDeletionByMRMetricTest is a test class for testing the behavior of CodeDeletionByMRMetric
"
Class {
	#name : 'CodeDeletionByMRMetricTest',
	#superclass : 'TestCase',
	#category : 'GitLabHealth-Model-Analysis-Tests',
	#package : 'GitLabHealth-Model-Analysis-Tests'
}

{ #category : 'tests' }
CodeDeletionByMRMetricTest >> testCalculate [

	| result glhImporter user codeDeletion |
	"Given"
	user := GLHUser new
		        username: 'test';
		        contributedProjects:
			        { (GLHProject new repository: GLHRepository new) }.

	glhImporter := GLPHImporterMock new.
	glhImporter mergeRequests: { (GLHMergeRequest new
			 author: user;
			 created_at: '09-05-2024';
			 merged_at: '09-06-2024' asDate;
			 title: '205 feat do something') }.

	glhImporter commits: {
			(GLHCommit new
				 id: 1;
				 created_at: '09-05-2024' asDate;
				 additions: 7;
				 commitCreator: user;
				 deletions: 5).
			(GLHCommit new
				 id: 2;
				 created_at: '09-05-2024' asDate;
				 additions: 3;
				 commitCreator: user;
				 deletions: 5) }.

	codeDeletion := CodeDeletionByMRMetric new
		                user: user;
		                glhImporter: glhImporter;
		                setPeriodSince: '09-04-2024' until: '09-04-2024';
		                over: Week.

	"When"
	result := codeDeletion calculate.

	"Then"
	self assert: result equals: 10
]

{ #category : 'tests' }
CodeDeletionByMRMetricTest >> testCalculateNoCommits [

	| result glhImporter user codeDeletion |
	"Given"
	user := GLHUser new
		        username: 'test';
		        contributedProjects:
			        { (GLHProject new repository: GLHRepository new) }.

	glhImporter := GLPHImporterMock new.
	glhImporter mergeRequests: { (GLHMergeRequest new
			 author: user;
			 created_at: '09-05-2024';
			 merged_at: '09-06-2024' asDate;
			 title: '205 feat do something') }.

	codeDeletion := CodeDeletionByMRMetric new
		                user: user;
		                glhImporter: glhImporter;
		                setPeriodSince: '09-04-2024' until: '09-04-2024';
		                over: Week.

	"When"
	result := codeDeletion calculate.

	"Then"
	self assert: result equals: 0
]

{ #category : 'tests' }
CodeDeletionByMRMetricTest >> testCalculateNoMergeRequests [

	| result glhImporter user codeDeletion |
	"Given"
	user := GLHUser new
		        username: 'test';
		        contributedProjects:
			        { (GLHProject new repository: GLHRepository new) }.

	glhImporter := GLPHImporterMock new.
	glhImporter mergeRequests: { (GLHMergeRequest new
			 author: user;
			 created_at: '09-05-2024';
			 merged_at: '09-06-2024' asDate;
			 title: '205 feat do something') }.

	codeDeletion := CodeDeletionByMRMetric new
		                user: user;
		                glhImporter: glhImporter;
		                setPeriodSince: '09-04-2024' until: '09-04-2024';
		                over: Week.

	"When"
	result := codeDeletion calculate.

	"Then"
	self assert: result equals: 0
]
