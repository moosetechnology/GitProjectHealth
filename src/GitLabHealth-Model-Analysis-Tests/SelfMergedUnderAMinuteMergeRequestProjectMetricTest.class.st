"
A SelfMergedUnderAMinuteMergeRequestProjectMetricTest is a test class for testing the behavior of SelfMergedUnderAMinuteMergeRequestProjectMetric
"
Class {
	#name : #SelfMergedUnderAMinuteMergeRequestProjectMetricTest,
	#superclass : #ProjectMetricTest,
	#category : #'GitLabHealth-Model-Analysis-Tests'
}

{ #category : #tests }
SelfMergedUnderAMinuteMergeRequestProjectMetricTest >> testCalculate [

	| glhImporter result mergeFrequency |
	"Given"
	glhImporter := GLPHImporterMock new.


	glhImporter mergeRequests: { (GLHMergeRequest new
			 project: project;
			 created_at: createdAt;
			 merged_at: createdAt + 10 seconds;
			 state: #merged) }.


	mergeFrequency := SelfMergedUnderAMinuteMergeRequestProjectMetric new
		                  project: project;
		                  glhImporter: glhImporter;
		                  setPeriodSince: since until: until;
		                  over: Week.

	"When"
	result := mergeFrequency calculate.

	"Then"
	self assert: result equals: 1
]

{ #category : #tests }
SelfMergedUnderAMinuteMergeRequestProjectMetricTest >> testCalculateDifferentUser [

	| glhImporter result mergeFrequency user2 user1 |
	"Given"
	glhImporter := GLPHImporterMock new.

	user1 := GLHUser new name: 'user1'.
	user2 := GLHUser new name: 'user2'.


	glhImporter mergeRequests: { (GLHMergeRequest new
			 project: project;
			 author: user1;
			 merge_user: user2;
			 created_at: createdAt;
			 merged_at: createdAt + 10 second;
			 state: #merged) }.


	mergeFrequency := SelfMergedUnderAMinuteMergeRequestProjectMetric new
		                  project: project;
		                  glhImporter: glhImporter;
		                  setPeriodSince: since until: until;
		                  over: Week.

	"When"
	result := mergeFrequency calculate.

	"Then"
	self assert: result equals: 0
]

{ #category : #tests }
SelfMergedUnderAMinuteMergeRequestProjectMetricTest >> testCalculateSameUser [

	| glhImporter result mergeFrequency user2 user1 |
	"Given"
	glhImporter := GLPHImporterMock new.

	user1 := GLHUser new name: 'user1'.
	user2 := GLHUser new name: 'user2'.


	glhImporter mergeRequests: { (GLHMergeRequest new
			 project: project;
			 author: user1;
			 merge_user: user1;
			 created_at: createdAt;
			 merged_at: createdAt + 10 second;
			 state: #merged) }.


	mergeFrequency := SelfMergedUnderAMinuteMergeRequestProjectMetric new
		                  project: project;
		                  glhImporter: glhImporter;
		                  setPeriodSince: since until: until;
		                  over: Week.

	"When"
	result := mergeFrequency calculate.

	"Then"
	self assert: result equals: 1
]
