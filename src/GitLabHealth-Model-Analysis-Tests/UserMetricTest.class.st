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
