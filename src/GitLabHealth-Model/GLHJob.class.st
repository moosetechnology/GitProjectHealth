"
A CI Job

## Relations
======================

### Parents
| Relation | Origin | Opposite | Type | Comment |
|---|
| `commit` | `GLHJob` | `jobs` | `GLHCommit` | |
| `pipeline` | `GLHJob` | `jobs` | `GLHPipeline` | |
| `user` | `GLHJob` | `jobs` | `GLHUser` | |


## Properties
======================

| Name | Type | Default value | Comment |
|---|
| `allow_failure` | `Boolean` | nil | |
| `duration` | `Object` | nil | |
| `id` | `Number` | nil | |
| `name` | `String` | nil | Basic name of the entity, not full reference.|
| `name` | `String` | nil | |
| `ref` | `String` | nil | |
| `web_url` | `String` | nil | |

"
Class {
	#name : #GLHJob,
	#superclass : #GLHEntity,
	#traits : 'FamixTNamedEntity',
	#classTraits : 'FamixTNamedEntity classTrait',
	#instVars : [
		'#id => FMProperty',
		'#allow_failure => FMProperty',
		'#web_url => FMProperty',
		'#duration => FMProperty',
		'#name => FMProperty',
		'#ref => FMProperty',
		'#commit => FMOne type: #GLHCommit opposite: #jobs',
		'#pipeline => FMOne type: #GLHPipeline opposite: #jobs',
		'#user => FMOne type: #GLHUser opposite: #jobs'
	],
	#category : #'GitLabHealth-Model-Entities'
}

{ #category : #meta }
GLHJob class >> annotation [

	<FMClass: #Job super: #GLHEntity>
	<package: #'GitLabHealth-Model'>
	<generated>
	^ self
]

{ #category : #accessing }
GLHJob >> allow_failure [

	<FMProperty: #allow_failure type: #Boolean>
	<generated>
	^ allow_failure
]

{ #category : #accessing }
GLHJob >> allow_failure: anObject [
	<generated>
	allow_failure := anObject
]

{ #category : #accessing }
GLHJob >> commit [
	"Relation named: #commit type: #GLHCommit opposite: #jobs"

	<generated>
	<container>
	^ commit
]

{ #category : #accessing }
GLHJob >> commit: anObject [

	<generated>
	commit := anObject
]

{ #category : #navigation }
GLHJob >> commitGroup [
	<generated>
	<navigation: 'Commit'>
	^ MooseSpecializedGroup with: self commit
]

{ #category : #accessing }
GLHJob >> duration [

	<FMProperty: #duration type: #Object>
	<generated>
	^ duration
]

{ #category : #accessing }
GLHJob >> duration: anObject [
	<generated>
	duration := anObject
]

{ #category : #accessing }
GLHJob >> id [

	<FMProperty: #id type: #Number>
	<generated>
	^ id
]

{ #category : #accessing }
GLHJob >> id: anObject [
	<generated>
	id := anObject
]

{ #category : #accessing }
GLHJob >> name [

	<FMProperty: #name type: #String>
	<generated>
	^ name
]

{ #category : #accessing }
GLHJob >> name: anObject [
	<generated>
	name := anObject
]

{ #category : #accessing }
GLHJob >> pipeline [
	"Relation named: #pipeline type: #GLHPipeline opposite: #jobs"

	<generated>
	<container>
	^ pipeline
]

{ #category : #accessing }
GLHJob >> pipeline: anObject [

	<generated>
	pipeline := anObject
]

{ #category : #navigation }
GLHJob >> pipelineGroup [
	<generated>
	<navigation: 'Pipeline'>
	^ MooseSpecializedGroup with: self pipeline
]

{ #category : #accessing }
GLHJob >> ref [

	<FMProperty: #ref type: #String>
	<generated>
	^ ref
]

{ #category : #accessing }
GLHJob >> ref: anObject [
	<generated>
	ref := anObject
]

{ #category : #accessing }
GLHJob >> user [
	"Relation named: #user type: #GLHUser opposite: #jobs"

	<generated>
	<container>
	^ user
]

{ #category : #accessing }
GLHJob >> user: anObject [

	<generated>
	user := anObject
]

{ #category : #navigation }
GLHJob >> userGroup [
	<generated>
	<navigation: 'User'>
	^ MooseSpecializedGroup with: self user
]

{ #category : #accessing }
GLHJob >> web_url [

	<FMProperty: #web_url type: #String>
	<generated>
	^ web_url
]

{ #category : #accessing }
GLHJob >> web_url: anObject [
	<generated>
	web_url := anObject
]
