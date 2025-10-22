"
an Issues help collaboration within a team to plan, track, and deliver work

## Relations
======================

### Parents
| Relation | Origin | Opposite | Type | Comment |
|---|
| `author` | `GLHIssue` | `createdIssue` | `GLHUser` | |
| `milestone` | `GLHIssue` | `issue` | `GLHMilestone` | |
| `project` | `GLHIssue` | `issues` | `GLHProject` | |

### Children
| Relation | Origin | Opposite | Type | Comment |
|---|
| `assignees` | `GLHIssue` | `assignedIssue` | `GLHUser` | |


## Properties
======================

| Name | Type | Default value | Comment |
|---|
| `closed_at` | `Object` | nil | |
| `created_at` | `Object` | nil | |
| `description` | `String` | nil | |
| `due_date` | `Object` | nil | |
| `id` | `Number` | nil | |
| `name` | `String` | nil | Basic name of the entity, not full reference.|
| `name` | `String` | nil | |
| `state` | `String` | nil | |
| `updated_at` | `Object` | nil | |

"
Class {
	#name : #GLHIssue,
	#superclass : #GLHEntity,
	#traits : 'FamixTNamedEntity',
	#classTraits : 'FamixTNamedEntity classTrait',
	#instVars : [
		'#name => FMProperty',
		'#description => FMProperty',
		'#state => FMProperty',
		'#id => FMProperty',
		'#created_at => FMProperty',
		'#updated_at => FMProperty',
		'#closed_at => FMProperty',
		'#due_date => FMProperty',
		'#project => FMOne type: #GLHProject opposite: #issues',
		'#assignees => FMMany type: #GLHUser opposite: #assignedIssue',
		'#author => FMOne type: #GLHUser opposite: #createdIssue',
		'#milestone => FMOne type: #GLHMilestone opposite: #issue'
	],
	#category : #'GitLabHealth-Model-Entities'
}

{ #category : #meta }
GLHIssue class >> annotation [

	<FMClass: #Issue super: #GLHEntity>
	<package: #'GitLabHealth-Model'>
	<generated>
	^ self
]

{ #category : #adding }
GLHIssue >> addAssignee: anObject [
	<generated>
	^ self assignees add: anObject
]

{ #category : #accessing }
GLHIssue >> assignees [
	"Relation named: #assignees type: #GLHUser opposite: #assignedIssue"

	<generated>
	<derived>
	^ assignees
]

{ #category : #accessing }
GLHIssue >> assignees: anObject [

	<generated>
	assignees value: anObject
]

{ #category : #navigation }
GLHIssue >> assigneesGroup [
	<generated>
	<navigation: 'Assignees'>
	^ MooseSpecializedGroup withAll: self assignees asSet
]

{ #category : #accessing }
GLHIssue >> author [
	"Relation named: #author type: #GLHUser opposite: #createdIssue"

	<generated>
	<container>
	^ author
]

{ #category : #accessing }
GLHIssue >> author: anObject [

	<generated>
	author := anObject
]

{ #category : #navigation }
GLHIssue >> authorGroup [
	<generated>
	<navigation: 'Author'>
	^ MooseSpecializedGroup with: self author
]

{ #category : #accessing }
GLHIssue >> closed_at [

	<FMProperty: #closed_at type: #Object>
	<generated>
	^ closed_at
]

{ #category : #accessing }
GLHIssue >> closed_at: anObject [
	<generated>
	closed_at := anObject
]

{ #category : #accessing }
GLHIssue >> created_at [

	<FMProperty: #created_at type: #Object>
	<generated>
	^ created_at
]

{ #category : #accessing }
GLHIssue >> created_at: anObject [
	<generated>
	created_at := anObject
]

{ #category : #accessing }
GLHIssue >> description [

	<FMProperty: #description type: #String>
	<generated>
	^ description
]

{ #category : #accessing }
GLHIssue >> description: anObject [
	<generated>
	description := anObject
]

{ #category : #accessing }
GLHIssue >> due_date [

	<FMProperty: #due_date type: #Object>
	<generated>
	^ due_date
]

{ #category : #accessing }
GLHIssue >> due_date: anObject [
	<generated>
	due_date := anObject
]

{ #category : #accessing }
GLHIssue >> id [

	<FMProperty: #id type: #Number>
	<generated>
	^ id
]

{ #category : #accessing }
GLHIssue >> id: anObject [
	<generated>
	id := anObject
]

{ #category : #accessing }
GLHIssue >> milestone [
	"Relation named: #milestone type: #GLHMilestone opposite: #issue"

	<generated>
	<container>
	^ milestone
]

{ #category : #accessing }
GLHIssue >> milestone: anObject [

	<generated>
	milestone := anObject
]

{ #category : #navigation }
GLHIssue >> milestoneGroup [
	<generated>
	<navigation: 'Milestone'>
	^ MooseSpecializedGroup with: self milestone
]

{ #category : #accessing }
GLHIssue >> name [

	<FMProperty: #name type: #String>
	<generated>
	^ name
]

{ #category : #accessing }
GLHIssue >> name: anObject [
	<generated>
	name := anObject
]

{ #category : #accessing }
GLHIssue >> project [
	"Relation named: #project type: #GLHProject opposite: #issues"

	<generated>
	<container>
	^ project
]

{ #category : #accessing }
GLHIssue >> project: anObject [

	<generated>
	project := anObject
]

{ #category : #navigation }
GLHIssue >> projectGroup [
	<generated>
	<navigation: 'Project'>
	^ MooseSpecializedGroup with: self project
]

{ #category : #accessing }
GLHIssue >> state [

	<FMProperty: #state type: #String>
	<generated>
	^ state
]

{ #category : #accessing }
GLHIssue >> state: anObject [
	<generated>
	state := anObject
]

{ #category : #accessing }
GLHIssue >> updated_at [

	<FMProperty: #updated_at type: #Object>
	<generated>
	^ updated_at
]

{ #category : #accessing }
GLHIssue >> updated_at: anObject [
	<generated>
	updated_at := anObject
]
