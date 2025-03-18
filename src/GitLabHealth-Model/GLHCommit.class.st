"
a commit attached to a repository

## Relations
======================

### Parents
| Relation | Origin | Opposite | Type | Comment |
|---|
| `branch` | `GLHCommit` | `commits` | `GLHBranch` | |
| `commitCreator` | `GLHCommit` | `commits` | `GLHUser` | |
| `repository` | `GLHCommit` | `commits` | `GLHRepository` | |

### Children
| Relation | Origin | Opposite | Type | Comment |
|---|
| `diffs` | `GLHCommit` | `commit` | `GLHDiff` | |
| `jobs` | `GLHCommit` | `commit` | `GLHJob` | |

### Other
| Relation | Origin | Opposite | Type | Comment |
|---|
| `childCommits` | `GLHCommit` | `parentCommits` | `GLHCommit` | |
| `commitedMergeRequest` | `GLHCommit` | `mergeRequestCommit` | `GLHMergeRequest` | |
| `commitedMergeRequest` | `GLHCommit` | `mergedCommit` | `GLHMergeRequest` | |
| `parentCommits` | `GLHCommit` | `childCommits` | `GLHCommit` | |
| `squashedMergeRequest` | `GLHCommit` | `squashCommit` | `GLHMergeRequest` | |


## Properties
======================

| Name | Type | Default value | Comment |
|---|
| `additions` | `Number` | nil | The number of line that git consider added|
| `author_email` | `String` | nil | |
| `author_name` | `String` | nil | |
| `authored_date` | `Object` | nil | |
| `committed_date` | `Object` | nil | |
| `committer_email` | `String` | nil | |
| `committer_name` | `String` | nil | |
| `created_at` | `Object` | nil | |
| `deletions` | `Number` | nil | The number of line that git consider deleted|
| `id` | `String` | nil | |
| `message` | `String` | nil | |
| `name` | `String` | nil | Basic name of the entity, not full reference.|
| `parent_ids` | `Object` | 'OrderedCollection new' | |
| `short_id` | `String` | nil | |
| `title` | `String` | nil | |
| `web_url` | `String` | nil | |

"
Class {
	#name : #GLHCommit,
	#superclass : #GLHEntity,
	#traits : 'FamixTNamedEntity',
	#classTraits : 'FamixTNamedEntity classTrait',
	#instVars : [
		'#additions => FMProperty',
		'#author_email => FMProperty',
		'#author_name => FMProperty',
		'#authored_date => FMProperty',
		'#branch => FMOne type: #GLHBranch opposite: #commits',
		'#childCommits => FMMany type: #GLHCommit opposite: #parentCommits',
		'#commitCreator => FMOne type: #GLHUser opposite: #commits',
		'#commitedMergeRequest => FMOne type: #GLHMergeRequest opposite: #mergedCommit',
		'#committed_date => FMProperty',
		'#committer_email => FMProperty',
		'#committer_name => FMProperty',
		'#created_at => FMProperty',
		'#deletions => FMProperty',
		'#diffs => FMMany type: #GLHDiff opposite: #commit',
		'#id => FMProperty',
		'#jobs => FMMany type: #GLHJob opposite: #commit',
		'#message => FMProperty',
		'#parentCommits => FMMany type: #GLHCommit opposite: #childCommits',
		'#parent_ids => FMProperty defaultValue: \'OrderedCollection new\'',
		'#repository => FMOne type: #GLHRepository opposite: #commits',
		'#short_id => FMProperty',
		'#squashedMergeRequest => FMOne type: #GLHMergeRequest opposite: #squashCommit',
		'#title => FMProperty',
		'#web_url => FMProperty'
	],
	#category : #'GitLabHealth-Model-Entities'
}

{ #category : #meta }
GLHCommit class >> annotation [

	<FMClass: #Commit super: #GLHEntity>
	<package: #'GitLabHealth-Model'>
	<generated>
	^ self
]

{ #category : #adding }
GLHCommit >> addChildCommit: anObject [
	<generated>
	^ self childCommits add: anObject
]

{ #category : #adding }
GLHCommit >> addDiff: anObject [
	<generated>
	^ self diffs add: anObject
]

{ #category : #adding }
GLHCommit >> addJob: anObject [
	<generated>
	^ self jobs add: anObject
]

{ #category : #adding }
GLHCommit >> addParentCommit: anObject [
	<generated>
	^ self parentCommits add: anObject
]

{ #category : #accessing }
GLHCommit >> additions [

	<FMProperty: #additions type: #Number>
	<generated>
	<FMComment: 'The number of line that git consider added'>
	^ additions
]

{ #category : #accessing }
GLHCommit >> additions: anObject [
	<generated>
	additions := anObject
]

{ #category : #accessing }
GLHCommit >> author_email [

	<FMProperty: #author_email type: #String>
	<generated>
	^ author_email
]

{ #category : #accessing }
GLHCommit >> author_email: anObject [
	<generated>
	author_email := anObject
]

{ #category : #accessing }
GLHCommit >> author_name [

	<FMProperty: #author_name type: #String>
	<generated>
	^ author_name
]

{ #category : #accessing }
GLHCommit >> author_name: anObject [
	<generated>
	author_name := anObject
]

{ #category : #accessing }
GLHCommit >> authored_date [

	<FMProperty: #authored_date type: #Object>
	<generated>
	^ authored_date
]

{ #category : #accessing }
GLHCommit >> authored_date: anObject [
	<generated>
	authored_date := anObject
]

{ #category : #accessing }
GLHCommit >> branch [
	"Relation named: #branch type: #GLHBranch opposite: #commits"

	<generated>
	<container>
	^ branch
]

{ #category : #accessing }
GLHCommit >> branch: anObject [

	<generated>
	branch := anObject
]

{ #category : #navigation }
GLHCommit >> branchGroup [
	<generated>
	<navigation: 'Branch'>
	^ MooseSpecializedGroup with: self branch
]

{ #category : #accessing }
GLHCommit >> childCommits [
	"Relation named: #childCommits type: #GLHCommit opposite: #parentCommits"

	<generated>
	^ childCommits
]

{ #category : #accessing }
GLHCommit >> childCommits: anObject [

	<generated>
	childCommits value: anObject
]

{ #category : #accessing }
GLHCommit >> commitCreator [
	"Relation named: #commitCreator type: #GLHUser opposite: #commits"

	<generated>
	<container>
	^ commitCreator
]

{ #category : #accessing }
GLHCommit >> commitCreator: anObject [

	<generated>
	commitCreator := anObject
]

{ #category : #navigation }
GLHCommit >> commitCreatorGroup [
	<generated>
	<navigation: 'CommitCreator'>
	^ MooseSpecializedGroup with: self commitCreator
]

{ #category : #accessing }
GLHCommit >> commitedMergeRequest [
	"Relation named: #commitedMergeRequest type: #GLHMergeRequest opposite: #mergedCommit"

	<generated>
	<derived>
	^ commitedMergeRequest
]

{ #category : #accessing }
GLHCommit >> commitedMergeRequest: anObject [

	<generated>
	commitedMergeRequest := anObject
]

{ #category : #accessing }
GLHCommit >> committed_date [

	<FMProperty: #committed_date type: #Object>
	<generated>
	^ committed_date
]

{ #category : #accessing }
GLHCommit >> committed_date: anObject [
	<generated>
	committed_date := anObject
]

{ #category : #accessing }
GLHCommit >> committer_email [

	<FMProperty: #committer_email type: #String>
	<generated>
	^ committer_email
]

{ #category : #accessing }
GLHCommit >> committer_email: anObject [
	<generated>
	committer_email := anObject
]

{ #category : #accessing }
GLHCommit >> committer_name [

	<FMProperty: #committer_name type: #String>
	<generated>
	^ committer_name
]

{ #category : #accessing }
GLHCommit >> committer_name: anObject [
	<generated>
	committer_name := anObject
]

{ #category : #accessing }
GLHCommit >> created_at [

	<FMProperty: #created_at type: #Object>
	<generated>
	^ created_at
]

{ #category : #accessing }
GLHCommit >> created_at: anObject [
	<generated>
	created_at := anObject
]

{ #category : #accessing }
GLHCommit >> deletions [

	<FMProperty: #deletions type: #Number>
	<generated>
	<FMComment: 'The number of line that git consider deleted'>
	^ deletions
]

{ #category : #accessing }
GLHCommit >> deletions: anObject [
	<generated>
	deletions := anObject
]

{ #category : #accessing }
GLHCommit >> diffs [
	"Relation named: #diffs type: #GLHDiff opposite: #commit"

	<generated>
	<derived>
	^ diffs
]

{ #category : #accessing }
GLHCommit >> diffs: anObject [

	<generated>
	diffs value: anObject
]

{ #category : #navigation }
GLHCommit >> diffsGroup [
	<generated>
	<navigation: 'Diffs'>
	^ MooseSpecializedGroup withAll: self diffs asSet
]

{ #category : #accessing }
GLHCommit >> id [

	<FMProperty: #id type: #String>
	<generated>
	^ id
]

{ #category : #accessing }
GLHCommit >> id: anObject [
	<generated>
	id := anObject
]

{ #category : #accessing }
GLHCommit >> jobs [
	"Relation named: #jobs type: #GLHJob opposite: #commit"

	<generated>
	<derived>
	^ jobs
]

{ #category : #accessing }
GLHCommit >> jobs: anObject [

	<generated>
	jobs value: anObject
]

{ #category : #navigation }
GLHCommit >> jobsGroup [
	<generated>
	<navigation: 'Jobs'>
	^ MooseSpecializedGroup withAll: self jobs asSet
]

{ #category : #accessing }
GLHCommit >> message [

	<FMProperty: #message type: #String>
	<generated>
	^ message
]

{ #category : #accessing }
GLHCommit >> message: anObject [
	<generated>
	message := anObject
]

{ #category : #accessing }
GLHCommit >> parentCommits [
	"Relation named: #parentCommits type: #GLHCommit opposite: #childCommits"

	<generated>
	<derived>
	^ parentCommits
]

{ #category : #accessing }
GLHCommit >> parentCommits: anObject [

	<generated>
	parentCommits value: anObject
]

{ #category : #accessing }
GLHCommit >> parent_ids: anObject [
	<generated>
	parent_ids := anObject
]

{ #category : #accessing }
GLHCommit >> repository [
	"Relation named: #repository type: #GLHRepository opposite: #commits"

	<generated>
	<container>
	^ repository
]

{ #category : #accessing }
GLHCommit >> repository: anObject [

	<generated>
	repository := anObject
]

{ #category : #navigation }
GLHCommit >> repositoryGroup [
	<generated>
	<navigation: 'Repository'>
	^ MooseSpecializedGroup with: self repository
]

{ #category : #accessing }
GLHCommit >> short_id [

	<FMProperty: #short_id type: #String>
	<generated>
	^ short_id
]

{ #category : #accessing }
GLHCommit >> short_id: anObject [
	<generated>
	short_id := anObject
]

{ #category : #accessing }
GLHCommit >> squashedMergeRequest [
	"Relation named: #squashedMergeRequest type: #GLHMergeRequest opposite: #squashCommit"

	<generated>
	<derived>
	^ squashedMergeRequest
]

{ #category : #accessing }
GLHCommit >> squashedMergeRequest: anObject [

	<generated>
	squashedMergeRequest := anObject
]

{ #category : #accessing }
GLHCommit >> title [

	<FMProperty: #title type: #String>
	<generated>
	^ title
]

{ #category : #accessing }
GLHCommit >> title: anObject [
	<generated>
	title := anObject
]

{ #category : #accessing }
GLHCommit >> web_url [

	<FMProperty: #web_url type: #String>
	<generated>
	^ web_url
]

{ #category : #accessing }
GLHCommit >> web_url: anObject [
	<generated>
	web_url := anObject
]
