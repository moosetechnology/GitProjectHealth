"
A GitLab Pipeline execution
"
Class {
	#name : #GLHPipeline,
	#superclass : #GLHEntity,
	#instVars : [
		'#status => FMProperty',
		'#runDate => FMProperty',
		'#project => FMOne type: #GLHProject opposite: #pipelines'
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
