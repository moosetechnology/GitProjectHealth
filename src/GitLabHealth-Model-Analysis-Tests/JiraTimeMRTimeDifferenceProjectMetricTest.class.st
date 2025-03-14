"
A JiraTimeMRTimeDifferenceProjectMetricTest is a test class for testing the behavior of JiraTimeMRTimeDifferenceProjectMetric
"
Class {
	#name : #JiraTimeMRTimeDifferenceProjectMetricTest,
	#superclass : #ProjectMetricTest,
	#category : #'GitLabHealth-Model-Analysis-Tests'
}

{ #category : #tests }
JiraTimeMRTimeDifferenceProjectMetricTest >> testCalculate [  
	| result glhImporter jiraImporter jiraMRDifference  jiraIssue |  
  
	glhImporter := GLPHImporterMock new.  
	glhImporter mergeRequests: { (GLHMergeRequest new  
			project:project1;  
			created_at: createdAt;  
			merged_at: createdAt + 24 hours;  
			state: #merged;  
			project: project1;  
			title: '[TI-205] feat do something') }.  

	glhImporter commits: { (GLHCommit new  
			id: 1;  
			created_at: createdAt;  
			committed_date: createdAt;  
			repository: project1 repository;    
			deletions: 5) }.  
 

 
	jiraImporter := JiraImporterMock new.
	jiraIssue := JPIssue new id: 'TI-205'; key: 'TI-205'; timeEstimate: 25 hours ;yourself .  
   jiraImporter issues: { jiraIssue }.



	jiraMRDifference := JiraTimeMRTimeDifferenceProjectMetric new  
		                    project:project1;  
		                    glhImporter: glhImporter;  
		                    jiraImporter: jiraImporter;  
		                    setPeriodSince: since until: until;  
		                    over: Week.  

 
	result := jiraMRDifference calculate.  

	
	self assert: result equals: 1 hours asSeconds.

]
