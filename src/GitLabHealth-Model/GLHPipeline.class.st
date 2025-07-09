"
A GitLab Pipeline execution

## Relations
======================

### Parents
| Relation | Origin | Opposite | Type | Comment |
|---|
| `mergeResquest` | `GLHPipeline` | `pipelines` | `GLHMergeRequest` | |
| `project` | `GLHPipeline` | `pipelines` | `GLHProject` | |

### Children
| Relation | Origin | Opposite | Type | Comment |
|---|
| `jobs` | `GLHPipeline` | `pipeline` | `GLHJob` | |

### Other
| Relation | Origin | Opposite | Type | Comment |
|---|
| `user` | `GLHPipeline` | `launchedPipelines` | `GLHUser` | |


## Properties
======================

| Name | Type | Default value | Comment |
|---|
| `created_at` | `Object` | nil | creation date of the pipeline|
| `duration` | `Object` | nil | the running duration of a pipeline|
| `finished_at` | `Object` | nil | finish date of the pipeline|
| `id` | `String` | nil | The id of the pipeline|
| `name` | `String` | nil | name of the pipeline|
| `ref` | `String` | nil | reference its emmited source (merge request or else)|
| `runDate` | `Object` | nil | Date this pipeline was run|
| `sha` | `String` | nil | sha of its emmited source|
| `sourceEvent` | `String` | nil | triggering event from where the pipeline originate, such as #push #fork, etc.|
| `started_at` | `Object` | nil | start date of the pipeline|
| `status` | `String` | nil | #success or #failure|
| `updated_at` | `Object` | nil | update date of the pipeline|

"
Class {
	#name : #GLHPipeline,
	#superclass : #GLHEntity,
	#instVars : [
		'#id => FMProperty',
		'#name => FMProperty',
		'#status => FMProperty',
		'#ref => FMProperty',
		'#sha => FMProperty',
		'#sourceEvent => FMProperty',
		'#runDate => FMProperty',
		'#created_at => FMProperty',
		'#updated_at => FMProperty',
		'#started_at => FMProperty',
		'#finished_at => FMProperty',
		'#duration => FMProperty',
		'#jobs => FMMany type: #GLHJob opposite: #pipeline',
		'#user => FMOne type: #GLHUser opposite: #launchedPipelines',
		'#project => FMOne type: #GLHProject opposite: #pipelines',
		'#mergeResquest => FMOne type: #GLHMergeRequest opposite: #pipelines'
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
GLHPipeline >> created_at [

	<FMProperty: #created_at type: #Object>
	<generated>
	<FMComment: 'creation date of the pipeline'>
	^ created_at
]

{ #category : #accessing }
GLHPipeline >> created_at: anObject [
	<generated>
	created_at := anObject
]

{ #category : #accessing }
GLHPipeline >> duration [

	<FMProperty: #duration type: #Object>
	<generated>
	<FMComment: 'the running duration of a pipeline'>
	^ duration
]

{ #category : #accessing }
GLHPipeline >> duration: anObject [
	<generated>
	duration := anObject
]

{ #category : #accessing }
GLHPipeline >> finished_at [

	<FMProperty: #finished_at type: #Object>
	<generated>
	<FMComment: 'finish date of the pipeline'>
	^ finished_at
]

{ #category : #accessing }
GLHPipeline >> finished_at: anObject [
	<generated>
	finished_at := anObject
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
GLHPipeline >> mergeResquest [
	"Relation named: #mergeResquest type: #GLHMergeRequest opposite: #pipelines"

	<generated>
	<container>
	^ mergeResquest
]

{ #category : #accessing }
GLHPipeline >> mergeResquest: anObject [

	<generated>
	mergeResquest := anObject
]

{ #category : #navigation }
GLHPipeline >> mergeResquestGroup [
	<generated>
	<navigation: 'MergeResquest'>
	^ MooseSpecializedGroup with: self mergeResquest
]

{ #category : #accessing }
GLHPipeline >> name [

	<FMProperty: #name type: #String>
	<generated>
	<FMComment: 'name of the pipeline'>
	^ name
]

{ #category : #accessing }
GLHPipeline >> name: anObject [
	<generated>
	name := anObject
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
GLHPipeline >> ref [

	<FMProperty: #ref type: #String>
	<generated>
	<FMComment: 'reference its emmited source (merge request or else)'>
	^ ref
]

{ #category : #accessing }
GLHPipeline >> ref: anObject [
	<generated>
	ref := anObject
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
GLHPipeline >> sha [

	<FMProperty: #sha type: #String>
	<generated>
	<FMComment: 'sha of its emmited source'>
	^ sha
]

{ #category : #accessing }
GLHPipeline >> sha: anObject [
	<generated>
	sha := anObject
]

{ #category : #accessing }
GLHPipeline >> sourceEvent [

	<FMProperty: #sourceEvent type: #String>
	<generated>
	<FMComment: 'triggering event from where the pipeline originate, such as #push #fork, etc.'>
	^ sourceEvent
]

{ #category : #accessing }
GLHPipeline >> sourceEvent: anObject [
	<generated>
	sourceEvent := anObject
]

{ #category : #accessing }
GLHPipeline >> started_at [

	<FMProperty: #started_at type: #Object>
	<generated>
	<FMComment: 'start date of the pipeline'>
	^ started_at
]

{ #category : #accessing }
GLHPipeline >> started_at: anObject [
	<generated>
	started_at := anObject
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

{ #category : #accessing }
GLHPipeline >> updated_at [

	<FMProperty: #updated_at type: #Object>
	<generated>
	<FMComment: 'update date of the pipeline'>
	^ updated_at
]

{ #category : #accessing }
GLHPipeline >> updated_at: anObject [
	<generated>
	updated_at := anObject
]

{ #category : #accessing }
GLHPipeline >> user [
	"Relation named: #user type: #GLHUser opposite: #launchedPipelines"

	<generated>
	^ user
]

{ #category : #accessing }
GLHPipeline >> user: anObject [

	<generated>
	user := anObject
]
