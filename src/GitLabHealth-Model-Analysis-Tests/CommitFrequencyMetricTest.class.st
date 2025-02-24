"
A CommitFrequencyMetricTest is a test class for testing the behavior of CommitFrequencyMetric
"
Class {
	#name : #CommitFrequencyMetricTest,
	#superclass : #UserMetricTest,
	#instVars : [
		'user2'
	],
	#category : #'GitLabHealth-Model-Analysis-Tests'
}

{ #category : #running }
CommitFrequencyMetricTest >> setUp [

	super setUp.
	user2 := GLHUser new
		        username: 'user2';
		        contributedProjects: { project1 }.
]

{ #category : #tests }
CommitFrequencyMetricTest >> testCalculate [

	| glhImporter result commitFrequency |

	glhImporter := GLPHImporterMock new.

	glhImporter commits: {
			(GLHCommit new
				 id: 1;
				 repository: project1 repository;
				 created_at: createdAt;
				 additions: 7;
				 commitCreator: user;
				 deletions: 5).
			(GLHCommit new
				 id: 2;
				 repository: project1 repository;
				 created_at: createdAt;
				 additions: 7;
				 commitCreator: user;
				 deletions: 5).
			(GLHCommit new
				 id: 3;
				 repository: project1 repository;
				 created_at: createdAt;
				 additions: 7;
				 commitCreator: user;
				 deletions: 5) }.


	commitFrequency := CommitFrequencyMetric new
		                   user: user;
		                   glhImporter: glhImporter;
		                   setPeriodSince: since until: until;
		                   over: Week.

	"When"
	result := commitFrequency calculate.

	"Then"
	self assert: result equals: 3
]

{ #category : #tests }
CommitFrequencyMetricTest >> testCalculate1CommitByWeek [

	| glhImporter result commitFrequency |

	glhImporter := GLPHImporterMock new.

	glhImporter commits: { 
		(GLHCommit new
				 id: 1;
				 repository: project1 repository;
				 created_at: createdAt;
				 additions: 7;
				 commitCreator: user;
				 deletions: 5).
		(GLHCommit new
				 id: 2;
				 repository: project1 repository;
				 created_at: createdAt + 7 days;
				 additions: 7;
				 commitCreator: user;
				 deletions: 5).
		(GLHCommit new
				 id: 3;
				 repository: project1 repository;
				 created_at: createdAt + 7 days ;
				 additions: 7;
				 commitCreator: user;
				 deletions: 5).
	 }.


	commitFrequency := CommitFrequencyMetric new
		                   user: user;
		                   glhImporter: glhImporter;
		                   setPeriodSince: createdAt asDate until: (createdAt + (7 + 7) days) asDate  ;
		                   over: Week.

	"When"
	result := commitFrequency calculate.

	"Then"
	self assert: result equals: 1
]

{ #category : #tests }
CommitFrequencyMetricTest >> testCalculate1CommitByWeekFromAnotherUser [

	| glhImporter result commitFrequency |
	glhImporter := GLPHImporterMock new.

	glhImporter commits: {
			(GLHCommit new
				 id: 1;
				 repository: project1 repository;
				 created_at: createdAt;
				 additions: 7;
				 commitCreator: user2;
				 deletions: 5).
			(GLHCommit new
				 id: 2;
				 repository: project1 repository;
				 created_at: createdAt + 7 days;
				 additions: 7;
				 commitCreator: user2;
				 deletions: 5).
			(GLHCommit new
				 id: 3;
				 repository: project1 repository;
				 created_at: createdAt + 7 days;
				 additions: 7;
				 commitCreator: user2;
				 deletions: 5) }.


	commitFrequency := CommitFrequencyMetric new
		                   user: user;
		                   glhImporter: glhImporter;
		                   setPeriodSince: createdAt asDate
		                   until: (createdAt + (7 + 7) days) asDate;
		                   over: Week.

	"When"
	result := commitFrequency calculate.

	"Then"
	self assert: result equals: 0
]

{ #category : #tests }
CommitFrequencyMetricTest >> testCalculateDifferentUser [

	| glhImporter result commitFrequency |

	glhImporter := GLPHImporterMock new.

	glhImporter commits: {
			(GLHCommit new
				 id: 1;
				 repository: project1 repository;
				 created_at: createdAt;
				 additions: 7;
				 commitCreator: user2;
				 deletions: 5).
			(GLHCommit new
				 id: 2;
				 repository: project1 repository;
				 created_at: createdAt;
				 additions: 7;
				 commitCreator: user2;
				 deletions: 5).
			(GLHCommit new
				 id: 3;
				 repository: project1 repository;
				 created_at: createdAt;
				 additions: 7;
				 commitCreator: user2;
				 deletions: 5) }.


	commitFrequency := CommitFrequencyMetric new
		                   user: user;
		                   glhImporter: glhImporter;
		                   setPeriodSince: since until: until;
		                   over: Week.

	"When"
	result := commitFrequency calculate.

	"Then"
	self assert: result equals: 0
]

{ #category : #tests }
CommitFrequencyMetricTest >> testCalculateNoCommits [

	| glhImporter result commitFrequency |
	glhImporter := GLPHImporterMock new.


	commitFrequency := CommitFrequencyMetric new
		                   user: user;
		                   glhImporter: glhImporter;
		                   setPeriodSince: since until: until;
		                   over: Week.

	"When"
	result := commitFrequency calculate.

	"Then"
	self assert: result equals: 0
]
