"
An OpenedMergeRequestMetricTest is a test class for testing the behavior of OpenedMergeRequestMetric
"
Class {
	#name : #OpenedMergeRequestMetricTest,
	#superclass : #TestCase,
	#category : #'GitLabHealth-Model-Analysis-Tests'
}

{ #category : #tests }
OpenedMergeRequestMetricTest >> testCalculate [

	| openedMergeRequest result glhImporter user user2|
	"Given"
	user := GLHUser new
		        username: 'user';
				  name: 'user';
		        contributedProjects:
			        { (GLHProject new repository: GLHRepository new) }.
			
	user2 := GLHUser new
		        username: 'user2';
				  name: 'user2';
		        contributedProjects:
			        { (GLHProject new repository: GLHRepository new) }.

	glhImporter := GLPHImporterMock new.
	glhImporter mergeRequests: { (GLPHEMergeRequest new
			 author: user;
			 created_at: '09-05-2024') }.


	openedMergeRequest := OpenedMergeRequestMetric new
		                      user: user;
		                      glhImporter: glhImporter;
		                      setPeriodSince: '09-01-2024'
		                      until: '09-07-2024';
		                      over: Week.

	"When"
	result := openedMergeRequest calculate.

	"Then"
	self assert: result equals: 1
]

{ #category : #tests }
OpenedMergeRequestMetricTest >> testCalculate1OpenedAnd2NotOpenedByUser [

	| openedMergeRequest result glhImporter user user2|
	"Given"
	user := GLHUser new
		        username: 'user';
				  name: 'user';
		        contributedProjects:
			        { (GLHProject new repository: GLHRepository new) }.
			
	user2 := GLHUser new
		        username: 'user2';
				  name: 'user2';
		        contributedProjects:
			        { (GLHProject new repository: GLHRepository new) }.

	glhImporter := GLPHImporterMock new.
	glhImporter mergeRequests: { 
			(GLPHEMergeRequest new
			 author: user2;
			 created_at: '09-02-2024').
			(GLPHEMergeRequest new
			 author: user2;
			 created_at: '09-03-2024').
			(GLPHEMergeRequest new
			 author: user;
			 created_at: '09-03-2024')
			 }.


	openedMergeRequest := OpenedMergeRequestMetric new
		                      user: user;
		                      glhImporter: glhImporter;
		                      setPeriodSince: '09-01-2024'
		                      until: '09-07-2024';
		                      over: Week.

	"When"
	result := openedMergeRequest calculate.

	"Then"
	self assert: result equals: 1
]

{ #category : #tests }
OpenedMergeRequestMetricTest >> testCalculateNoMergeRequests [

	| openedMergeRequest result glhImporter user |
	"Given"
	user := GLHUser new
		        username: 'test';
		        contributedProjects:
			        { (GLHProject new repository: GLHRepository new) }.

	glhImporter := GLPHImporterMock new.


	openedMergeRequest := OpenedMergeRequestMetric new
		                      user: user;
		                      glhImporter: glhImporter;
		                      setPeriodSince: '09-01-2024'
		                      until: '09-07-2024';
		                      over: Week.

	"When"
	result := openedMergeRequest calculate.

	"Then"
	self assert: result equals: 0
]

{ #category : #tests }
OpenedMergeRequestMetricTest >> testCalculateNotOpenedByUser [

	| openedMergeRequest result glhImporter user user2|
	"Given"
	user := GLHUser new
		        username: 'user';
				  name: 'user';
		        contributedProjects:
			        { (GLHProject new repository: GLHRepository new) }.
			
	user2 := GLHUser new
		        username: 'user2';
				  name: 'user2';
		        contributedProjects:
			        { (GLHProject new repository: GLHRepository new) }.

	glhImporter := GLPHImporterMock new.
	glhImporter mergeRequests: { 
			(GLPHEMergeRequest new
			 author: user2;
			 created_at: '09-02-2024').
			(GLPHEMergeRequest new
			 author: user2;
			 created_at: '09-03-2024')
			 }.


	openedMergeRequest := OpenedMergeRequestMetric new
		                      user: user;
		                      glhImporter: glhImporter;
		                      setPeriodSince: '09-01-2024'
		                      until: '09-07-2024';
		                      over: Week.

	"When"
	result := openedMergeRequest calculate.

	"Then"
	self assert: result equals: 0
]
