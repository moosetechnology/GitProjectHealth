"
A MergeRequestDurationMetricTest is a test class for testing the behavior of MergeRequestDurationMetric
"
Class {
	#name : #MergeRequestDurationMetricTest,
	#superclass : #UserMetricTest,
	#category : #'GitLabHealth-Model-Analysis-Tests'
}

{ #category : #tests }
MergeRequestDurationMetricTest >> testCalculate [

	| result glhImporter  mergeRequestDuration |

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
				 merged_at: (DateAndTime
						  year: 2024
						  month: 09
						  day: 05
						  hour: 10
						  minute: 0
						  second: 0)).
			(GLHMergeRequest new
				 author: user;
				project: project1;
				  created_at: (DateAndTime
						  year: 2024
						  month: 09
						  day: 05
						  hour: 01
						  minute: 0
						  second: 0);
				 merged_at: nil) }.


	mergeRequestDuration := MergeRequestDurationMetric new
		                        user: user;
		                        glhImporter: glhImporter;
		                        setPeriodSince: '2024-09-04'
		                        until: '2024-09-04';
		                        over: Week.

	"When"
	result := mergeRequestDuration calculate.

	"Then"
	self assert: result equals: 10 * 60 * 60
]

{ #category : #tests }
MergeRequestDurationMetricTest >> testCalculateNoMergeRequests [

	| result glhImporter  mergeRequestDuration |


	glhImporter := GLPHImporterMock new.

	mergeRequestDuration := MergeRequestDurationMetric new
		                        user: user;
		                        glhImporter: glhImporter;
		                        setPeriodSince: '2024-09-04'
		                        until: '2024-09-05';
		                        over: Week.

	"When"
	result := mergeRequestDuration calculate.

	"Then"
	self assert: result equals: nil
]
