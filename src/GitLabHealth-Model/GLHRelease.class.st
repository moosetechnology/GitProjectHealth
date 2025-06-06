"
a Release is typically associated with a tag and provide additional metadata and assets that can be distributed to users

## Relations
======================

### Parents
| Relation | Origin | Opposite | Type | Comment |
|---|
| `author` | `GLHRelease` | `releases` | `GLHUser` | |
| `project` | `GLHRelease` | `releases` | `GLHProject` | |

### Other
| Relation | Origin | Opposite | Type | Comment |
|---|
| `tag` | `GLHRelease` | `release` | `GLHTag` | |


## Properties
======================

| Name | Type | Default value | Comment |
|---|
| `commit_path` | `String` | nil | |
| `created_at` | `Object` | nil | |
| `description` | `String` | nil | |
| `name` | `String` | nil | |
| `released_at` | `Object` | nil | |
| `tag_name` | `String` | nil | |
| `tag_path` | `String` | nil | |

"
Class {
	#name : #GLHRelease,
	#superclass : #GLHEntity,
	#instVars : [
		'#description => FMProperty',
		'#tag_name => FMProperty',
		'#name => FMProperty',
		'#created_at => FMProperty',
		'#released_at => FMProperty',
		'#commit_path => FMProperty',
		'#tag_path => FMProperty',
		'#tag => FMOne type: #GLHTag opposite: #release',
		'#author => FMOne type: #GLHUser opposite: #releases',
		'#project => FMOne type: #GLHProject opposite: #releases'
	],
	#category : #'GitLabHealth-Model-Entities'
}

{ #category : #meta }
GLHRelease class >> annotation [

	<FMClass: #Release super: #GLHEntity>
	<package: #'GitLabHealth-Model'>
	<generated>
	^ self
]

{ #category : #accessing }
GLHRelease >> author [
	"Relation named: #author type: #GLHUser opposite: #releases"

	<generated>
	<container>
	^ author
]

{ #category : #accessing }
GLHRelease >> author: anObject [

	<generated>
	author := anObject
]

{ #category : #navigation }
GLHRelease >> authorGroup [
	<generated>
	<navigation: 'Author'>
	^ MooseSpecializedGroup with: self author
]

{ #category : #accessing }
GLHRelease >> commit_path [

	<FMProperty: #commit_path type: #String>
	<generated>
	^ commit_path
]

{ #category : #accessing }
GLHRelease >> commit_path: anObject [
	<generated>
	commit_path := anObject
]

{ #category : #accessing }
GLHRelease >> created_at [

	<FMProperty: #created_at type: #Object>
	<generated>
	^ created_at
]

{ #category : #accessing }
GLHRelease >> created_at: anObject [
	<generated>
	created_at := anObject
]

{ #category : #accessing }
GLHRelease >> description [

	<FMProperty: #description type: #String>
	<generated>
	^ description
]

{ #category : #accessing }
GLHRelease >> description: anObject [
	<generated>
	description := anObject
]

{ #category : #accessing }
GLHRelease >> name: anObject [
	<generated>
	name := anObject
]

{ #category : #accessing }
GLHRelease >> project [
	"Relation named: #project type: #GLHProject opposite: #releases"

	<generated>
	<container>
	^ project
]

{ #category : #accessing }
GLHRelease >> project: anObject [

	<generated>
	project := anObject
]

{ #category : #navigation }
GLHRelease >> projectGroup [
	<generated>
	<navigation: 'Project'>
	^ MooseSpecializedGroup with: self project
]

{ #category : #accessing }
GLHRelease >> released_at [

	<FMProperty: #released_at type: #Object>
	<generated>
	^ released_at
]

{ #category : #accessing }
GLHRelease >> released_at: anObject [
	<generated>
	released_at := anObject
]

{ #category : #accessing }
GLHRelease >> tag [
	"Relation named: #tag type: #GLHTag opposite: #release"

	<generated>
	<derived>
	^ tag
]

{ #category : #accessing }
GLHRelease >> tag: anObject [

	<generated>
	tag := anObject
]

{ #category : #accessing }
GLHRelease >> tag_name [

	<FMProperty: #tag_name type: #String>
	<generated>
	^ tag_name
]

{ #category : #accessing }
GLHRelease >> tag_name: anObject [
	<generated>
	tag_name := anObject
]

{ #category : #accessing }
GLHRelease >> tag_path [

	<FMProperty: #tag_path type: #String>
	<generated>
	^ tag_path
]

{ #category : #accessing }
GLHRelease >> tag_path: anObject [
	<generated>
	tag_path := anObject
]
