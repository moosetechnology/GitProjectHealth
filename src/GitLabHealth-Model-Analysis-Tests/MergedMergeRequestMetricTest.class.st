"
A MergedMergeRequestMetricTest is a test class for testing the behavior of MergedMergeRequestMetric
"
Class {
	#name : #MergedMergeRequestMetricTest,
	#superclass : #TestCase,
	#category : #'GitLabHealth-Model-Analysis-Tests'
}

{ #category : #tests }
MergedMergeRequestMetricTest >> testCalculate [

	| result glhImporter user mergedMergeRequest |
	"Given"
	user := GLHUser new
		        username: 'test';
				 id: 1;
		        contributedProjects:
			        { (GLHProject new repository: GLHRepository new) }.

	glhImporter := GLPHImporterMock new.
	glhImporter mergeRequests: { (GLHMergeRequest new
			 author: user;
		    merge_user: user;
			 created_at: '2024-09-05';
			 merged_at: '2024-09-05').
			
			(GLHMergeRequest new
				author: user;
				merge_user: user;
				created_at: '2024-09-02';
			 	merged_at: nil)
			}.


	mergedMergeRequest := MergedMergeRequestMetric new
		                      user: user;
		                      glhImporter: glhImporter;
		                      setPeriodSince: '2024-09-01'
		                      until: '2024-09-07';
		                      over: Week.

	"When"
	result := mergedMergeRequest calculate.

	"Then"
	self assert: result equals: 1
]

{ #category : #tests }
MergedMergeRequestMetricTest >> testCalculate1MRInPeriod1Outside [

	| result glhImporter user mergedMergeRequest |
	"Given"
	user := GLHUser new
		        username: 'test';
		        id: 1;
		        contributedProjects:
			        { (GLHProject new repository: GLHRepository new) }.

	glhImporter := GLPHImporterMock new.
	glhImporter mergeRequests: {
			(GLHMergeRequest new
				 author: user;
				 merge_user: user;
				 created_at: '2024-09-05';
				 merged_at: '2024-09-05').

			"open but merged anotherWeek"
			(GLHMergeRequest new
				 author: user;
				 merge_user: user;
				 created_at: '2024-09-05';
				 merged_at: '2024-09-10') }.
	"open and merge during the same week"


	mergedMergeRequest := MergedMergeRequestMetric new
		                      user: user;
		                      glhImporter: glhImporter;
		                      setPeriodSince: '2024-09-01'
		                      until: '2024-09-07';
		                      over: Week.

	"When"
	result := mergedMergeRequest calculate.

	"Then"
	self assert: result equals: 1
]

{ #category : #tests }
MergedMergeRequestMetricTest >> testCalculate1MROpenedButNotMerged [

	| result glhImporter user mergedMergeRequest |
	"Given"
	user := GLHUser new
		        username: 'test';
		        id: 1;
		        contributedProjects:
			        { (GLHProject new repository: GLHRepository new) }.

	glhImporter := GLPHImporterMock new.
	glhImporter mergeRequests: {
			(GLHMergeRequest new
				 author: user;
				 merge_user: user;
				 created_at: '2024-09-05';
				 merged_at: '2024-09-05').
			(GLHMergeRequest new
				 author: user;
				 created_at: '2024-09-05';
				 merged_at: nil) }.


	mergedMergeRequest := MergedMergeRequestMetric new
		                      user: user;
		                      glhImporter: glhImporter;
		                      setPeriodSince: '2024-09-01'
		                      until: '2024-09-07';
		                      over: Week.

	"When"
	result := mergedMergeRequest calculate.

	"Then"
	self assert: result equals: 1
]

{ #category : #tests }
MergedMergeRequestMetricTest >> testCalculate2MROneForEachUser [

	| result glhImporter user1 mergedMergeRequest user2 |
	"Given"
	user1 := GLHUser new
		         name: 'test';
		         id: 1;
		         contributedProjects:
			         { (GLHProject new repository: GLHRepository new) }.

	user2 := GLHUser new
		         name: 'test';
		         id: 2;
		         contributedProjects:
			         { (GLHProject new repository: GLHRepository new) }.

	glhImporter := GLPHImporterMock new.
	glhImporter mergeRequests: {
			(GLHMergeRequest new
				 author: user1;
				 title: 'MR1';
				 created_at: '2024-09-05';
				 merge_user: user1;
				 merged_at: '2024-09-05').
			(GLHMergeRequest new
				 author: user2;
				 title: 'MR2';
				 created_at: '2024-09-05';
				 merge_user: user2;
				 merged_at: '2024-09-06') }.


	mergedMergeRequest := MergedMergeRequestMetric new
		                      user: user1;
		                      glhImporter: glhImporter;
		                      setPeriodSince: '2024-09-01'
		                      until: '2024-09-07';
		                      over: Week.

	"When"
	result := mergedMergeRequest calculate.

	"Then"
	self assert: result equals: 1
]

{ #category : #tests }
MergedMergeRequestMetricTest >> testCalculate3MROpenButMergedByOthers [

	| result glhImporter user1 mergedMergeRequest user2 |
	"Given"
	user1 := GLHUser new
		         name: 'test';
		         id: 1;
		         contributedProjects:
			         { (GLHProject new repository: GLHRepository new) }.

	user2 := GLHUser new
		         name: 'test';
		         id: 2;
		         contributedProjects:
			         { (GLHProject new repository: GLHRepository new) }.

	glhImporter := GLPHImporterMock new.
	glhImporter mergeRequests: {
			(GLHMergeRequest new
				 author: user1;
				 title: 'MR1';
				 created_at: '2024-09-05';
				 merge_user: user2;
				 merged_at: '2024-09-05').
			(GLHMergeRequest new
				 author: user1;
				 title: 'MR2';
				 created_at: '2024-09-05';
				 merge_user: user2;
				 merged_at: '2024-09-06').
			(GLHMergeRequest new
				 author: user1;
				 title: 'MR3';
				 created_at: '2024-09-05';
				 merge_user: user2;
				 merged_at: '2024-09-06') }.


	mergedMergeRequest := MergedMergeRequestMetric new
		                      user: user1;
		                      glhImporter: glhImporter;
		                      setPeriodSince: '2024-09-01'
		                      until: '2024-09-07';
		                      over: Week.

	"When"
	result := mergedMergeRequest calculate.

	"Then"
	self assert: result equals: 0
]

{ #category : #tests }
MergedMergeRequestMetricTest >> testCalculate3MROpenByOther [

	| result glhImporter user1 mergedMergeRequest user2 |
	"Given"
	user1 := GLHUser new
		         name: 'test';
		         id: 1;
		         contributedProjects:
			         { (GLHProject new repository: GLHRepository new) }.

	user2 := GLHUser new
		         name: 'test';
		         id: 2;
		         contributedProjects:
			         { (GLHProject new repository: GLHRepository new) }.

	glhImporter := GLPHImporterMock new.
	glhImporter mergeRequests: {
			(GLHMergeRequest new
				 author: user2;
				 title: 'MR1';
				 created_at: '2024-09-05';
				 merge_user: user1;
				 merged_at: '2024-09-05').
			(GLHMergeRequest new
				 author: user2;
				 title: 'MR2';
				 created_at: '2024-09-05';
				 merge_user: user1;
				 merged_at: '2024-09-06').
			(GLHMergeRequest new
				 author: user2;
				 title: 'MR3';
				 created_at: '2024-09-05';
				 merge_user: user1;
				 merged_at: '2024-09-06') }.


	mergedMergeRequest := MergedMergeRequestMetric new
		                      user: user1;
		                      glhImporter: glhImporter;
		                      setPeriodSince: '2024-09-01'
		                      until: '2024-09-07';
		                      over: Week.

	"When"
	result := mergedMergeRequest calculate.

	"Then"
	self assert: result equals: 3
]

{ #category : #tests }
MergedMergeRequestMetricTest >> testCalculateNoMergeRequests [ 

	| result glhImporter user mergedMergeRequest |
	"Given"
	user := GLHUser new
		        username: 'test';
		id: 1;
		        contributedProjects:
			        { (GLHProject new repository: GLHRepository new) }.

	glhImporter := GLPHImporterMock new.


	mergedMergeRequest := MergedMergeRequestMetric new
		                      user: user;
		                      glhImporter: glhImporter;
		                      setPeriodSince: '2024-09-04'
		                      until: '2024-09-04';
		                      over: Week.

	"When"
	result := mergedMergeRequest calculate.

	"Then"
	self assert: result equals: 0
]
