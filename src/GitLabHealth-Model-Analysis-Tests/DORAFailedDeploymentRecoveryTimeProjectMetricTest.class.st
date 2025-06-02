"
A DORAFailedDeploymentRecoveryTimeProjectMetricTest is a test class for testing the behavior of DORAFailedDeploymentRecoveryTimeProjectMetric
"
Class {
	#name : #DORAFailedDeploymentRecoveryTimeProjectMetricTest,
	#superclass : #ProjectMetricTest,
	#instVars : [
		'importerMock'
	],
	#category : #'GitLabHealth-Model-Analysis-Tests'
}

{ #category : #running }
DORAFailedDeploymentRecoveryTimeProjectMetricTest >> setUp [
	super setUp.
	importerMock := GLPHImporterMock new.

	"Initialize default period, can be overridden in specific tests"
	since := '2024-01-01' asDate.
	until := '2024-01-31' asDate.

	project := GLHProject new id: 1; name: 'TestProject'.
]

{ #category : #'tests - scenarios' }
DORAFailedDeploymentRecoveryTimeProjectMetricTest >> testNoPipelines [
	| metric result |
	"Given"
	importerMock pipelines: {}.

	metric := DORAFailedDeploymentRecoveryTimeProjectMetric new
		project: project;
		glhImporter: importerMock;
		setPeriodSince: since until: until.

	"When"
	result := metric calculate.

	"Then"
	self assert: result equals: 0.0.
]

{ #category : #'tests - scenarios' }
DORAFailedDeploymentRecoveryTimeProjectMetricTest >> testOneFailedOneSuccessfulPipeline [
	| metric result failedPipeline successfulPipeline |
	"Given"
	failedPipeline := GLHPipeline new id: 'p1'; status: #failed; created_at: (since + 1 day).
	successfulPipeline := GLHPipeline new id: 'p2'; status: #success; created_at: (since + 2 days).
	importerMock pipelines: {failedPipeline . successfulPipeline}.

	metric := DORAFailedDeploymentRecoveryTimeProjectMetric new
		project: project;
		glhImporter: importerMock;
		setPeriodSince: since until: until.

	"When"
	result := metric calculate.

	"Then"
	"Expected recovery time: 1 day = 24 * 60 * 60 = 86400 seconds"
	self assert: result equals: 86400.0.
]

{ #category : #'tests - scenarios' }
DORAFailedDeploymentRecoveryTimeProjectMetricTest >> testMultipleFailedBeforeSuccessfulPipeline [
	| metric result p1 p2 p3 |
	"Given"
	p1 := GLHPipeline new id: 'p1'; status: #failed; created_at: (since + 1 day).
	p2 := GLHPipeline new id: 'p2'; status: #failed; created_at: (since + 2 days). "This is the failure time that should be used"
	p3 := GLHPipeline new id: 'p3'; status: #success; created_at: (since + 3 days).
	importerMock pipelines: {p1 . p2 . p3}.

	metric := DORAFailedDeploymentRecoveryTimeProjectMetric new
		project: project;
		glhImporter: importerMock;
		setPeriodSince: since until: until.

	"When"
	result := metric calculate.

	"Then"
	"Expected recovery time: from p2 to p3 = 1 day = 86400 seconds"
	self assert: result equals: 86400.0.
]

{ #category : #'tests - scenarios' }
DORAFailedDeploymentRecoveryTimeProjectMetricTest >> testSuccessfulThenFailedPipeline [
	| metric result p1 p2 |
	"Given"
	p1 := GLHPipeline new id: 'p1'; status: #success; created_at: (since + 1 day).
	p2 := GLHPipeline new id: 'p2'; status: #failed; created_at: (since + 2 days).
	importerMock pipelines: {p1 . p2}.

	metric := DORAFailedDeploymentRecoveryTimeProjectMetric new
		project: project;
		glhImporter: importerMock;
		setPeriodSince: since until: until.

	"When"
	result := metric calculate.

	"Then"
	"No recovery sequence found"
	self assert: result equals: 0.0.
]

{ #category : #'tests - scenarios' }
DORAFailedDeploymentRecoveryTimeProjectMetricTest >> testInterleavedSuccessfulAndFailedPipelines [
	| metric result p1 p2 p3 p4 p5 |
	"Given"
	p1 := GLHPipeline new id: 'p1'; status: #failed; created_at: (since + 1 day).    "Failure 1 @ day 1"
	p2 := GLHPipeline new id: 'p2'; status: #success; created_at: (since + 2 days).  "Recovery 1 @ day 2 (duration 1 day)"
	p3 := GLHPipeline new id: 'p3'; status: #failed; created_at: (since + 3 days).    "Failure 2 @ day 3"
	p4 := GLHPipeline new id: 'p4'; status: #failed; created_at: (since + 4 days).    "Failure 3 @ day 4 (this one counts for next recovery)"
	p5 := GLHPipeline new id: 'p5'; status: #success; created_at: (since + 6 days).  "Recovery 2 @ day 6 (duration 2 days from p4)"
	importerMock pipelines: {p1 . p2 . p3 . p4 . p5}.

	metric := DORAFailedDeploymentRecoveryTimeProjectMetric new
		project: project;
		glhImporter: importerMock;
		setPeriodSince: since until: until.

	"When"
	result := metric calculate.

	"Then"
	"Recovery 1: p1 to p2 = 1 day (86400s)"
	"Recovery 2: p4 to p5 = 2 days (172800s)"
	"Average = (86400 + 172800) / 2 = 259200 / 2 = 129600 seconds"
	self assert: result equals: 129600.0.
]

{ #category : #'tests - scenarios' }
DORAFailedDeploymentRecoveryTimeProjectMetricTest >> testFailedAtEndOfPeriodNoSuccess [
	| metric result p1 |
	"Given"
	p1 := GLHPipeline new id: 'p1'; status: #failed; created_at: (since + 1 day).
	importerMock pipelines: {p1}.

	metric := DORAFailedDeploymentRecoveryTimeProjectMetric new
		project: project;
		glhImporter: importerMock;
		setPeriodSince: since until: until.

	"When"
	result := metric calculate.

	"Then"
	"No recovery sequence found"
	self assert: result equals: 0.0.
]

{ #category : #'tests - scenarios' }
DORAFailedDeploymentRecoveryTimeProjectMetricTest >> testComplexInterleavingAverage [
	| metric result p1 p2 p3 p4 p5 p6 p7 |
	"Given"
	p1 := GLHPipeline new id: 'p1'; status: #failed; created_at: (since + 1 day).        "F1 @ D1"
	p2 := GLHPipeline new id: 'p2'; status: #success; created_at: (since + 2 days).      "S1 @ D2 (Recovers F1, duration 1 day)"
	p3 := GLHPipeline new id: 'p3'; status: #success; created_at: (since + 3 days).      "S2 @ D3 (No preceding failure)"
	p4 := GLHPipeline new id: 'p4'; status: #failed; created_at: (since + 4 days).        "F2 @ D4"
	p5 := GLHPipeline new id: 'p5'; status: #failed; created_at: (since + 5 days).        "F3 @ D5 (This one is active)"
	p6 := GLHPipeline new id: 'p6'; status: #success; created_at: (since + 7 days).      "S3 @ D7 (Recovers F3, duration 2 days)"
	p7 := GLHPipeline new id: 'p7'; status: #failed; created_at: (since + 8 days).        "F4 @ D8 (No subsequent success in period)"

	importerMock pipelines: {p1 . p2 . p3 . p4 . p5 . p6 . p7}.

	metric := DORAFailedDeploymentRecoveryTimeProjectMetric new
		project: project;
		glhImporter: importerMock;
		setPeriodSince: since until: until.

	"When"
	result := metric calculate.

	"Then"
	"Recovery 1 (p1 -> p2): 1 day = 86400s"
	"Recovery 2 (p5 -> p6): 2 days = 172800s"
	"Average = (86400 + 172800) / 2 = 129600.0s"
	self assert: result equals: 129600.0.
]

{ #category : #'tests - scenarios' }
DORAFailedDeploymentRecoveryTimeProjectMetricTest >> testOnlySuccessfulPipelines [
	| metric result pipeline1 pipeline2 |
	"Given"
	pipeline1 := GLHPipeline new id: 'p1'; status: #success; created_at: (since + 1 day).
	pipeline2 := GLHPipeline new id: 'p2'; status: #success; created_at: (since + 2 days).
	importerMock pipelines: {pipeline1 . pipeline2}.

	metric := DORAFailedDeploymentRecoveryTimeProjectMetric new
		project: project;
		glhImporter: importerMock;
		setPeriodSince: since until: until.

	"When"
	result := metric calculate.

	"Then"
	self assert: result equals: 0.0.
]

{ #category : #'tests - scenarios' }
DORAFailedDeploymentRecoveryTimeProjectMetricTest >> testOnlyFailedPipelines [
	| metric result pipeline1 pipeline2 |
	"Given"
	pipeline1 := GLHPipeline new id: 'p1'; status: #failed; created_at: (since + 1 day).
	pipeline2 := GLHPipeline new id: 'p2'; status: #failed; created_at: (since + 2 days).
	importerMock pipelines: {pipeline1 . pipeline2}.

	metric := DORAFailedDeploymentRecoveryTimeProjectMetric new
		project: project;
		glhImporter: importerMock;
		setPeriodSince: since until: until.

	"When"
	result := metric calculate.

	"Then"
	self assert: result equals: 0.0.
]
