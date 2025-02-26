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
						  hour: 10
						  minute: 0
						  second: 0)).
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
						  hour: 06
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
	self assert:  result equals:  8* 60 * 60 
]

{ #category : #tests }
ClosedMergeRequestDurationProjectMetricTest >> testCalculate2ClosedMergRequest1DifferentProject [

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
						  second: 0)).
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
						  hour: 06
						  minute: 0
						  second: 0)).
			(GLHMergeRequest new
				 project: project2;
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
