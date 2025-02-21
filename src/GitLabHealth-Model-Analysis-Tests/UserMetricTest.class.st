Class {
	#name : #UserMetricTest,
	#superclass : #MetricTest,
	#instVars : [
		'user',
		'project1',
		'createdAt',
		'mergedAt',
		'closedAt',
		'since',
		'until'
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

	createdAt := '2024-09-04T10:24:11.803+02:00' asDateAndTime.
	closedAt := '2024-09-04T11:24:11.803+02:00' asDateAndTime.
	mergedAt := '2024-09-04T11:24:11.803+02:00' asDateAndTime.

	since := '2024-09-04'.
	until := '2024-09-05'
]
