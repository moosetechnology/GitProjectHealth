"
A GitLab Pipeline execution

## Relations
======================



## Properties
======================

| Name | Type | Default value | Comment |
|---|
| `runDate` | `Object` | nil | Date this pipeline was run|
| `status` | `String` | nil | #success or #failure|

"
Class {
	#name : #GLHPipeline,
	#superclass : #GLHEntity,
	#instVars : [
		'#id => FMProperty',
		'#jobs => FMMany type: #GLHJob opposite: #pipeline',
		'#project => FMOne type: #GLHProject opposite: #pipelines',
		'#runDate => FMProperty',
		'#status => FMProperty'
	],
	#category : #'GitLabHealth-Model-Entities'
}

{ #category : #meta }
GLHPipeline class >> annotation [

	<FMClass: #Pipeline super: #GLHEntity>
	<package: #'GitLabHealth-Model'>
	<generated>
	^ self
]

{ #category : #adding }
GLHPipeline >> addJob: anObject [
	<generated>
	^ self jobs add: anObject
]

{ #category : #accessing }
GLHPipeline >> id [

	<FMProperty: #id type: #String>
	<generated>
	<FMComment: 'The id of the pipeline'>
	^ id
]

{ #category : #accessing }
GLHPipeline >> id: anObject [
	<generated>
	id := anObject
]

{ #category : #accessing }
GLHPipeline >> jobs [
	"Relation named: #jobs type: #GLHJob opposite: #pipeline"

	<generated>
	<derived>
	^ jobs
]

{ #category : #accessing }
GLHPipeline >> jobs: anObject [

	<generated>
	jobs value: anObject
]

{ #category : #navigation }
GLHPipeline >> jobsGroup [
	<generated>
	<navigation: 'Jobs'>
	^ MooseSpecializedGroup withAll: self jobs asSet
]

{ #category : #accessing }
GLHPipeline >> project [
	"Relation named: #project type: #GLHProject opposite: #pipelines"

	<generated>
	<container>
	^ project
]

{ #category : #accessing }
GLHPipeline >> project: anObject [

	<generated>
	project := anObject
]

{ #category : #navigation }
GLHPipeline >> projectGroup [
	<generated>
	<navigation: 'Project'>
	^ MooseSpecializedGroup with: self project
]

{ #category : #accessing }
GLHPipeline >> runDate [

	<FMProperty: #runDate type: #Object>
	<generated>
	<FMComment: 'Date this pipeline was run'>
	^ runDate
]

{ #category : #accessing }
GLHPipeline >> runDate: anObject [
	<generated>
	runDate := anObject
]

{ #category : #accessing }
GLHPipeline >> status [

	<FMProperty: #status type: #String>
	<generated>
	<FMComment: '#success or #failure'>
	^ status
]

{ #category : #accessing }
GLHPipeline >> status: anObject [
	<generated>
	status := anObject
]
