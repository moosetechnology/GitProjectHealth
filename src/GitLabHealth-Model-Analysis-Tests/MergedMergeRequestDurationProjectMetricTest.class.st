"
A ClosedMergeRequestDurationProjectMetricTest is a test class for testing the behavior of ClosedMergeRequestDurationProjectMetric
"
Class {
	#name : #MergedMergeRequestDurationProjectMetricTest,
	#superclass : #ProjectMetricTest,
	#category : #'GitLabHealth-Model-Analysis-Tests'
}

{ #category : #tests }
MergedMergeRequestDurationProjectMetricTest >> testCalculate [

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
				 merged_at: (DateAndTime
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
				 merged_at: (DateAndTime
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
				merged_at: (DateAndTime
						  year: 2024
						  month: 09
						  day: 05
						  hour: 10
						  minute: 0
						  second: 0)) }.


	mergeRequestDuration := MergedMergeRequestDurationProjectMetric new 
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
MergedMergeRequestDurationProjectMetricTest >> testCalculateMergeRequestOutOfAnalysePeriode [

	| result glhImporter mergeRequestDuration |
	glhImporter := GLPHImporterMock new.

	glhImporter mergeRequests: {
			(GLHMergeRequest new
				 project: project1;
				 created_at: (DateAndTime
						  year: 2015
						  month: 11
						  day: 04
						  hour: 00
						  minute: 0
						  second: 0);
				 merged_at: (DateAndTime
						  year: 2016
						  month: 01
						  day: 05
						  hour: 12
						  minute: 0
						  second: 0)).
			(GLHMergeRequest new
				 project: project1;
				 created_at: (DateAndTime
						  year: 2020
						  month: 06
						  day: 05
						  hour: 00
						  minute: 0
						  second: 0);
				 merged_at: (DateAndTime
						  year: 2020
						  month: 07
						  day: 05
						  hour: 15
						  minute: 0
						  second: 0)).
			(GLHMergeRequest new
				 project: project1;
				 created_at: (DateAndTime
						  year: 2024
						  month: 09
						  day: 05
						  hour: 00
						  minute: 0
						  second: 0);
				 merged_at: (DateAndTime
						  year: 2024
						  month: 09
						  day: 05
						  hour: 10
						  minute: 0
						  second: 0)) }.


	mergeRequestDuration := MergedMergeRequestDurationProjectMetric new
		                        project: project1;
		                        glhImporter: glhImporter;
		                        setPeriodSince: since until: until;
		                        over: Week.

	"When"
	result := mergeRequestDuration calculate.

	"Then"
	self assert: result equals: 10 hours asSeconds 
]

{ #category : #tests }
MergedMergeRequestDurationProjectMetricTest >> testCalculateNoMergeRequests [

	| result glhImporter mergeRequestDuration |
	glhImporter := GLPHImporterMock new.

	mergeRequestDuration := MergedMergeRequestDurationProjectMetric new
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
