"
A ClosedMergeRequestDurationProjectMetricTest is a test class for testing the behavior of ClosedMergeRequestDurationProjectMetric
"
Class {
	#name : #ClosedMergeRequestDurationProjectMetricTest,
	#superclass : #ProjectMetricTest,
	#category : #'GitLabHealth-Model-Analysis-Tests'
}

{ #category : #tests }
ClosedMergeRequestDurationProjectMetricTest >> testCalculate [

	| result glhImporter mergeRequestDuration |
	glhImporter := GLPHImporterMock new.

	glhImporter mergeRequests: {
			(GLHMergeRequest new
				 project: project1;
				 state: 'closed';
				 created_at: (DateAndTime
						  year: 2024
						  month: 09
						  day: 05
						  hour: 00
						  minute: 0
						  second: 0);
				 closed_at: (DateAndTime
						  year: 2024
						  month: 09
						  day: 05
						  hour: 06
						  minute: 0
						  second: 0)) }.


	mergeRequestDuration := ClosedMergeRequestDurationProjectMetric new
		                        project: project1;
		                        glhImporter: glhImporter;
		                        setPeriodSince: since until: until;
		                        over: Week.

	"When"
	result := mergeRequestDuration calculate.

	"Then"
	self assert: result equals: 6 * 60 * 60
]

{ #category : #tests }
ClosedMergeRequestDurationProjectMetricTest >> testCalculate1MRClosedOutsidePeriode [

	| result glhImporter mergeRequestDuration |
	glhImporter := GLPHImporterMock new.

	glhImporter mergeRequests: {
			(GLHMergeRequest new
				 project: project1;
				state: 'closed';
				 created_at: (DateAndTime
						  year: 2023
						  month: 09
						  day: 05
						  hour: 00
						  minute: 0
						  second: 0);
				 closed_at: (DateAndTime
						  year: 2023
						  month: 09
						  day: 05
						  hour: 10
						  minute: 0
						  second: 0)).
			(GLHMergeRequest new
				 project: project1;
				 state: 'closed';
				 created_at: (DateAndTime
						  year: 2024
						  month: 09
						  day: 05
						  hour: 00
						  minute: 0
						  second: 0);
				 closed_at: (DateAndTime
						  year: 2024
						  month: 09
						  day: 05
						  hour: 06
						  minute: 0
						  second: 0)) }.


	mergeRequestDuration := ClosedMergeRequestDurationProjectMetric new
		                        project: project1;
		                        glhImporter: glhImporter;
		                        setPeriodSince: since until: until;
		                        over: Week.

	"When"
	result := mergeRequestDuration calculate.

	"Then"
	self assert: result equals: 6 * 60 * 60
]

{ #category : #tests }
ClosedMergeRequestDurationProjectMetricTest >> testCalculate2ClosedMergRequest1DifferentProject [

	| result glhImporter mergeRequestDuration |
	glhImporter := GLPHImporterMock new.
	
	glhImporter mergeRequests: {
			(GLHMergeRequest new
				 project: project1 ;
				state: 'closed';
				 created_at: (DateAndTime
						  year: 2024
						  month: 09
						  day: 05  
						  hour: 00
						  minute: 0
						  second: 0);
				 closed_at: (DateAndTime
						  year: 2024
						  month: 09
						  day: 05
						  hour: 12
						  minute: 0
						  second: 0)).
						(GLHMergeRequest new
				 project: project1 ;
				 state: 'closed';
				 created_at: (DateAndTime
						  year: 2024
						  month: 09
						  day: 05
						  hour: 00
						  minute: 0
						  second: 0);
				 closed_at: (DateAndTime
						  year: 2024
						  month: 09
						  day: 05
						  hour: 06
						  minute: 0
						  second: 0)).
			(GLHMergeRequest new
				 project: project2;
				state: 'closed';
				 created_at: (DateAndTime
						  year: 2024
						  month: 09
						  day: 05
						  hour: 00
						  minute: 0
						  second: 0);
				closed_at: (DateAndTime
						  year: 2024
						  month: 09
						  day: 05
						  hour: 10
						  minute: 0
						  second: 0)) }.


	mergeRequestDuration := ClosedMergeRequestDurationProjectMetric new 
	                           project: project1 ;
		                        glhImporter: glhImporter;
		                        setPeriodSince: since
		                        until: until;
		                        over: Week.

	"When"
	result := mergeRequestDuration calculate.

	"Then"
	self assert:  result equals: 9 * 60 * 60 
]

{ #category : #tests }
ClosedMergeRequestDurationProjectMetricTest >> testCalculateClosedMergRequestOutOfAnalysePeriode [

	| result glhImporter mergeRequestDuration |
	glhImporter := GLPHImporterMock new.
	
	glhImporter mergeRequests: {
			(GLHMergeRequest new
				 project: project1 ;
				 created_at: (DateAndTime
						  year: 2019
						  month: 08
						  day: 05  
						  hour: 00
						  minute: 0
						  second: 0);
				 closed_at: (DateAndTime
						  year: 2019
						  month: 09
						  day: 05
						  hour: 12
						  minute: 0
						  second: 0)).
						(GLHMergeRequest new
				 project: project1 ;
			 	state: 'closed';
				 created_at: (DateAndTime
						  year: 2024
						  month: 09
						  day: 05
						  hour: 00
						  minute: 0
						  second: 0);
				 closed_at: (DateAndTime
						  year: 2024
						  month: 09
						  day: 05
						  hour: 04
						  minute: 0
						  second: 0)).
			(GLHMergeRequest new
				 project: project1;
				 created_at: (DateAndTime
						  year: 2025
						  month: 02
						  day: 12
						  hour: 00
						  minute: 0
						  second: 0);
				closed_at: (DateAndTime
						  year: 2025
						  month: 03
						  day: 01
						  hour: 10
						  minute: 0
						  second: 0)) }.


	mergeRequestDuration := ClosedMergeRequestDurationProjectMetric new 
	                           project: project1 ;
		                        glhImporter: glhImporter;
		                        setPeriodSince: since
		                        until: until;
		                        over: Week.

	"When"
	result := mergeRequestDuration calculate.

	"Then"
	self assert:  result equals: 4 * 60 * 60 
]

{ #category : #tests }
ClosedMergeRequestDurationProjectMetricTest >> testCalculateClosedMergRequestWithOutClosedAtDate [

	| result glhImporter mergeRequestDuration |
	glhImporter := GLPHImporterMock new.
	
	glhImporter mergeRequests: {
			(GLHMergeRequest new
				 project: project1 ;
				state: 'closed';
				 created_at: (DateAndTime
						  year: 2024
						  month: 09
						  day: 05  
						  hour: 00
						  minute: 0
						  second: 0)). }.


	mergeRequestDuration := ClosedMergeRequestDurationProjectMetric new 
	                           project: project1 ;
		                        glhImporter: glhImporter;
		                        setPeriodSince: since
		                        until: until;
		                        over: Week.

	"When"
	result := mergeRequestDuration calculate.

	"Then"
	self assert:  result equals: nil
]

{ #category : #tests }
ClosedMergeRequestDurationProjectMetricTest >> testCalculateClosedMergRequestWithOutClosedState [

	| result glhImporter mergeRequestDuration |
	glhImporter := GLPHImporterMock new.
	
	glhImporter mergeRequests: {
			(GLHMergeRequest new
				 project: project1 ;
				 created_at: (DateAndTime
						  year: 2024
						  month: 09
						  day: 05  
						  hour: 00
						  minute: 0
						  second: 0);
				 closed_at: (DateAndTime
						  year: 2024
						  month: 09
						  day: 05
						  hour: 12
						  minute: 0
						  second: 0)). }.


	mergeRequestDuration := ClosedMergeRequestDurationProjectMetric new 
	                           project: project1 ;
		                        glhImporter: glhImporter;
		                        setPeriodSince: since
		                        until: until;
		                        over: Week.

	"When"
	result := mergeRequestDuration calculate.

	"Then"
	self assert:  result equals: nil
]

{ #category : #tests }
ClosedMergeRequestDurationProjectMetricTest >> testCalculateNoMergeRequests [

	| result glhImporter mergeRequestDuration |
	glhImporter := GLPHImporterMock new.

	mergeRequestDuration := ClosedMergeRequestDurationProjectMetric new
		                        project: project1 ;
		                        glhImporter: glhImporter;
		                        setPeriodSince: since
		                        until: until;
		                        over: Week.

	"When"
	result := mergeRequestDuration calculate.

	"Then"
	self assert: result equals: nil
]
