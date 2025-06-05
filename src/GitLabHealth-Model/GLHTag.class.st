"
a Tag is a reference to a specific point in the repository's history

## Relations
======================

### Other
| Relation | Origin | Opposite | Type | Comment |
|---|
| `commit` | `GLHTag` | `tag` | `GLHCommit` | |
| `release` | `GLHTag` | `tag` | `GLHRelease` | |


## Properties
======================

| Name | Type | Default value | Comment |
|---|
| `created_at` | `Object` | nil | |
| `message` | `String` | nil | |
| `name` | `String` | nil | |
| `protected` | `Boolean` | nil | |
| `target` | `String` | nil | |

"
Class {
	#name : #GLHTag,
	#superclass : #GLHEntity,
	#instVars : [
		'#name => FMProperty',
		'#message => FMProperty',
		'#target => FMProperty',
		'#protected => FMProperty',
		'#created_at => FMProperty',
		'#commit => FMOne type: #GLHCommit opposite: #tag',
		'#release => FMOne type: #GLHRelease opposite: #tag'
	],
	#category : #'GitLabHealth-Model-Entities'
}

{ #category : #meta }
GLHTag class >> annotation [

	<FMClass: #Tag super: #GLHEntity>
	<package: #'GitLabHealth-Model'>
	<generated>
	^ self
]

{ #category : #accessing }
GLHTag >> commit [
	"Relation named: #commit type: #GLHCommit opposite: #tag"

	<generated>
	^ commit
]

{ #category : #accessing }
GLHTag >> commit: anObject [

	<generated>
	commit := anObject
]

{ #category : #accessing }
GLHTag >> created_at [

	<FMProperty: #created_at type: #Object>
	<generated>
	^ created_at
]

{ #category : #accessing }
GLHTag >> created_at: anObject [
	<generated>
	created_at := anObject
]

{ #category : #accessing }
GLHTag >> message [

	<FMProperty: #message type: #String>
	<generated>
	^ message
]

{ #category : #accessing }
GLHTag >> message: anObject [
	<generated>
	message := anObject
]

{ #category : #accessing }
GLHTag >> name [

	<FMProperty: #name type: #String>
	<generated>
	^ name
]

{ #category : #accessing }
GLHTag >> name: anObject [
	<generated>
	name := anObject
]

{ #category : #accessing }
GLHTag >> protected [

	<FMProperty: #protected type: #Boolean>
	<generated>
	^ protected
]

{ #category : #accessing }
GLHTag >> protected: anObject [
	<generated>
	protected := anObject
]

{ #category : #accessing }
GLHTag >> release [
	"Relation named: #release type: #GLHRelease opposite: #tag"

	<generated>
	^ release
]

{ #category : #accessing }
GLHTag >> release: anObject [

	<generated>
	release := anObject
]

{ #category : #accessing }
GLHTag >> target [

	<FMProperty: #target type: #String>
	<generated>
	^ target
]

{ #category : #accessing }
GLHTag >> target: anObject [
	<generated>
	target := anObject
]
