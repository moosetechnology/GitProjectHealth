"
a note (a diff) proposed in a Merge Request; can be accepted, modified or deleted

## Relations
======================

### Other
| Relation | Origin | Opposite | Type | Comment |
|---|
| `mergeRequest` | `GLHNote` | `note` | `GLHMergeRequest` | |


## Properties
======================

| Name | Type | Default value | Comment |
|---|
| `attachment` | `Object` | nil | |
| `author` | `Object` | nil | |
| `body` | `String` | nil | |
| `confidential` | `Boolean` | nil | |
| `created_at` | `Object` | nil | |
| `id` | `Number` | nil | |
| `imported` | `Boolean` | nil | |
| `imported_from` | `String` | nil | |
| `internal` | `Boolean` | nil | |
| `name` | `String` | nil | Basic name of the entity, not full reference.|
| `noteable_id` | `Number` | nil | |
| `noteable_iid` | `Number` | nil | |
| `noteable_type` | `String` | nil | |
| `project_id` | `Number` | nil | |
| `resolvable` | `Boolean` | nil | |
| `system` | `Boolean` | nil | |
| `updated_at` | `Object` | nil | |

"
Class {
	#name : #GLHNote,
	#superclass : #GLHEntity,
	#traits : 'FamixTNamedEntity',
	#classTraits : 'FamixTNamedEntity classTrait',
	#instVars : [
		'#id => FMProperty',
		'#body => FMProperty',
		'#attachment => FMProperty',
		'#author => FMProperty',
		'#created_at => FMProperty',
		'#updated_at => FMProperty',
		'#system => FMProperty',
		'#noteable_id => FMProperty',
		'#noteable_type => FMProperty',
		'#project_id => FMProperty',
		'#noteable_iid => FMProperty',
		'#resolvable => FMProperty',
		'#confidential => FMProperty',
		'#internal => FMProperty',
		'#imported => FMProperty',
		'#imported_from => FMProperty',
		'#mergeRequest => FMOne type: #GLHMergeRequest opposite: #note',
		'#position => FMOne type: #GLHNotePosition opposite: #note'
	],
	#category : #'GitLabHealth-Model-Entities'
}

{ #category : #meta }
GLHNote class >> annotation [

	<FMClass: #Note super: #GLHEntity>
	<package: #'GitLabHealth-Model'>
	<generated>
	^ self
]

{ #category : #accessing }
GLHNote >> attachment [

	<FMProperty: #attachment type: #Object>
	<generated>
	^ attachment
]

{ #category : #accessing }
GLHNote >> attachment: anObject [
	<generated>
	attachment := anObject
]

{ #category : #accessing }
GLHNote >> author [

	<FMProperty: #author type: #Object>
	<generated>
	^ author
]

{ #category : #accessing }
GLHNote >> author: anObject [
	<generated>
	author := anObject
]

{ #category : #accessing }
GLHNote >> body [

	<FMProperty: #body type: #String>
	<generated>
	^ body
]

{ #category : #accessing }
GLHNote >> body: anObject [
	<generated>
	body := anObject
]

{ #category : #accessing }
GLHNote >> confidential [

	<FMProperty: #confidential type: #Boolean>
	<generated>
	^ confidential
]

{ #category : #accessing }
GLHNote >> confidential: anObject [
	<generated>
	confidential := anObject
]

{ #category : #accessing }
GLHNote >> created_at [

	<FMProperty: #created_at type: #Object>
	<generated>
	^ created_at
]

{ #category : #accessing }
GLHNote >> created_at: anObject [
	<generated>
	created_at := anObject
]

{ #category : #accessing }
GLHNote >> id [

	<FMProperty: #id type: #Number>
	<generated>
	^ id
]

{ #category : #accessing }
GLHNote >> id: anObject [
	<generated>
	id := anObject
]

{ #category : #accessing }
GLHNote >> imported [

	<FMProperty: #imported type: #Boolean>
	<generated>
	^ imported
]

{ #category : #accessing }
GLHNote >> imported: anObject [
	<generated>
	imported := anObject
]

{ #category : #accessing }
GLHNote >> imported_from [

	<FMProperty: #imported_from type: #String>
	<generated>
	^ imported_from
]

{ #category : #accessing }
GLHNote >> imported_from: anObject [
	<generated>
	imported_from := anObject
]

{ #category : #accessing }
GLHNote >> internal [

	<FMProperty: #internal type: #Boolean>
	<generated>
	^ internal
]

{ #category : #accessing }
GLHNote >> internal: anObject [
	<generated>
	internal := anObject
]

{ #category : #accessing }
GLHNote >> mergeRequest [
	"Relation named: #mergeRequest type: #GLHMergeRequest opposite: #note"

	<generated>
	^ mergeRequest
]

{ #category : #accessing }
GLHNote >> mergeRequest: anObject [

	<generated>
	mergeRequest := anObject
]

{ #category : #accessing }
GLHNote >> noteable_id [

	<FMProperty: #noteable_id type: #Number>
	<generated>
	^ noteable_id
]

{ #category : #accessing }
GLHNote >> noteable_id: anObject [
	<generated>
	noteable_id := anObject
]

{ #category : #accessing }
GLHNote >> noteable_iid [

	<FMProperty: #noteable_iid type: #Number>
	<generated>
	^ noteable_iid
]

{ #category : #accessing }
GLHNote >> noteable_iid: anObject [
	<generated>
	noteable_iid := anObject
]

{ #category : #accessing }
GLHNote >> noteable_type [

	<FMProperty: #noteable_type type: #String>
	<generated>
	^ noteable_type
]

{ #category : #accessing }
GLHNote >> noteable_type: anObject [
	<generated>
	noteable_type := anObject
]

{ #category : #accessing }
GLHNote >> position [

	^ position
]

{ #category : #accessing }
GLHNote >> position: anObject [

	position := anObject
]

{ #category : #accessing }
GLHNote >> project_id [

	<FMProperty: #project_id type: #Number>
	<generated>
	^ project_id
]

{ #category : #accessing }
GLHNote >> project_id: anObject [
	<generated>
	project_id := anObject
]

{ #category : #accessing }
GLHNote >> resolvable [

	<FMProperty: #resolvable type: #Boolean>
	<generated>
	^ resolvable
]

{ #category : #accessing }
GLHNote >> resolvable: anObject [
	<generated>
	resolvable := anObject
]

{ #category : #accessing }
GLHNote >> system [

	<FMProperty: #system type: #Boolean>
	<generated>
	^ system
]

{ #category : #accessing }
GLHNote >> system: anObject [
	<generated>
	system := anObject
]

{ #category : #accessing }
GLHNote >> updated_at [

	<FMProperty: #updated_at type: #Object>
	<generated>
	^ updated_at
]

{ #category : #accessing }
GLHNote >> updated_at: anObject [
	<generated>
	updated_at := anObject
]
