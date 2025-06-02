Class {
	#name : #DORAFailedDeploymentRecoveryTimeProjectMetric,
	#superclass : #ProjectMetric,
	#instVars : [
		'projectPipelines'
	],
	#category : #'GitLabHealth-Model-Analysis'
}

{ #category : #accessing }
DORAFailedDeploymentRecoveryTimeProjectMetric >> description [

	^ 'DORA - Failed deployment recovery time. Measures the time it takes to recover from a failed deployment. A lower recovery time indicates a more resilient and responsive system. Time duration between a failed pipeline and the next successful one.'
]

{ #category : #calculating }
DORAFailedDeploymentRecoveryTimeProjectMetric >> calculate [
	| recoveryTimes lastFailedPipelineTime |
	projectPipelines ifNil: [ self load ].
	projectPipelines ifEmpty: [ ^ 0.0 ].

	recoveryTimes := OrderedCollection new.
	lastFailedPipelineTime := nil.

	projectPipelines do: [ :pipeline |
		| status createdAt |
		status := pipeline status.
		createdAt := pipeline created_at. "Assuming created_at is a DateAndTime or similar object"

		status = #failed ifTrue: [
			lastFailedPipelineTime := createdAt.
		].

		status = #success ifTrue: [
			lastFailedPipelineTime ifNotNil: [
				| recoveryDuration |
				recoveryDuration := createdAt - lastFailedPipelineTime. "This calculates Duration"
				recoveryTimes add: recoveryDuration totalSeconds. "Or another suitable unit like totalHours / totalDays"
				lastFailedPipelineTime := nil. "Reset after a successful recovery"
			].
		].
	].

	recoveryTimes ifEmpty: [ ^ 0.0 ].

	^ (recoveryTimes sum / recoveryTimes size) asFloat
]

{ #category : #loading }
DORAFailedDeploymentRecoveryTimeProjectMetric >> load [
	projectPipelines := glhImporter
		importPipelinesOfProject: project
		since: (period at: #since)
		until: (period at: #until).

	"Ensure pipelines are sorted by creation date for accurate calculation later"
	projectPipelines := projectPipelines sorted: [ :a :b | a created_at < b created_at ].
]
