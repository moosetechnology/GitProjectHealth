"
A ContributedProjectMetricTest is a test class for testing the behavior of ContributedProjectMetric
"
Class {
	#name : 'ContributedProjectMetricTest',
	#superclass : 'TestCase',
	#category : 'GitLabHealth-Model-Analysis-Tests',
	#package : 'GitLabHealth-Model-Analysis-Tests'
}

{ #category : 'tests' }
ContributedProjectMetricTest >> testCalculate [

	| user glhImporter result contributedProject project1 repository1 |
	"Given"
	project1 := GLHProject new repository: GLHRepository new.
	repository1 := GLHRepository new project: project1.
	user := GLHUser new
		        username: 'test';
		        contributedProjects: { project1 }.

	glhImporter := GLPHImporterMock new.
	glhImporter commits: {
			(GLHCommit new
				 id: 1;
				 created_at: '04-09-2024';
				 committed_date: '04-09-2024';
				 commitCreator: user;
				 repository: repository1).
			(GLHCommit new
				 id: 2;
				 created_at: '04-09-2024';
				 committed_date: '04-09-2024';
				 commitCreator: user;
				 repository: repository1) }.


	contributedProject := ContributedProjectMetric new
		                      user: user;
		                      glhImporter: glhImporter;
		                      setPeriodSince: '04-09-2024'
		                      until: '04-09-2024';
		                      over: Week.

	"When"
	result := contributedProject calculate.

	"Then"
	self assert: result equals: 1
]

{ #category : 'tests' }
ContributedProjectMetricTest >> testCalculateNoCommits [

	| user glhImporter result contributedProject project1 repository1 |
	"Given"
	project1 := GLHProject new repository: GLHRepository new.
	repository1 := GLHRepository new project: project1.
	user := GLHUser new
		        username: 'test';
		        contributedProjects: { project1 }.

	glhImporter := GLPHImporterMock new.


	contributedProject := ContributedProjectMetric new
		                      user: user;
		                      glhImporter: glhImporter;
		                      setPeriodSince: '04-09-2024'
		                      until: '04-09-2024';
		                      over: Week.

	"When"
	result := contributedProject calculate.

	"Then"
	self assert: result equals: 0
]
