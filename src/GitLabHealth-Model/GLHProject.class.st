"
A GitLab Project
"
Class {
	#name : #GLHProject,
	#superclass : #GLHEntity,
	#instVars : [
		'#archived => FMProperty',
		'#avatar_url => FMProperty',
		'#creator => FMOne type: #GLHUser opposite: #createdProjects',
		'#creator_id => FMProperty',
		'#description => FMProperty',
		'#group => FMOne type: #GLHGroup opposite: #projects',
		'#id => FMProperty',
		'#name => FMProperty',
		'#pipelines => FMMany type: #GLHPipeline opposite: #project',
		'#readme_url => FMProperty',
		'#repository => FMOne type: #GLHRepository opposite: #project',
		'#topics => FMProperty',
		'#web_url => FMProperty'
	],
	#category : #'GitLabHealth-Model-Entities'
}

{ #category : #meta }
GLHProject class >> annotation [

	<FMClass: #Project super: #GLHEntity>
	<package: #'BL-GitLabHealth-Model'>
	<generated>
	^self
]

{ #category : #adding }
GLHProject >> addPipeline: anObject [
	<generated>
	^ self pipelines add: anObject
]

{ #category : #accessing }
GLHProject >> archived [

	<FMProperty: #archived type: #Boolean>
	<generated>
	^ archived
]

{ #category : #accessing }
GLHProject >> archived: anObject [
	<generated>
	archived := anObject
]

{ #category : #accessing }
GLHProject >> avatar_url [

	<FMProperty: #avatar_url type: #String>
	<generated>
	^ avatar_url
]

{ #category : #accessing }
GLHProject >> avatar_url: anObject [
	<generated>
	avatar_url := anObject
]

{ #category : #accessing }
GLHProject >> creator [
	"Relation named: #creator type: #GLHUser opposite: #createdProjects"

	<generated>
	^ creator
]

{ #category : #accessing }
GLHProject >> creator: anObject [

	<generated>
	creator := anObject
]

{ #category : #accessing }
GLHProject >> creator_id [

	<FMProperty: #creator_id type: #Number>
	<generated>
	^ creator_id
]

{ #category : #accessing }
GLHProject >> creator_id: anObject [
	<generated>
	creator_id := anObject
]

{ #category : #accessing }
GLHProject >> description [

	<FMProperty: #description type: #String>
	<generated>
	^ description
]

{ #category : #accessing }
GLHProject >> description: anObject [
	<generated>
	description := anObject
]

{ #category : #accessing }
GLHProject >> group [
	"Relation named: #group type: #GLHGroup opposite: #projects"

	<generated>
	<container>
	^ group
]

{ #category : #accessing }
GLHProject >> group: anObject [

	<generated>
	group := anObject
]

{ #category : #navigation }
GLHProject >> groupGroup [
	<generated>
	<navigation: 'Group'>
	^ MooseSpecializedGroup with: self group
]

{ #category : #accessing }
GLHProject >> id [

	<FMProperty: #id type: #Number>
	<generated>
	^ id
]

{ #category : #accessing }
GLHProject >> id: anObject [
	<generated>
	id := anObject
]

{ #category : #accessing }
GLHProject >> name [

	<FMProperty: #name type: #String>
	<generated>
	^ name
]

{ #category : #accessing }
GLHProject >> name: anObject [
	<generated>
	name := anObject
]

{ #category : #accessing }
GLHProject >> pipelines [
	"Relation named: #pipelines type: #GLHPipeline opposite: #project"

	<generated>
	<derived>
	^ pipelines
]

{ #category : #accessing }
GLHProject >> pipelines: anObject [

	<generated>
	pipelines value: anObject
]

{ #category : #navigation }
GLHProject >> pipelinesGroup [
	<generated>
	<navigation: 'Pipelines'>
	^ MooseSpecializedGroup withAll: self pipelines asSet
]

{ #category : #accessing }
GLHProject >> readme_url [

	<FMProperty: #readme_url type: #String>
	<generated>
	^ readme_url
]

{ #category : #accessing }
GLHProject >> readme_url: anObject [
	<generated>
	readme_url := anObject
]

{ #category : #accessing }
GLHProject >> repository [
	"Relation named: #repository type: #GLHRepository opposite: #project"

	<generated>
	^ repository
]

{ #category : #accessing }
GLHProject >> repository: anObject [

	<generated>
	repository := anObject
]

{ #category : #navigation }
GLHProject >> repositoryGroup [
	<generated>
	<navigation: 'Repository'>
	^ MooseSpecializedGroup with: self repository
]

{ #category : #accessing }
GLHProject >> topics [

	<FMProperty: #topics type: #Object>
	<generated>
	^ topics
]

{ #category : #accessing }
GLHProject >> topics: anObject [
	<generated>
	topics := anObject
]

{ #category : #accessing }
GLHProject >> web_url [

	<FMProperty: #web_url type: #String>
	<generated>
	^ web_url
]

{ #category : #accessing }
GLHProject >> web_url: anObject [
	<generated>
	web_url := anObject
]
