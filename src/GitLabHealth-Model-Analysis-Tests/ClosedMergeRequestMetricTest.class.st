"
A ClosedMergeRequestMetricTest is a test class for testing the behavior of ClosedMergeRequestMetric
"
Class {
	#name : #ClosedMergeRequestMetricTest,
	#superclass : #TestCase,
	#instVars : [
		'project1',
		'user'
	],
	#category : #'GitLabHealth-Model-Analysis-Tests'
}

{ #category : #running }
ClosedMergeRequestMetricTest >> setUp [ 
		"Given"
	project1 := (GLHProject new repository: GLHRepository new; name: 'project1').
	user := GLHUser new
		        username: 'test';
		        contributedProjects:
			        { project1 }.
]

{ #category : #tests }
ClosedMergeRequestMetricTest >> testCalculate [

	| result glhImporter  closedMergeRequestMetric |
	"Given"


	glhImporter := GLPHImporterMock new.
	glhImporter mergeRequests: {
			(GLHMergeRequest new
				 author: user;
				 project: project1;
				 created_at: '2024-09-04T10:24:11.803+02:00' asDateAndTime;
				 closed_at: '2024-09-04T11:24:11.803+02:00' asDateAndTime;
				 merged_at: nil;
				 state: 'closed').
			(GLHMergeRequest new
				 author: user;
				 project: project1;
				 created_at: '2024-09-04T12:24:11.803+02:00' asDateAndTime;
				 closed_at: '2024-09-04T13:24:11.803+02:00' asDateAndTime;
				 merged_at: nil;
				 state: 'closed') }.


	closedMergeRequestMetric := ClosedMergeRequestMetric new
		                            user: user;
		                            glhImporter: glhImporter;
		                            setPeriodSince: '2024-09-04'
		                            until: '2024-09-05';
		                            over: Week.

	"When"
	result := closedMergeRequestMetric calculate.

	"Then"
	self assert: result equals: 2
]

{ #category : #tests }
ClosedMergeRequestMetricTest >> testCalculate1MRinPeriod2Outside [

	| result glhImporter closedMergeRequestMetric |


	glhImporter := GLPHImporterMock new.
	glhImporter mergeRequests: {
			(GLHMergeRequest new
				 author: user;
				 project: project1;
				 created_at: '2024-09-04T10:24:11.803+02:00' asDateAndTime;
				 closed_at: '2024-09-04T11:24:11.803+02:00' asDateAndTime;
				 state: 'closed').
			(GLHMergeRequest new
				 author: user;
				 project: project1;
				 created_at: '2024-09-04T12:24:11.803+02:00' asDateAndTime;
				 closed_at: '2024-09-04T13:24:11.803+02:00' asDateAndTime;
				 state: 'closed').
			(GLHMergeRequest new
				 author: user;
				 project: project1;
				 created_at: '2024-08-01T12:24:11.803+02:00' asDateAndTime;
				 closed_at: '2024-08-01T13:24:11.803+02:00' asDateAndTime;
				 state: 'closed') }.


	closedMergeRequestMetric := ClosedMergeRequestMetric new
		                            user: user;
		                            glhImporter: glhImporter;
		                            setPeriodSince: '2024-08-01'
		                            until: '2024-08-02';
		                            over: Week.

	"When"
	result := closedMergeRequestMetric calculate.

	"Then"
	self assert: result equals: 1
]

{ #category : #tests }
ClosedMergeRequestMetricTest >> testCalculate3MR [

	| result glhImporter closedMergeRequestMetric |


	glhImporter := GLPHImporterMock new.
	glhImporter mergeRequests: {
			(GLHMergeRequest new
				 author: user;
				 project: project1;
				 created_at: '2024-09-04T10:24:11.803+02:00' asDateAndTime;
				 closed_at: '2024-09-04T11:24:11.803+02:00' asDateAndTime;
				 state: 'closed').
			(GLHMergeRequest new
				 author: user;
				 project: project1;
				 created_at: '2024-09-04T12:24:11.803+02:00' asDateAndTime;
				 closed_at: '2024-09-04T13:24:11.803+02:00' asDateAndTime;
				 state: 'closed').
			(GLHMergeRequest new
				 author: user;
				 project: project1;
				 created_at: '2024-09-04T15:24:11.803+02:00' asDateAndTime;
				 closed_at: '2024-09-04T16:24:11.803+02:00' asDateAndTime;
				 state: 'closed').
			}.


	closedMergeRequestMetric := ClosedMergeRequestMetric new
		                            user: user;
		                            glhImporter: glhImporter;
		                            setPeriodSince: '2024-09-03'
		                            until: '2024-09-03';
		                            over: Week.

	"When"
	result := closedMergeRequestMetric calculate.

	"Then"
	self assert: result equals: 3
]

{ #category : #tests }
ClosedMergeRequestMetricTest >> testCalculate3MRClosed2Opened [

	| result glhImporter closedMergeRequestMetric |


	glhImporter := GLPHImporterMock new.
	glhImporter mergeRequests: {
			(GLHMergeRequest new
				 author: user;
				 project: project1;
				 created_at: '2024-09-04T10:24:11.803+02:00' asDateAndTime;
				 closed_at: '2024-09-04T11:24:11.803+02:00' asDateAndTime;
				 state: 'closed').
			(GLHMergeRequest new
				 author: user;
				 project: project1;
				 created_at: '2024-09-04T12:24:11.803+02:00' asDateAndTime;
				 closed_at: '2024-09-04T13:24:11.803+02:00' asDateAndTime;
				 state: 'closed').
			(GLHMergeRequest new
				 author: user;
				 project: project1;
				 created_at: '2024-09-04T15:24:11.803+02:00' asDateAndTime;
				 closed_at: '2024-09-04T16:24:11.803+02:00' asDateAndTime;
				 state: 'closed').
			(GLHMergeRequest new
				 author: user;
				 project: project1;
				 created_at: '2024-09-04T10:24:11.803+02:00' asDateAndTime;
				 state: 'opened').
			(GLHMergeRequest new
				 author: user;
				 project: project1;
				 created_at: '2024-09-04T11:24:11.803+02:00' asDateAndTime;
				 state: 'opened') }.


	closedMergeRequestMetric := ClosedMergeRequestMetric new
		                            user: user;
		                            glhImporter: glhImporter;
		                            setPeriodSince: '09-04-2024'
		                            until: '09-05-2024';
		                            over: Week.

	"When"
	result := closedMergeRequestMetric calculate.

	"Then"
	self assert: result equals: 3
]

{ #category : #tests }
ClosedMergeRequestMetricTest >> testCalculateNoClosedMR [

	| result glhImporter closedMergeRequestMetric |
	"Given"


	glhImporter := GLPHImporterMock new.
	glhImporter mergeRequests: {
			(GLHMergeRequest new
				 author: user;
				 created_at: '2024-09-04T10:24:11.803+02:00' asDateAndTime;
				 state: 'opened').
			(GLHMergeRequest new
				 author: user;
				 created_at: '2024-09-04T11:24:11.803+02:00' asDateAndTime;
				 state: 'opened').
			(GLHMergeRequest new
				 author: user;
				 created_at: '2024-09-04T10:24:11.803+02:00' asDateAndTime;
				 state: 'opened').
			(GLHMergeRequest new
				 author: user;
				 created_at: '2024-09-04T11:24:11.803+02:00' asDateAndTime;
				 state: 'opened').
			(GLHMergeRequest new
				 author: user;
				 created_at: '2024-09-04T10:24:11.803+02:00' asDateAndTime;
				 state: 'opened').
			(GLHMergeRequest new
				 author: user;
				 created_at: '2024-09-04T11:24:11.803+02:00' asDateAndTime;
				 state: 'opened') }.


	closedMergeRequestMetric := ClosedMergeRequestMetric new
		                            user: user;
		                            glhImporter: glhImporter;
		                            setPeriodSince: '2024-09-04'
		                            until: '2024-09-05';
		                            over: Week.

	"When"
	result := closedMergeRequestMetric calculate.

	"Then"
	self assert: result equals: 0
]

{ #category : #tests }
ClosedMergeRequestMetricTest >> testCalculateNoMergeRequests [

	| result glhImporter closedMergeRequestMetric |
	"Given"


	glhImporter := GLPHImporterMock new.

	closedMergeRequestMetric := ClosedMergeRequestMetric new
		                            user: user;
		                            glhImporter: glhImporter;
		                            setPeriodSince: '2024-09-04'
		                            until: '2024-09-04';
		                            over: Week.

	"When"
	result := closedMergeRequestMetric calculate.

	"Then"
	self assert: result equals: 0
]

{ #category : #tests }
ClosedMergeRequestMetricTest >> testCalculateOutSidePeriod [

	| result glhImporter closedMergeRequestMetric |
	"Given"


	glhImporter := GLPHImporterMock new.
	glhImporter mergeRequests: {
			(GLHMergeRequest new
				 author: user;
				 created_at: '2024-09-04T10:24:11.803+02:00' asDateAndTime;
				 closed_at: '2024-09-04T11:24:11.803+02:00' asDateAndTime;
				 state: 'closed').
			(GLHMergeRequest new
				 author: user;
				 created_at: '2024-09-04T12:24:11.803+02:00' asDateAndTime;
				 closed_at: '2024-09-04T13:24:11.803+02:00' asDateAndTime;
				 state: 'closed').
			}.


	closedMergeRequestMetric := ClosedMergeRequestMetric new
		                            user: user;
		                            glhImporter: glhImporter;
		                            setPeriodSince: '08-01-2024'
		                            until: '08-05-2024';
		                            over: Week.

	"When"
	result := closedMergeRequestMetric calculate.

	"Then"
	self assert: result equals: 0
]
