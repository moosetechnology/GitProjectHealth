"
A CommitFrequencyMetricTest is a test class for testing the behavior of CommitFrequencyMetric
"
Class {
	#name : #CommitFrequencyMetricTest,
	#superclass : #UserMetricTest,
	#category : #'GitLabHealth-Model-Analysis-Tests'
}

{ #category : #tests }
CommitFrequencyMetricTest >> testCalculate [

	| glhImporter result commitFrequency |

	self flag: 'TODO test'.
	glhImporter := GLPHImporterMock new.


	commitFrequency := CommitFrequencyMetric new
		                   user: user;
		                   glhImporter: glhImporter;
		                   setPeriodSince: '04-09-2024' until: '04-09-2024';
		                   over: Week.

	"When"
	result := commitFrequency calculate.

	"Then"
	self assert: result equals: 0
]

{ #category : #tests }
CommitFrequencyMetricTest >> testCalculateNoCommits [

	| glhImporter result commitFrequency |


	glhImporter := GLPHImporterMock new.


	commitFrequency := CommitFrequencyMetric new
		                   user: user;
		                   glhImporter: glhImporter;
		                   setPeriodSince: '04-09-2024' until: '04-09-2024';
		                   over: Week.

	"When"
	result := commitFrequency calculate.

	"Then"
	self assert: result equals: 0
]
