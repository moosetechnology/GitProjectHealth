"
A ClosedMergeRequestMetricTest is a test class for testing the behavior of ClosedMergeRequestMetric
"
Class {
	#name : #ClosedMergeRequestMetricTest,
	#superclass : #UserMetricTest,
	#category : #'GitLabHealth-Model-Analysis-Tests'
}

{ #category : #tests }
ClosedMergeRequestMetricTest >> testCalculate [

	| result glhImporter closedMergeRequestMetric |
	"Given"
	glhImporter := GLPHImporterMock new.
	glhImporter mergeRequests: {
			(GLHMergeRequest new
				 author: user;
				 project: project1;
				 created_at: createdAt ;
				 closed_at: closedAt ;
				 merged_at: nil;
				 state: 'closed').
			(GLHMergeRequest new
				 author: user;
				 project: project1;
				 created_at: createdAt ;
				 closed_at: closedAt ;
				 merged_at: nil;
				 state: 'closed') }.


	closedMergeRequestMetric := ClosedMergeRequestMetric new
		                            user: user;
		                            glhImporter: glhImporter;
		                            setPeriodSince: since
		                            until: until;
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
				 created_at: createdAt ;
				 closed_at: closedAt ;
				 state: 'closed').
			(GLHMergeRequest new
				 author: user;
				 project: project1;
				 created_at: createdAt + 20 days ;
				 closed_at: closedAt + 20 days ;
				 state: 'closed').
			(GLHMergeRequest new
				 author: user;
				 project: project1;
				 created_at: createdAt + 20 days ;
				 closed_at: closedAt + 20 days ;
				 state: 'closed') }.


	closedMergeRequestMetric := ClosedMergeRequestMetric new
		                            user: user;
		                            glhImporter: glhImporter;
		                            setPeriodSince: since
		                            until: until;
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
				 created_at: createdAt ;
				 closed_at: closedAt ;
				 state: 'closed').
			(GLHMergeRequest new
				 author: user;
				 project: project1;
				 created_at: createdAt ;
				 closed_at: closedAt ;
				 state: 'closed').
			(GLHMergeRequest new
				 author: user;
				 project: project1;
				 created_at: createdAt ;
				 closed_at: closedAt ;
				 state: 'closed') }.


	closedMergeRequestMetric := ClosedMergeRequestMetric new
		                            user: user;
		                            glhImporter: glhImporter;
		                            setPeriodSince: since
		                            until: until;
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
				 created_at: createdAt ;
				 closed_at: closedAt ;
				 state: 'closed').
			(GLHMergeRequest new
				 author: user;
				 project: project1;
				 created_at: createdAt ;
				 closed_at: closedAt ;
				 state: 'closed').
			(GLHMergeRequest new
				 author: user;
				 project: project1;
				 created_at: createdAt ;
				 closed_at: closedAt ;
				 state: 'closed').
			(GLHMergeRequest new
				 author: user;
				 project: project1;
				 created_at: createdAt ;
				 state: 'opened').
			(GLHMergeRequest new
				 author: user;
				 project: project1;
				 created_at: createdAt ;
				 state: 'opened') }.


	closedMergeRequestMetric := ClosedMergeRequestMetric new
		                            user: user;
		                            glhImporter: glhImporter;
		                            setPeriodSince: since
		                            until: until;
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
				 created_at: createdAt;
				 state: 'opened').
			(GLHMergeRequest new
				 author: user;
				 created_at: createdAt;
				 state: 'opened').
			(GLHMergeRequest new
				 author: user;
				 created_at: createdAt;
				 state: 'opened').
			(GLHMergeRequest new
				 author: user;
				 created_at: createdAt;
				 state: 'opened').
			(GLHMergeRequest new
				 author: user;
				 created_at: createdAt;
				 state: 'opened').
			(GLHMergeRequest new
				 author: user;
				 created_at: createdAt;
				 state: 'opened') }.


	closedMergeRequestMetric := ClosedMergeRequestMetric new
		                            user: user;
		                            glhImporter: glhImporter;
		                            setPeriodSince: since
		                            until: until;
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
		                            setPeriodSince: since
		                            until: until;
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
				 project: project1;
				 created_at: createdAt + 20 days;
				 closed_at: closedAt + 21 days;
				 state: 'closed').
			(GLHMergeRequest new
				 author: user;
				 project: project1 ;
				 created_at: createdAt + 20 days;
				 closed_at: closedAt + 21 days;
				 state: 'closed') }.


	closedMergeRequestMetric := ClosedMergeRequestMetric new
		                            user: user;
		                            glhImporter: glhImporter;
		                            setPeriodSince: since
		                            until: until;
		                            over: Week.

	"When"
	result := closedMergeRequestMetric calculate.

	"Then"
	self assert: result equals: 0
]
