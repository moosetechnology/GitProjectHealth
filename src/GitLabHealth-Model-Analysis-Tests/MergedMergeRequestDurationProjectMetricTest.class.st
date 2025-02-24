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
						  hour: 08
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
	                           project: project1 ;
		                        glhImporter: glhImporter;
		                        setPeriodSince: since
		                        until: until;
		                        over: Week.

	"When"
	result := mergeRequestDuration calculate.

	"Then"
	self assert:  result equals: 10 * 60 * 60 
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

{ #category : #tests }
MergedMergeRequestDurationProjectMetricTest >> testCalculateOneMergeRequest [

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
						}.


	mergeRequestDuration := MergedMergeRequestDurationProjectMetric new 
	                           project: project1 ;
		                        glhImporter: glhImporter;
		                        setPeriodSince: since
		                        until: until;
		                        over: Week.

	"When"
	result := mergeRequestDuration calculate.

	"Then"
	self assert:  result equals: 12 * 60 * 60 
]
