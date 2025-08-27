"
An ActiveBranchesProjectMetricTest is a test class for testing the behavior of ActiveBranchesProjectMetric
"
Class {
	#name : #ActiveBranchesProjectMetricTest,
	#superclass : #ProjectMetricTest,
	#category : #'GitLabHealth-Model-Analysis-Tests'
}

{ #category : #tests }
ActiveBranchesProjectMetricTest >> testCalculate [

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
	
	metrics := ActiveBranchesProjectMetric new
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
ActiveBranchesProjectMetricTest >> testCalculateDifferentProjects [

	| branchMain branchDevelop user1 glhImporter metrics result|
	glhImporter := GLPHImporterMock new.
	
	user1 := GLHUser new
		         name: 'user1';
		         contributedProjects: {project1}.
	
	branchMain := GLHBranch new 
		name: 'main';
		repository: project2 repository; 
		commits: { GLHCommit new
			commitCreator: user1;
			 created_at: createdAt - 3 weeks;
			 repository: project2 repository }.
	

	branchDevelop := GLHBranch new 
		name: 'develop';
		repository: project2 repository; 
		commits: { GLHCommit new
			commitCreator: user1;
			 created_at: createdAt - 2 weeks;
			 repository: project2 repository }.
	
	metrics := ActiveBranchesProjectMetric new
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
ActiveBranchesProjectMetricTest >> testCalculateNoBranch [

	|  user1 glhImporter metrics result|
	glhImporter := GLPHImporterMock new.
	
	user1 := GLHUser new
		         name: 'user1';
		         contributedProjects: {project1}.
	

	
	metrics := ActiveBranchesProjectMetric new
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
ActiveBranchesProjectMetricTest >> testCalculateTwoActiveBranches [

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
		name: 'develop';
		repository: project1 repository; 
		commits: { GLHCommit new
			commitCreator: user1;
			 created_at: createdAt + 2 minutes;
			 repository: project1 repository }.
	
	metrics := ActiveBranchesProjectMetric new
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
ActiveBranchesProjectMetricTest >> testCalculateZeroActiveBranch [

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
			 created_at: createdAt - 2 weeks;
			 repository: project1 repository }.
	
	metrics := ActiveBranchesProjectMetric new
		                   project: project1;
		                   glhImporter: glhImporter;
		                   setPeriodSince: since until: until;
		                   over: Week.

	"When"
	result := metrics calculate.

	"Then"
	self assert: result equals: 0
	
]
