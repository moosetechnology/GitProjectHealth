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

	| glhImporter result contributedProject |
	"Given"
	glhImporter := GLPHImporterMock new.
	glhImporter commits: {
			(GLHCommit new
				 id: 1;
				 created_at: createdAt ;
				 committed_date: createdAt ;
				 commitCreator: user;
				 repository: project1 repository).
			(GLHCommit new
				 id: 2;
				 created_at: createdAt ;
				 committed_date: createdAt ;
				 commitCreator: user;
				 repository: project1 repository) }.


	contributedProject := ContributedProjectMetric new
		                      user: user;
		                      glhImporter: glhImporter;
		                      setPeriodSince: since
		                      until: until;
		                      over: Week.

	"When"
	result := contributedProject calculate.

	"Then"
	self assert: result equals: 1
]

{ #category : #tests }
ContributedProjectMetricTest >> testCalculateNoCommits [

	| glhImporter result contributedProject |
	glhImporter := GLPHImporterMock new.


	contributedProject := ContributedProjectMetric new
		                      user: user;
		                      glhImporter: glhImporter;
		                      setPeriodSince: since
		                      until: until;
		                      over: Week.

	"When"
	result := contributedProject calculate.

	"Then"
	self assert: result equals: 0
]
