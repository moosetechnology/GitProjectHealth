Class {
	#name : #UserMetricTest,
	#superclass : #MetricTest,
	#instVars : [
		'user',
		'project1',
		'project2'
	],
	#category : #'GitLabHealth-Model-Analysis-Tests'
}

{ #category : #running }
UserMetricTest >> setUp [

	super setUp.

	project1 := GLHProject new
		            repository: GLHRepository new;
		            name: 'project1'.
	user := GLHUser new
		        username: 'test';
		        contributedProjects: { project1 }.



]

{ #category : #running }
UserMetricTest >> testAllDescriptionDifferent [

	| metrics metricsDescription |
	metrics := UserMetric allSubclasses reject: [ :metric |
		           metric isAbstract ].
	metricsDescription := metrics
		                      collect: [ :me | me new description ]
		                      as: Set.
	self assert: metrics size equals: metricsDescription size
]
