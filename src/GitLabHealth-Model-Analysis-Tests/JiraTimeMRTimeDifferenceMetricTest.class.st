"
A JiraTimeMRTimeDifferenceMetricTest is a test class for testing the behavior of JiraTimeMRTimeDifferenceMetric
"
Class {
	#name : #JiraTimeMRTimeDifferenceMetricTest,
	#superclass : #TestCase,
	#category : #'GitLabHealth-Model-Analysis-Tests'
}

{ #category : #test }
JiraTimeMRTimeDifferenceMetricTest >> testCalculate [

	| result glhImporter user jiraImporter jiraMRDifference |
	"Given"
	user := GLHUser new
		        username: 'test';
		        contributedProjects:
			        { (GLHProject new repository: GLHRepository new) }.

	glhImporter := GLPHImporterMock new.
	glhImporter mergeRequests: { (GLPHEMergeRequest new
			 author: user;
			 created_at: '09-05-2024';
			 merged_at: '09-06-2024';
			 title: '205 feat do something') }.

	jiraImporter := JiraImporterMock new.
	jiraImporter issues: { (JPIssue new key: '205'; timeEstimate: '20') }.


	jiraMRDifference := JiraTimeMRTimeDifferenceMetric new
		                    user: user;
		                    glhImporter: glhImporter;
		                    jiraImporter: jiraImporter;
		                    setPeriodSince: '09-04-2024'
		                    until: '09-04-2024';
		                    over: Week.

	"When"
	result := jiraMRDifference calculate.

	"Then"
	self assert: result equals: 1
]
