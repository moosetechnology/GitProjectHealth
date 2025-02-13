"
A ClosedMergeRequestMetricTest is a test class for testing the behavior of ClosedMergeRequestMetric
"
Class {
	#name : #ClosedMergeRequestMetricTest,
	#superclass : #TestCase,
	#category : #'GitLabHealth-Model-Analysis-Tests'
}

{ #category : #tests }
ClosedMergeRequestMetricTest >> testCalculate [

	| result glhImporter user closedMergeRequestMetric |
	"Given"
	user := GLHUser new
		        username: 'test';
		        contributedProjects:
			        { (GLHProject new repository: GLHRepository new) }.

	glhImporter := GLPHImporterMock new.
	glhImporter mergeRequests: {
			(GLHMergeRequest new
				 author: user;
				 created_at: '2024-09-05';
				 merged_at: '2024-09-05';
				 state: 'closed').
			(GLHMergeRequest new
				 author: user;
				 created_at: '2024-09-05';
				 merged_at: nil;
				 state: 'closed') }.


	closedMergeRequestMetric := ClosedMergeRequestMetric new
		                            user: user;
		                            glhImporter: glhImporter;
		                            setPeriodSince: '2024-09-04'
		                            until: '2024-09-04';
		                            over: Week.

	"When"
	result := closedMergeRequestMetric calculate.

	"Then"
	self assert: result equals: 2
]

{ #category : #tests }
ClosedMergeRequestMetricTest >> testCalculate1MRinPeriod2Outside [

	| result glhImporter user closedMergeRequestMetric |
	"Given"
	user := GLHUser new
		        username: 'test';
		        contributedProjects:
			        { (GLHProject new repository: GLHRepository new) }.

	glhImporter := GLPHImporterMock new.
	glhImporter mergeRequests: {
			(GLHMergeRequest new
				 author: user;
				 created_at: '2024-09-05';
				 merged_at: '2024-09-05';
				 state: 'closed').
			(GLHMergeRequest new
				 author: user;
				 created_at: '2024-09-05';
				 merged_at: nil;
				 state: 'closed').
			(GLHMergeRequest new
				 author: user;
				 created_at: '2024-08-01';
				 merged_at: nil;
				 state: 'closed') }.


	closedMergeRequestMetric := ClosedMergeRequestMetric new
		                            user: user;
		                            glhImporter: glhImporter;
		                            setPeriodSince: '2024-07-28'
		                            until: '2024-08-03';
		                            over: Week.

	"When"
	result := closedMergeRequestMetric calculate.

	"Then"
	self assert: result equals: 1
]

{ #category : #tests }
ClosedMergeRequestMetricTest >> testCalculate3MR [

	| result glhImporter user closedMergeRequestMetric |
	"Given"
	user := GLHUser new
		        username: 'test';
		        contributedProjects:
			        { (GLHProject new repository: GLHRepository new) }.

	glhImporter := GLPHImporterMock new.
	glhImporter mergeRequests: {
			(GLHMergeRequest new
				 author: user;
				 created_at: '2024-09-05';
				 merged_at: '2024-09-05';
				 state: 'closed').
			(GLHMergeRequest new
				 author: user;
				 created_at: '2024-09-05';
				 merged_at: nil;
				 state: 'closed').
			(GLHMergeRequest new
				 author: user;
				 created_at: '2024-09-05';
				 merged_at: nil;
				 state: 'closed') }.


	closedMergeRequestMetric := ClosedMergeRequestMetric new
		                            user: user;
		                            glhImporter: glhImporter;
		                            setPeriodSince: '2024-09-04'
		                            until: '2024-09-04';
		                            over: Week.

	"When"
	result := closedMergeRequestMetric calculate.

	"Then"
	self assert: result equals: 3
]

{ #category : #tests }
ClosedMergeRequestMetricTest >> testCalculate3MRClosed2Opened [

	| result glhImporter user closedMergeRequestMetric |
	"Given"
	user := GLHUser new
		        username: 'test';
		        contributedProjects:
			        { (GLHProject new repository: GLHRepository new) }.

	glhImporter := GLPHImporterMock new.
	glhImporter mergeRequests: {
			(GLHMergeRequest new
				 author: user;
				 created_at: '2024-09-05';
				 merged_at: '2024-09-05';
				 state: 'closed').
			(GLHMergeRequest new
				 author: user;
				 created_at: '2024-09-05';
				 merged_at: nil;
				 state: 'closed').
			(GLHMergeRequest new
				 author: user;
				 created_at: '2024-09-05';
				 merged_at: nil;
				 state: 'closed').
			(GLHMergeRequest new
				 author: user;
				 created_at: '2024-09-05';
				 merged_at: nil;
				 state: 'opened').
			(GLHMergeRequest new
				 author: user;
				 created_at: '2024-09-05';
				 merged_at: nil;
				 state: 'opened') }.


	closedMergeRequestMetric := ClosedMergeRequestMetric new
		                            user: user;
		                            glhImporter: glhImporter;
		                            setPeriodSince: '2024-09-04'
		                            until: '2024-09-04';
		                            over: Week.

	"When"
	result := closedMergeRequestMetric calculate.

	"Then"
	self assert: result equals: 3
]

{ #category : #tests }
ClosedMergeRequestMetricTest >> testCalculateNoClosedMR [

	| result glhImporter user closedMergeRequestMetric |
	"Given"
	user := GLHUser new
		        username: 'test';
		        contributedProjects:
			        { (GLHProject new repository: GLHRepository new) }.

	glhImporter := GLPHImporterMock new.
	glhImporter mergeRequests: {
			(GLHMergeRequest new
				 author: user;
				 created_at: '2024-09-05';
				 merged_at: '2024-09-05';
				 state: 'opened').
			(GLHMergeRequest new
				 author: user;
				 created_at: '2024-09-05';
				 merged_at: nil;
				 state: 'opened').
			(GLHMergeRequest new
				 author: user;
				 created_at: '2024-09-05';
				 merged_at: nil;
				 state: 'opened').
			(GLHMergeRequest new
				 author: user;
				 created_at: '2024-09-05';
				 merged_at: nil;
				 state: 'opened').
			(GLHMergeRequest new
				 author: user;
				 created_at: '2024-09-05';
				 merged_at: nil;
				 state: 'opened') }.


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
ClosedMergeRequestMetricTest >> testCalculateNoMergeRequests [

	| result glhImporter user closedMergeRequestMetric |
	"Given"
	user := GLHUser new
		        username: 'test';
		        contributedProjects:
			        { (GLHProject new repository: GLHRepository new) }.

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

	| result glhImporter user closedMergeRequestMetric |
	"Given"
	user := GLHUser new
		        username: 'test';
		        contributedProjects:
			        { (GLHProject new repository: GLHRepository new) }.

	glhImporter := GLPHImporterMock new.
	glhImporter mergeRequests: {
			(GLHMergeRequest new
				 author: user;
				 created_at: '2024-09-05';
				 merged_at: '2024-09-05';
				 state: 'closed').
			(GLHMergeRequest new
				 author: user;
				 created_at: '2024-09-05';
				 merged_at: nil;
				 state: 'closed') }.


	closedMergeRequestMetric := ClosedMergeRequestMetric new
		                            user: user;
		                            glhImporter: glhImporter;
		                            setPeriodSince: '2024-08-01'
		                            until: '2024-08-05';
		                            over: Week.

	"When"
	result := closedMergeRequestMetric calculate.

	"Then"
	self assert: result equals: 0
]
