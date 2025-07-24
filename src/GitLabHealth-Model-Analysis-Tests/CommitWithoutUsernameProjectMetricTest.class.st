"
A CommitWithoutUsernameProjectMetricTest is a test class for testing the behavior of CommitWithoutUsernameProjectMetric
"
Class {
	#name : #CommitWithoutUsernameProjectMetricTest,
	#superclass : #ProjectMetricTest,
	#category : #'GitLabHealth-Model-Analysis-Tests'
}

{ #category : #tests }
CommitWithoutUsernameProjectMetricTest >> testCalculate [

	| user1 user2 glhImporter metrics result|
	glhImporter := GLPHImporterMock new.
	
	user1 := GLHUser new
		         name: 'user1';
		         contributedProjects: {project1}.
	user2 := GLHUser new
		         name: 'user2';
					id: 222;
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
			
	
		metrics := CommitWithoutUsernameProjectMetric new
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
CommitWithoutUsernameProjectMetricTest >> testCalculateAllRealUsers [

	| user1 user2 glhImporter metrics result|
	glhImporter := GLPHImporterMock new.
	
	user1 := GLHUser new
		         name: 'user1';
					id: 111;
		         contributedProjects: {project1}.
	user2 := GLHUser new
		         name: 'user2';
					id: 222;
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
			
	
		metrics := CommitWithoutUsernameProjectMetric new
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
CommitWithoutUsernameProjectMetricTest >> testCalculateNoCommit [

	| user1 user2 glhImporter metrics result|
	glhImporter := GLPHImporterMock new.
	
	user1 := GLHUser new
		         name: 'user1';
					id: 111;
		         contributedProjects: {project1}.
	user2 := GLHUser new
		         name: 'user2';
					id: 222;
		         contributedProjects: {project1}.
		
	
	glhImporter commits: { 
	
			 }.
			
	
		metrics := CommitWithoutUsernameProjectMetric new
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
CommitWithoutUsernameProjectMetricTest >> testCalculateNoRealUser [

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
			
	
		metrics := CommitWithoutUsernameProjectMetric new
		                   project: project1;
		                   glhImporter: glhImporter;
		                   setPeriodSince: since until: until;
		                   over: Week.

	"When"
	result := metrics calculate.

	"Then"
	self assert: result equals: 3
	
]

{ #category : #tests }
CommitWithoutUsernameProjectMetricTest >> testCalculateNoUser [

	| user1 user2 glhImporter metrics result|
	glhImporter := GLPHImporterMock new.
	
	user1 := GLHUser new
		         name: 'user1';
					id: 111;
		         contributedProjects: {project1}.
	user2 := GLHUser new
		         name: 'user2';
					id: 222;
		         contributedProjects: {project1}.
		
	
	glhImporter commits: { 
	(GLHCommit new
			 "commitCreator: user1;"
			 created_at: createdAt;
			 repository: project1 repository).
		(GLHCommit new
			"commitCreator: user1;"
			 created_at: (createdAt + 1 minutes) ;
			 repository: project1 repository).
		(GLHCommit new
			"commitCreator: user2;"
			 created_at: (createdAt + 1 minutes) ;
			 repository: project1 repository).
			 }.
			
	
		metrics := CommitWithoutUsernameProjectMetric new
		                   project: project1;
		                   glhImporter: glhImporter;
		                   setPeriodSince: since until: until;
		                   over: Week.

	"When"
	result := metrics calculate.

	"Then"
	self assert: result equals: 3
	
]
