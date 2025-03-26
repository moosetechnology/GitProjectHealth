"
A GitLab Project

## Relations
======================

### Parents
| Relation | Origin | Opposite | Type | Comment |
|---|
| `group` | `GLHProject` | `projects` | `GLHGroup` | |

### Children
| Relation | Origin | Opposite | Type | Comment |
|---|
| `mergeRequests` | `GLHProject` | `project` | `GLHMergeRequest` | |
| `pipelines` | `GLHProject` | `project` | `GLHPipeline` | |
| `repository` | `GLHProject` | `project` | `GLHRepository` | |

### Other
| Relation | Origin | Opposite | Type | Comment |
|---|
| `contributors` | `GLHProject` | `contributedProjects` | `GLHUser` | |
| `creator` | `GLHProject` | `createdProjects` | `GLHUser` | |


## Properties
======================

| Name | Type | Default value | Comment |
|---|
| `archived` | `Boolean` | nil | |
| `archived` | `Boolean` | nil | |
| `avatar_url` | `String` | nil | |
| `creator_id` | `Number` | nil | |
| `description` | `String` | nil | |
| `id` | `Number` | nil | |
| `name` | `String` | nil | Basic name of the entity, not full reference.|
| `readme_url` | `String` | nil | |
| `topics` | `Object` | nil | |
| `web_url` | `String` | nil | |

"
Class {
	#name : #GLHProject,
	#superclass : #GLHEntity,
	#traits : 'FamixTNamedEntity',
	#classTraits : 'FamixTNamedEntity classTrait',
	#instVars : [
		'#archived => FMProperty',
		'#avatar_url => FMProperty',
		'#contributors => FMMany type: #GLHUser opposite: #contributedProjects',
		'#creator => FMOne type: #GLHUser opposite: #createdProjects',
		'#creator_id => FMProperty',
		'#description => FMProperty',
		'#group => FMOne type: #GLHGroup opposite: #projects',
		'#id => FMProperty',
		'#mergeRequests => FMMany type: #GLHMergeRequest opposite: #project',
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
	<package: #'GitLabHealth-Model'>
	<generated>
	^ self
]

{ #category : #adding }
GLHProject >> addContributor: anObject [
	<generated>
	^ self contributors add: anObject
]

{ #category : #adding }
GLHProject >> addMergeRequest: anObject [
	<generated>
	^ self mergeRequests add: anObject
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
GLHProject >> contributors [
	"Relation named: #contributors type: #GLHUser opposite: #contributedProjects"

	<generated>
	<derived>
	^ contributors
]

{ #category : #accessing }
GLHProject >> contributors: anObject [

	<generated>
	contributors value: anObject
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
GLHProject >> mergeRequests [
	"Relation named: #mergeRequests type: #GLHMergeRequest opposite: #project"

	<generated>
	<derived>
	^ mergeRequests
]

{ #category : #accessing }
GLHProject >> mergeRequests: anObject [

	<generated>
	mergeRequests value: anObject
]

{ #category : #navigation }
GLHProject >> mergeRequestsGroup [
	<generated>
	<navigation: 'MergeRequests'>
	^ MooseSpecializedGroup withAll: self mergeRequests asSet
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
