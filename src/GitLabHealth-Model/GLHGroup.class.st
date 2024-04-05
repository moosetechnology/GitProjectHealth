"
A GitLab Group

## Relations
======================

### Parents
| Relation | Origin | Opposite | Type | Comment |
|---|
| `group` | `GLHGroup` | `subGroups` | `GLHGroup` | |

### Children
| Relation | Origin | Opposite | Type | Comment |
|---|
| `projects` | `GLHGroup` | `group` | `GLHProject` | |
| `subGroups` | `GLHGroup` | `group` | `GLHGroup` | |


## Properties
======================

| Name | Type | Default value | Comment |
|---|
| `avatar_url` | `String` | nil | |
| `description` | `String` | nil | |
| `id` | `Number` | nil | |
| `name` | `String` | nil | Basic name of the entity, not full reference.|
| `visibility` | `String` | nil | |
| `web_url` | `String` | nil | |

"
Class {
	#name : #GLHGroup,
	#superclass : #GLHEntity,
	#traits : 'FamixTNamedEntity',
	#classTraits : 'FamixTNamedEntity classTrait',
	#instVars : [
		'#id => FMProperty',
		'#web_url => FMProperty',
		'#description => FMProperty',
		'#visibility => FMProperty',
		'#avatar_url => FMProperty',
		'#projects => FMMany type: #GLHProject opposite: #group',
		'#subGroups => FMMany type: #GLHGroup opposite: #group',
		'#group => FMOne type: #GLHGroup opposite: #subGroups'
	],
	#category : #'GitLabHealth-Model-Entities'
}

{ #category : #meta }
GLHGroup class >> annotation [

	<FMClass: #Group super: #GLHEntity>
	<package: #'GitLabHealth-Model'>
	<generated>
	^ self
]

{ #category : #adding }
GLHGroup >> addProject: anObject [
	<generated>
	^ self projects add: anObject
]

{ #category : #adding }
GLHGroup >> addSubGroup: anObject [
	<generated>
	^ self subGroups add: anObject
]

{ #category : #accessing }
GLHGroup >> avatar_url [

	<FMProperty: #avatar_url type: #String>
	<generated>
	^ avatar_url
]

{ #category : #accessing }
GLHGroup >> avatar_url: anObject [
	<generated>
	avatar_url := anObject
]

{ #category : #accessing }
GLHGroup >> description [

	<FMProperty: #description type: #String>
	<generated>
	^ description
]

{ #category : #accessing }
GLHGroup >> description: anObject [
	<generated>
	description := anObject
]

{ #category : #accessing }
GLHGroup >> group [
	"Relation named: #group type: #GLHGroup opposite: #subGroups"

	<generated>
	<container>
	^ group
]

{ #category : #accessing }
GLHGroup >> group: anObject [

	<generated>
	group := anObject
]

{ #category : #navigation }
GLHGroup >> groupGroup [
	<generated>
	<navigation: 'Group'>
	^ MooseSpecializedGroup with: self group
]

{ #category : #accessing }
GLHGroup >> id [

	<FMProperty: #id type: #Number>
	<generated>
	^ id
]

{ #category : #accessing }
GLHGroup >> id: anObject [
	<generated>
	id := anObject
]

{ #category : #accessing }
GLHGroup >> projects [
	"Relation named: #projects type: #GLHProject opposite: #group"

	<generated>
	<derived>
	^ projects
]

{ #category : #accessing }
GLHGroup >> projects: anObject [

	<generated>
	projects value: anObject
]

{ #category : #navigation }
GLHGroup >> projectsGroup [
	<generated>
	<navigation: 'Projects'>
	^ MooseSpecializedGroup withAll: self projects asSet
]

{ #category : #accessing }
GLHGroup >> subGroups [
	"Relation named: #subGroups type: #GLHGroup opposite: #group"

	<generated>
	<derived>
	^ subGroups
]

{ #category : #accessing }
GLHGroup >> subGroups: anObject [

	<generated>
	subGroups value: anObject
]

{ #category : #navigation }
GLHGroup >> subGroupsGroup [
	<generated>
	<navigation: 'SubGroups'>
	^ MooseSpecializedGroup withAll: self subGroups asSet
]

{ #category : #accessing }
GLHGroup >> visibility [

	<FMProperty: #visibility type: #String>
	<generated>
	^ visibility
]

{ #category : #accessing }
GLHGroup >> visibility: anObject [
	<generated>
	visibility := anObject
]

{ #category : #accessing }
GLHGroup >> web_url [

	<FMProperty: #web_url type: #String>
	<generated>
	^ web_url
]

{ #category : #accessing }
GLHGroup >> web_url: anObject [
	<generated>
	web_url := anObject
]
