"
A MergedMergeRequestMetricTest is a test class for testing the behavior of MergedMergeRequestMetric
"
Class {
	#name : #SelfMergedMergeRequestMetricTest,
	#superclass : #UserMetricTest,
	#category : #'GitLabHealth-Model-Analysis-Tests'
}

{ #category : #tests }
SelfMergedMergeRequestMetricTest >> testCalculate [

	| result glhImporter mergedMergeRequest |
	"Given"


	glhImporter := GLPHImporterMock new.
	glhImporter mergeRequests: {
			(GLHMergeRequest new
				 author: user;
				 merge_user: user;
				 project: project1;
				 created_at: createdAt ;
				 merged_at: mergedAt ).

			(GLHMergeRequest new
				 author: user;
				 merge_user: user;
				 project: project1;
				 created_at: createdAt - 20 days;
				 merged_at: nil) }.


	mergedMergeRequest := SelfMergedMergeRequestMetric new
		                      user: user;
		                      glhImporter: glhImporter;
		                      setPeriodSince: since
		                      until: until;
		                      over: Week.

	"When"
	result := mergedMergeRequest calculate.

	"Then"
	self assert: result equals: 1
]

{ #category : #tests }
SelfMergedMergeRequestMetricTest >> testCalculate1MRInPeriod1Outside [

	| result glhImporter mergedMergeRequest |
	"Given"
	glhImporter := GLPHImporterMock new.
	glhImporter mergeRequests: {
			(GLHMergeRequest new
				 author: user;
				 project: project1;
				 merge_user: user;
				 created_at: createdAt;
				 merged_at: mergedAt).

			"open but merged anotherWeek"
			(GLHMergeRequest new
				 author: user;
				 merge_user: user;
				 project: project1;
				 created_at: createdAt;
				 merged_at: createdAt + 10 days) }.
	"open and merge during the same week"


	mergedMergeRequest := SelfMergedMergeRequestMetric new
		                      user: user;
		                      glhImporter: glhImporter;
		                      setPeriodSince: since until: until;
		                      over: Week.

	"When"
	result := mergedMergeRequest calculate.

	"Then"
	self assert: result equals: 1
]

{ #category : #tests }
SelfMergedMergeRequestMetricTest >> testCalculate1MROpenedButNotMerged [

	| result glhImporter mergedMergeRequest |
	"Given"
	glhImporter := GLPHImporterMock new.
	glhImporter mergeRequests: {
			(GLHMergeRequest new
				 author: user;
				 merge_user: user;
				 project: project1;
				 created_at: createdAt;
				 merged_at: mergedAt;
				 state: #merged).

			(GLHMergeRequest new
				 author: user;
				 project: project1;
				 created_at: createdAt;
				 state: #opened) }.


	mergedMergeRequest := SelfMergedMergeRequestMetric new
		                      user: user;
		                      glhImporter: glhImporter;
		                      setPeriodSince: since until: until;
		                      over: Week.

	"When"
	result := mergedMergeRequest calculate.

	"Then"
	self assert: result equals: 1
]

{ #category : #tests }
SelfMergedMergeRequestMetricTest >> testCalculate2MROneForEachUser [

	| result glhImporter  mergedMergeRequest user2 |
	"Given"


	user2 := GLHUser new
		         name: 'user2';
		         id: 2;
		         contributedProjects: { project1 }.

	glhImporter := GLPHImporterMock new.
	glhImporter mergeRequests: {
			(GLHMergeRequest new
				 author: user;
				 title: 'MR1';
				 project: project1;
				 created_at: createdAt;
				 merge_user: user;
				 merged_at: mergedAt).
			(GLHMergeRequest new
				 author: user2;
				 title: 'MR2';
				 project: project1;
				 created_at: createdAt;
				 merge_user: user2;
				 merged_at: mergedAt) }.


	mergedMergeRequest := SelfMergedMergeRequestMetric new
		                      user: user;
		                      glhImporter: glhImporter;
		                      setPeriodSince: since until: until;
		                      over: Week.

	"When"
	result := mergedMergeRequest calculate.

	"Then"
	self assert: result equals: 1
]

{ #category : #tests }
SelfMergedMergeRequestMetricTest >> testCalculate3MROpenButMergedByOthers [

	| result glhImporter mergedMergeRequest user2 |
	"Given"


	user2 := GLHUser new
		         name: 'user2';
		         id: 2;
		         contributedProjects:
			         { project1 }.

	glhImporter := GLPHImporterMock new.
	glhImporter mergeRequests: {
			(GLHMergeRequest new
				 author: user;
				 title: 'MR1';
				 created_at: createdAt;
				 merge_user: user2;
				 merged_at: mergedAt ).
			(GLHMergeRequest new
				 author: user;
				 title: 'MR2';
				 created_at: createdAt ;
				 merge_user: user2;
				 merged_at: mergedAt ).
			(GLHMergeRequest new
				 author: user;
				 title: 'MR3';
				 created_at: createdAt ;
				 merge_user: user2;
				 merged_at: mergedAt ) }.


	mergedMergeRequest := SelfMergedMergeRequestMetric new
		                      user: user;
		                      glhImporter: glhImporter;
		                      setPeriodSince: since
		                      until: until;
		                      over: Week.

	"When"
	result := mergedMergeRequest calculate.

	"Then"
	self assert: result equals: 0
]

{ #category : #tests }
SelfMergedMergeRequestMetricTest >> testCalculate3MROpenByOther [

	| result glhImporter  mergedMergeRequest user2 |
	"Given"

	user2 := GLHUser new
		         name: 'user2';
		         id: 2;
		         contributedProjects:
			         { project1 }.

	glhImporter := GLPHImporterMock new.
	glhImporter mergeRequests: {
			(GLHMergeRequest new
				 author: user2;
				 title: 'MR1';
				 created_at: createdAt ;
				 merge_user: user;
				project: project1 ;
				state: #merged; 
				 merged_at: mergedAt ).
			(GLHMergeRequest new
				 author: user2;
				state: #merged; 
				 title: 'MR2';
				 created_at: createdAt ;
				project: project1 ;
				 merge_user: user;
				 merged_at: mergedAt ).
			(GLHMergeRequest new
				 author: user2;
				state: #merged; 
				 title: 'MR3';
				 created_at: createdAt ;
				 project: project1 ;
				 merge_user: user;
				 merged_at: mergedAt ) }.


	mergedMergeRequest := SelfMergedMergeRequestMetric new
		                      user: user;
		                      glhImporter: glhImporter;
		                      setPeriodSince: since
		                      until: until;
		                      over: Week.

	"When"
	result := mergedMergeRequest calculate.

	"Then"
	self assert: result equals: 3
]

{ #category : #tests }
SelfMergedMergeRequestMetricTest >> testCalculateNoMergeRequests [

	| result glhImporter mergedMergeRequest |
	"Given"
	glhImporter := GLPHImporterMock new.


	mergedMergeRequest := SelfMergedMergeRequestMetric new
		                      user: user;
		                      glhImporter: glhImporter;
		                      setPeriodSince: since
		                      until: until;
		                      over: Week.

	"When"
	result := mergedMergeRequest calculate.

	"Then"
	self assert: result equals: 0
]
