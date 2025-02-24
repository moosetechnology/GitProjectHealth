"
An OpenedMergeRequestMetricTest is a test class for testing the behavior of OpenedMergeRequestMetric
"
Class {
	#name : #OpenedMergeRequestMetricTest,
	#superclass : #UserMetricTest,
	#instVars : [
		'user2'
	],
	#category : #'GitLabHealth-Model-Analysis-Tests'
}

{ #category : #running }
OpenedMergeRequestMetricTest >> setUp [

	super setUp.

	
		user2 := GLHUser new
		         username: 'user2';
		         name: 'user2';
		         contributedProjects:
			         { project1 }.
]

{ #category : #tests }
OpenedMergeRequestMetricTest >> testCalculate [

	| openedMergeRequest result glhImporter |
	"Given"


	glhImporter := GLPHImporterMock new.
	glhImporter mergeRequests: { (GLHMergeRequest new
			 author: user;
			 project: project1;
			 state: #opened;
			 created_at: createdAt ) }.


	openedMergeRequest := OpenedMergeRequestMetric new
		                      user: user;
		                      glhImporter: glhImporter;
		                      setPeriodSince: since
		                      until: until;
		                      over: Week.

	"When"
	result := openedMergeRequest calculate.

	"Then"
	self assert: result equals: 1
]

{ #category : #tests }
OpenedMergeRequestMetricTest >> testCalculate1OpenedAnd2NotOpenedByUser [

	| openedMergeRequest result glhImporter  |
	"Given"


	glhImporter := GLPHImporterMock new.
	glhImporter mergeRequests: {
			(GLHMergeRequest new
				 author: user2;
				 state: #opened;
				project: project1;
				 created_at: createdAt ).
			(GLHMergeRequest new
				 author: user2;
				 state: #opened;
				project: project1;
				 created_at: createdAt ).
			(GLHMergeRequest new
				 author: user;
				 state: #opened;
				project: project1;
				 created_at: createdAt ) }.


	openedMergeRequest := OpenedMergeRequestMetric new
		                      user: user;
		                      glhImporter: glhImporter;
		                      setPeriodSince: since
		                      until: until;
		                      over: Week.

	"When"
	result := openedMergeRequest calculate.

	"Then"
	self assert: result equals: 1
]

{ #category : #tests }
OpenedMergeRequestMetricTest >> testCalculateNoMergeRequests [

	| openedMergeRequest result glhImporter  |
	"Given"


	glhImporter := GLPHImporterMock new.


	openedMergeRequest := OpenedMergeRequestMetric new
		                      user: user;
		                      glhImporter: glhImporter;
		                      setPeriodSince: since
		                      until: until;
		                      over: Week.

	"When"
	result := openedMergeRequest calculate.

	"Then"
	self assert: result equals: 0
]

{ #category : #tests }
OpenedMergeRequestMetricTest >> testCalculateNotOpenedByUser [

	| openedMergeRequest result glhImporter |
	"Given"


	glhImporter := GLPHImporterMock new.
	glhImporter mergeRequests: {
			(GLHMergeRequest new
				 author: user2;
				 project: project1;
				 state: #opened;
				 created_at: createdAt ).
			(GLHMergeRequest new
				 author: user2;
				 project: project1;
				 state: #opened;
				 created_at: createdAt ) }.


	openedMergeRequest := OpenedMergeRequestMetric new
		                      user: user;
		                      glhImporter: glhImporter;
		                      setPeriodSince: since
		                      until: until;
		                      over: Week.

	"When"
	result := openedMergeRequest calculate.

	"Then"
	self assert: result equals: 0
]
