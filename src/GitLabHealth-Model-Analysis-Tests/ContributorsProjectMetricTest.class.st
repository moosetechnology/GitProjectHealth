"
A ContributorsProjectMetricTest is a test class for testing the behavior of ContributorsProjectMetric
"
Class {
	#name : #ContributorsProjectMetricTest,
	#superclass : #ProjectMetricTest,
	#category : #'GitLabHealth-Model-Analysis-Tests'
}

{ #category : #tests }
ContributorsProjectMetricTest >> testCalculate [

	| user1 user2 glhImporter metrics result|
	glhImporter := GLPHImporterMock new.
	
	user1 := GLHUser new
		         name: 'user1';
		         contributedProjects: {project1}.
	user2 := GLHUser new
		         name: 'user2';
		         contributedProjects: {project1}.
		
	
	glhImporter commits: { 
	(GLHCommit new
			commitCreator: user1;
			 created_at: createdAt;
			 repository: project1 repository).
		(GLHCommit new
			commitCreator: user1;
			 created_at: (createdAt + 1 minutes) ;
			 repository: project1 repository).
		(GLHCommit new
			commitCreator: user2;
			 created_at: (createdAt + 1 minutes) ;
			 repository: project1 repository).
			 }.
			
	
		metrics := ContributorsProjectMetric new
		                   project: project1;
		                   glhImporter: glhImporter;
		                   setPeriodSince: since until: until;
		                   over: Week.

	"When"
	result := metrics calculate.

	"Then"
	self assert: result equals: 2
	
]

{ #category : #tests }
ContributorsProjectMetricTest >> testCalculate0Contributors [

	| user1 user2 glhImporter metrics result |
	glhImporter := GLPHImporterMock new.

	user1 := GLHUser new
		         name: 'user1';
		         contributedProjects: { project1 }.
	user2 := GLHUser new
		         name: 'user2';
		         contributedProjects: { project1 }.


	glhImporter commits: {
			 }.


	metrics := ContributorsProjectMetric new
		           project: project1;
		           glhImporter: glhImporter;
		           setPeriodSince: since until: until;
		           over: Week.

	"When"
	result := metrics calculate.

	"Then"
	self assert: result equals: 0
]

{ #category : #tests }
ContributorsProjectMetricTest >> testCalculate1ContributorAnd1OutsidePeriod [

	| user1 user2 glhImporter metrics result |
	glhImporter := GLPHImporterMock new.

	user1 := GLHUser new
		         name: 'user1';
		         contributedProjects: { project1 }.
	user2 := GLHUser new
		         name: 'user2';
		         contributedProjects: { project1 }.


	glhImporter commits: {
			(GLHCommit new
				 commitCreator: user1;
				 created_at: createdAt;
				 repository: project1 repository).
			(GLHCommit new
				 commitCreator: user1;
				 created_at: createdAt + 1 minutes;
				 repository: project1 repository).
			(GLHCommit new
				 commitCreator: user2;
				 created_at: (createdAt - 5 years);
				 repository: project1 repository) }.


	metrics := ContributorsProjectMetric new
		           project: project1;
		           glhImporter: glhImporter;
		           setPeriodSince: since until: until;
		           over: Week.

	"When"
	result := metrics calculate.

	"Then"
	self assert: result equals: 1
]

{ #category : #tests }
ContributorsProjectMetricTest >> testCalculateNoContributionInPeriods [

	| user1 user2 glhImporter metrics result |
	glhImporter := GLPHImporterMock new.

	user1 := GLHUser new
		         name: 'user1';
		         contributedProjects: { project1 }.
	user2 := GLHUser new
		         name: 'user2';
		         contributedProjects: { project1 }.


	glhImporter commits: {
			(GLHCommit new
				 commitCreator: user1;
				 created_at: createdAt - 2 years;
				 repository: project1 repository).
			(GLHCommit new
				 commitCreator: user1;
				 created_at: createdAt - 2 years;
				 repository: project1 repository).
			(GLHCommit new
				 commitCreator: user2;
				 created_at: createdAt - 2 years;
				 repository: project1 repository) }.


	metrics := ContributorsProjectMetric new
		           project: project1;
		           glhImporter: glhImporter;
		           setPeriodSince: since until: until;
		           over: Week.

	"When"
	result := metrics calculate.

	"Then"
	self assert: result equals: 0
]

{ #category : #tests }
ContributorsProjectMetricTest >> testCalculateNoContributionInProjects [

	| user1 user2 glhImporter metrics result |
	glhImporter := GLPHImporterMock new.

	user1 := GLHUser new
		         name: 'user1';
		         contributedProjects: { project1 }.
	user2 := GLHUser new
		         name: 'user2';
		         contributedProjects: { project1 }.


	glhImporter commits: {
			(GLHCommit new
				 commitCreator: user1;
				 created_at: createdAt - 2 years;
				 repository: project2 repository).
			(GLHCommit new
				 commitCreator: user1;
				 created_at: createdAt - 2 years;
				 repository: project2 repository).
			(GLHCommit new
				 commitCreator: user2;
				 created_at: createdAt - 2 years;
				 repository: project2 repository) }.


	metrics := ContributorsProjectMetric new
		           project: project1;
		           glhImporter: glhImporter;
		           setPeriodSince: since until: until;
		           over: Week.

	"When"
	result := metrics calculate.

	"Then"
	self assert: result equals: 0
]
