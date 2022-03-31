"
A GitLab Pipeline execution
"
Class {
	#name : #GLHPipeline,
	#superclass : #GLHEntity,
	#instVars : [
		'#project => FMOne type: #GLHProject opposite: #pipelines',
		'#status => FMProperty'
	],
	#category : #'BL.GitLabHealth-Model-Entities'
}

{ #category : #meta }
GLHPipeline class >> annotation [

	<FMClass: #Pipeline super: #GLHEntity>
	<package: #'BL.GitLabHealth-Model'>
	<generated>
	^self
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
GLHPipeline >> status [

	<FMProperty: #status type: #String>
	<generated>
	^ status
]

{ #category : #accessing }
GLHPipeline >> status: anObject [
	<generated>
	status := anObject
]
