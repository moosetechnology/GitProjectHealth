"
An InactiveBranchesProjectMetricTest is a test class for testing the behavior of InactiveBranchesProjectMetric
"
Class {
	#name : #InactiveBranchesProjectMetricTest,
	#superclass : #ProjectMetricTest,
	#category : #'GitLabHealth-Model-Analysis-Tests'
}

{ #category : #tests }
InactiveBranchesProjectMetricTest >> testCalculate [

	| branchMain branchDevelop user1 glhImporter metrics result|
	glhImporter := GLPHImporterMock new.
	
	user1 := GLHUser new
		         name: 'user1';
		         contributedProjects: {project1}.
	
	branchMain := GLHBranch new 
		name: 'main';
		repository: project1 repository; 
		commits: { GLHCommit new
			commitCreator: user1;
			 created_at: createdAt - 3 weeks;
			 repository: project1 repository }.
	

	branchDevelop := GLHBranch new 
		name: 'develop';
		repository: project1 repository; 
		commits: { GLHCommit new
			commitCreator: user1;
			 created_at: createdAt;
			 repository: project1 repository }.
	
	metrics := InactiveBranchesProjectMetric new
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
InactiveBranchesProjectMetricTest >> testCalculateDifferentProject [

	| branchMain branchDevelop user1 glhImporter metrics result|
	glhImporter := GLPHImporterMock new.
	
	user1 := GLHUser new
		         name: 'user1';
		         contributedProjects: {project1}.
	
	branchMain := GLHBranch new 
		name: 'main';
		repository: project1 repository; 
		commits: { GLHCommit new
			commitCreator: user1;
			 created_at: createdAt;
			 repository: project1 repository }.
	

	branchDevelop := GLHBranch new 
		name: 'main';
		repository: project2 repository; 
		commits: { GLHCommit new
			commitCreator: user1;
			 created_at: createdAt;
			 repository: project2 repository }.
	
	metrics := InactiveBranchesProjectMetric new
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
InactiveBranchesProjectMetricTest >> testCalculateNoBranch [

	| branchMain branchDevelop user1 glhImporter metrics result|
	glhImporter := GLPHImporterMock new.
	
	user1 := GLHUser new
		         name: 'user1';
		         contributedProjects: {project1}.
	

	
	metrics := InactiveBranchesProjectMetric new
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
InactiveBranchesProjectMetricTest >> testCalculateTwoActiveBranch [

	| branchMain branchDevelop user1 glhImporter metrics result|
	glhImporter := GLPHImporterMock new.
	
	user1 := GLHUser new
		         name: 'user1';
		         contributedProjects: {project1}.
	
	branchMain := GLHBranch new 
		name: 'main';
		repository: project1 repository; 
		commits: { GLHCommit new
			commitCreator: user1;
			 created_at: createdAt ;
			 repository: project1 repository }.
	

	branchDevelop := GLHBranch new 
		name: 'develop';
		repository: project1 repository; 
		commits: { GLHCommit new
			commitCreator: user1;
			 created_at: createdAt ;
			 repository: project1 repository }.
	
	metrics := InactiveBranchesProjectMetric new
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
InactiveBranchesProjectMetricTest >> testCalculateTwoInactiveBranch [

	| branchMain branchDevelop user1 glhImporter metrics result|
	glhImporter := GLPHImporterMock new.
	
	user1 := GLHUser new
		         name: 'user1';
		         contributedProjects: {project1}.
	
	branchMain := GLHBranch new 
		name: 'main';
		repository: project1 repository; 
		commits: { GLHCommit new
			commitCreator: user1;
			 created_at: createdAt - 3 weeks;
			 repository: project1 repository }.
	

	branchDevelop := GLHBranch new 
		name: 'develop';
		repository: project1 repository; 
		commits: { GLHCommit new
			commitCreator: user1;
			 created_at: createdAt - 4 week;
			 repository: project1 repository }.
	
	metrics := InactiveBranchesProjectMetric new
		                   project: project1;
		                   glhImporter: glhImporter;
		                   setPeriodSince: since until: until;
		                   over: Week.

	"When"
	result := metrics calculate.

	"Then"
	self assert: result equals: 2
	
]
