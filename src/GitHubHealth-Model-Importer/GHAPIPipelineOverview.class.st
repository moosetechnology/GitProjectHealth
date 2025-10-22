Class {
	#name : #GHAPIPipelineOverview,
	#superclass : #Object,
	#instVars : [
		'total_count',
		'workflow_runs',
		'jobs'
	],
	#category : #'GitHubHealth-Model-Importer'
}

{ #category : #accessing }
GHAPIPipelineOverview >> jobs [

	^ jobs
]

{ #category : #accessing }
GHAPIPipelineOverview >> jobs: anObject [

	jobs := anObject
]

{ #category : #accessing }
GHAPIPipelineOverview >> total_count [

	^ total_count
]

{ #category : #accessing }
GHAPIPipelineOverview >> total_count: anObject [

	total_count := anObject
]

{ #category : #accessing }
GHAPIPipelineOverview >> workflow_runs [

	^ workflow_runs
]

{ #category : #accessing }
GHAPIPipelineOverview >> workflow_runs: anObject [

	workflow_runs := anObject
]
