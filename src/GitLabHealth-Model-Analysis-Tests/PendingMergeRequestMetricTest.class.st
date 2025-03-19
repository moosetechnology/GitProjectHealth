"
A PendingMergeRequestMetricTest is a test class for testing the behavior of PendingMergeRequestMetric
"
Class {
	#name : #PendingMergeRequestMetricTest,
	#superclass : #UserMetricTest,
	#instVars : [
		'user2'
	],
	#category : #'GitLabHealth-Model-Analysis-Tests'
}

{ #category : #running }
PendingMergeRequestMetricTest >> setUp [

	super setUp.

	user2 := GLHUser new
		         username: 'user2';
		         name: 'user2';
		         contributedProjects:
			         { project1 }
]

{ #category : #test }
PendingMergeRequestMetricTest >> testCalculate [

	| result glhImporter mergedMergeRequestPending |
	"Given"
	glhImporter := GLPHImporterMock new.
	glhImporter mergeRequests: { (GLHMergeRequest new
			 author: user;
			 merge_user: user;
			 project: project1;
			 created_at: (DateAndTime
					  year: 2024
					  month: 09
					  day: 05
					  hour: 00
					  minute: 0
					  second: 0);
			 state: 'opened';
			 merged_at: nil) }.


	mergedMergeRequestPending := PendingMergeRequestMetric new
		                             user: user;
		                             glhImporter: glhImporter;
		                             setPeriodSince: since
		                             until: until;
		                             over: Week.

	"When"
	result := mergedMergeRequestPending calculate.

	"Then"
	self assert: result equals: 1
]

{ #category : #test }
PendingMergeRequestMetricTest >> testCalculate1Pending1Closed [

	| result glhImporter mergedMergeRequestPending |
	"Given"


	glhImporter := GLPHImporterMock new.
	glhImporter mergeRequests: {
			(GLHMergeRequest new
				 author: user;
				 project: project1 ;
				 created_at: (DateAndTime
						  year: 2024
						  month: 09
						  day: 05
						  hour: 00
						  minute: 0
						  second: 0);
				 state: 'opened';
				 merged_at: nil).
			(GLHMergeRequest new
				 author: user;
				 project: project1 ;
				 created_at: (DateAndTime
						  year: 2024
						  month: 09
						  day: 01
						  hour: 00
						  minute: 0
						  second: 0);
				 state: 'closed';
				 merged_at: (DateAndTime
						  year: 2024
						  month: 09
						  day: 02
						  hour: 00
						  minute: 0
						  second: 0)) }.


	mergedMergeRequestPending := PendingMergeRequestMetric new
		                             user: user;
		                             glhImporter: glhImporter;
		                             setPeriodSince: since
		                             until: until;
		                             over: Week.

	"When"
	result := mergedMergeRequestPending calculate.

	"Then"
	self assert: result equals: 1
]

{ #category : #test }
PendingMergeRequestMetricTest >> testCalculate1PendingByUser [

	| result glhImporter mergedMergeRequestPending  |
	"Given"


	glhImporter := GLPHImporterMock new.
	glhImporter mergeRequests: {
			(GLHMergeRequest new
				 author: user;
				 project: project1;
				 created_at: (DateAndTime
						  year: 2024
						  month: 09
						  day: 05
						  hour: 00
						  minute: 0
						  second: 0);
				 state: 'opened';
				 merged_at: nil).
			(GLHMergeRequest new
				 author: user2;
				 project: project1;
				 created_at: (DateAndTime
						  year: 2024
						  month: 09
						  day: 01
						  hour: 00
						  minute: 0
						  second: 0);
				 state: 'opened';
				 merged_at: nil) }.

	mergedMergeRequestPending := PendingMergeRequestMetric new
		                             user: user;
		                             glhImporter: glhImporter;
		                             setPeriodSince: since
		                             until: until;
		                             over: Week.

	"When"
	result := mergedMergeRequestPending calculate.

	"Then"
	self assert: result equals: 1
]

{ #category : #test }
PendingMergeRequestMetricTest >> testCalculate2Pending [

	| result glhImporter  mergedMergeRequestPending |
	"Given"


	glhImporter := GLPHImporterMock new.
	glhImporter mergeRequests: {
			(GLHMergeRequest new
				 author: user;
				project: project1;
				 created_at: (DateAndTime
						  year: 2024
						  month: 09
						  day: 05
						  hour: 00
						  minute: 0
						  second: 0);
				 state: 'opened';
				 merged_at: nil).
			(GLHMergeRequest new
				 author: user;
				project: project1;
				 created_at: (DateAndTime
						  year: 2024
						  month: 09
						  day: 02
						  hour: 00
						  minute: 0
						  second: 0);
				 state: 'opened';
				 merged_at: nil) }.

	mergedMergeRequestPending := PendingMergeRequestMetric new
		                             user: user;
		                             glhImporter: glhImporter;
		                             setPeriodSince: since
		                             until: until;
		                             over: Week.

	"When"
	result := mergedMergeRequestPending calculate.

	"Then"
	self assert: result equals: 2
]
