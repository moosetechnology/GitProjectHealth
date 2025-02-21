"
A ContributedProjectMetricTest is a test class for testing the behavior of ContributedProjectMetric
"
Class {
	#name : #ContributedProjectMetricTest,
	#superclass : #UserMetricTest,
	#category : #'GitLabHealth-Model-Analysis-Tests'
}

{ #category : #tests }
ContributedProjectMetricTest >> testCalculate [

	| glhImporter result contributedProject repository1 |
	"Given"


	glhImporter := GLPHImporterMock new.
	glhImporter commits: {
			(GLHCommit new
				 id: 1;
				 created_at: '04-09-2024';
				 committed_date: '04-09-2024';
				 commitCreator: user;
				 repository: project1 repository ).
			(GLHCommit new
				 id: 2;
				 created_at: '04-09-2024';
				 committed_date: '04-09-2024';
				 commitCreator: user;
				 repository: project1 repository) }.


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

{ #category : #tests }
ContributedProjectMetricTest >> testCalculateNoCommits [

	|  glhImporter result contributedProject  |


	glhImporter := GLPHImporterMock new.


	contributedProject := ContributedProjectMetric new
		                      user: user;
		                      glhImporter: glhImporter;
		                      setPeriodSince: '2024-04-09'
		                      until: '2024-04-09';
		                      over: Week.

	"When"
	result := contributedProject calculate.

	"Then"
	self assert: result equals: 0
]
