"
a Milestone is use to track progress on groups of issues or pull requests in a repository

## Relations
======================

### Parents
| Relation | Origin | Opposite | Type | Comment |
|---|
| `project` | `GLHMilestone` | `milestone` | `GLHProject` | |

### Children
| Relation | Origin | Opposite | Type | Comment |
|---|
| `author` | `GLHMilestone` | `createdMilestone` | `GLHUser` | |
| `issue` | `GLHMilestone` | `milestone` | `GLHIssue` | |
| `mergeRequest` | `GLHMilestone` | `milestone` | `GLHMergeRequest` | |


## Properties
======================

| Name | Type | Default value | Comment |
|---|
| `closed_at` | `Object` | nil | |
| `closed_issues` | `Number` | nil | |
| `created_at` | `Object` | nil | |
| `description` | `String` | nil | |
| `due_date` | `Object` | nil | |
| `id` | `Number` | nil | |
| `name` | `String` | nil | Basic name of the entity, not full reference.|
| `open_issues` | `Number` | nil | |
| `title` | `String` | nil | |
| `updated_at` | `Object` | nil | |

"
Class {
	#name : #GLHMilestone,
	#superclass : #GLHEntity,
	#traits : 'FamixTNamedEntity',
	#classTraits : 'FamixTNamedEntity classTrait',
	#instVars : [
		'#id => FMProperty',
		'#title => FMProperty',
		'#description => FMProperty',
		'#open_issues => FMProperty',
		'#closed_issues => FMProperty',
		'#created_at => FMProperty',
		'#updated_at => FMProperty',
		'#closed_at => FMProperty',
		'#due_date => FMProperty',
		'#project => FMOne type: #GLHProject opposite: #milestone',
		'#author => FMOne type: #GLHUser opposite: #createdMilestone',
		'#issue => FMMany type: #GLHIssue opposite: #milestone',
		'#mergeRequest => FMMany type: #GLHMergeRequest opposite: #milestone'
	],
	#category : #'GitLabHealth-Model-Entities'
}

{ #category : #meta }
GLHMilestone class >> annotation [

	<FMClass: #Milestone super: #GLHEntity>
	<package: #'GitLabHealth-Model'>
	<generated>
	^ self
]

{ #category : #adding }
GLHMilestone >> addIssue: anObject [
	<generated>
	^ self issue add: anObject
]

{ #category : #adding }
GLHMilestone >> addMergeRequest: anObject [
	<generated>
	^ self mergeRequest add: anObject
]

{ #category : #accessing }
GLHMilestone >> author [
	"Relation named: #author type: #GLHUser opposite: #createdMilestone"

	<generated>
	^ author
]

{ #category : #accessing }
GLHMilestone >> author: anObject [

	<generated>
	author := anObject
]

{ #category : #navigation }
GLHMilestone >> authorGroup [
	<generated>
	<navigation: 'Author'>
	^ MooseSpecializedGroup with: self author
]

{ #category : #accessing }
GLHMilestone >> closed_at [

	<FMProperty: #closed_at type: #Object>
	<generated>
	^ closed_at
]

{ #category : #accessing }
GLHMilestone >> closed_at: anObject [
	<generated>
	closed_at := anObject
]

{ #category : #accessing }
GLHMilestone >> closed_issues [

	<FMProperty: #closed_issues type: #Number>
	<generated>
	^ closed_issues
]

{ #category : #accessing }
GLHMilestone >> closed_issues: anObject [
	<generated>
	closed_issues := anObject
]

{ #category : #accessing }
GLHMilestone >> created_at [

	<FMProperty: #created_at type: #Object>
	<generated>
	^ created_at
]

{ #category : #accessing }
GLHMilestone >> created_at: anObject [
	<generated>
	created_at := anObject
]

{ #category : #accessing }
GLHMilestone >> description [

	<FMProperty: #description type: #String>
	<generated>
	^ description
]

{ #category : #accessing }
GLHMilestone >> description: anObject [
	<generated>
	description := anObject
]

{ #category : #accessing }
GLHMilestone >> due_date [

	<FMProperty: #due_date type: #Object>
	<generated>
	^ due_date
]

{ #category : #accessing }
GLHMilestone >> due_date: anObject [
	<generated>
	due_date := anObject
]

{ #category : #accessing }
GLHMilestone >> id [

	<FMProperty: #id type: #Number>
	<generated>
	^ id
]

{ #category : #accessing }
GLHMilestone >> id: anObject [
	<generated>
	id := anObject
]

{ #category : #accessing }
GLHMilestone >> issue [
	"Relation named: #issue type: #GLHIssue opposite: #milestone"

	<generated>
	<derived>
	^ issue
]

{ #category : #accessing }
GLHMilestone >> issue: anObject [

	<generated>
	issue value: anObject
]

{ #category : #navigation }
GLHMilestone >> issueGroup [
	<generated>
	<navigation: 'Issue'>
	^ MooseSpecializedGroup withAll: self issue asSet
]

{ #category : #accessing }
GLHMilestone >> mergeRequest [
	"Relation named: #mergeRequest type: #GLHMergeRequest opposite: #milestone"

	<generated>
	<derived>
	^ mergeRequest
]

{ #category : #accessing }
GLHMilestone >> mergeRequest: anObject [

	<generated>
	mergeRequest value: anObject
]

{ #category : #navigation }
GLHMilestone >> mergeRequestGroup [
	<generated>
	<navigation: 'MergeRequest'>
	^ MooseSpecializedGroup withAll: self mergeRequest asSet
]

{ #category : #accessing }
GLHMilestone >> open_issues [

	<FMProperty: #open_issues type: #Number>
	<generated>
	^ open_issues
]

{ #category : #accessing }
GLHMilestone >> open_issues: anObject [
	<generated>
	open_issues := anObject
]

{ #category : #accessing }
GLHMilestone >> project [
	"Relation named: #project type: #GLHProject opposite: #milestone"

	<generated>
	<container>
	^ project
]

{ #category : #accessing }
GLHMilestone >> project: anObject [

	<generated>
	project := anObject
]

{ #category : #navigation }
GLHMilestone >> projectGroup [
	<generated>
	<navigation: 'Project'>
	^ MooseSpecializedGroup with: self project
]

{ #category : #accessing }
GLHMilestone >> title [

	<FMProperty: #title type: #String>
	<generated>
	^ title
]

{ #category : #accessing }
GLHMilestone >> title: anObject [
	<generated>
	title := anObject
]

{ #category : #accessing }
GLHMilestone >> updated_at [

	<FMProperty: #updated_at type: #Object>
	<generated>
	^ updated_at
]

{ #category : #accessing }
GLHMilestone >> updated_at: anObject [
	<generated>
	updated_at := anObject
]
