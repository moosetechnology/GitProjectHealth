Class {
	#name : #ProjectMetricTest,
	#superclass : #MetricTest,
	#instVars : [
		'project',
		'project1',
		'project2'
	],
	#category : #'GitLabHealth-Model-Analysis-Tests'
}

{ #category : #running }
ProjectMetricTest >> setUp [

	super setUp.

	"Put here a common initialization logic for tests"
	project := GLHProject new
		           name: 'projectTest';
		           repository: GLHRepository new.

	project1 := GLHProject new
		            name: 'project1';
		            repository: GLHRepository new.


	project2 := GLHProject new
		            name: 'project2';
		            repository: GLHRepository new
]
