"
A git branch

## Relations
======================

### Parents
| Relation | Origin | Opposite | Type | Comment |
|---|
| `repository` | `GLHBranch` | `branches` | `GLHRepository` | |

### Children
| Relation | Origin | Opposite | Type | Comment |
|---|
| `files` | `GLHBranch` | `branch` | `GLHFile` | |

### Other
| Relation | Origin | Opposite | Type | Comment |
|---|
| `commits` | `GLHBranch` | `branch` | `GLHCommit` | |


## Properties
======================

| Name | Type | Default value | Comment |
|---|
| `name` | `String` | nil | Basic name of the entity, not full reference.|
| `sha` | `String` | nil | |

"
Class {
	#name : #GLHBranch,
	#superclass : #GLHEntity,
	#traits : 'GLHTRef',
	#classTraits : 'GLHTRef classTrait',
	#instVars : [
		'#repository => FMOne type: #GLHRepository opposite: #branches',
		'#files => FMMany type: #GLHFile opposite: #branch',
		'#commits => FMMany type: #GLHCommit opposite: #branch'
	],
	#category : #'GitLabHealth-Model-Entities'
}

{ #category : #meta }
GLHBranch class >> annotation [

	<FMClass: #Branch super: #GLHEntity>
	<package: #'GitLabHealth-Model'>
	<generated>
	^ self
]

{ #category : #adding }
GLHBranch >> addCommit: anObject [
	<generated>
	^ self commits add: anObject
]

{ #category : #adding }
GLHBranch >> addFile: anObject [
	<generated>
	^ self files add: anObject
]

{ #category : #accessing }
GLHBranch >> commits [
	"Relation named: #commits type: #GLHCommit opposite: #branch"

	<generated>
	<derived>
	^ commits
]

{ #category : #accessing }
GLHBranch >> commits: anObject [

	<generated>
	commits value: anObject
]

{ #category : #accessing }
GLHBranch >> files [
	"Relation named: #files type: #GLHFile opposite: #branch"

	<generated>
	<derived>
	^ files
]

{ #category : #accessing }
GLHBranch >> files: anObject [

	<generated>
	files value: anObject
]

{ #category : #navigation }
GLHBranch >> filesGroup [
	<generated>
	<navigation: 'Files'>
	^ MooseSpecializedGroup withAll: self files asSet
]

{ #category : #accessing }
GLHBranch >> repository [
	"Relation named: #repository type: #GLHRepository opposite: #branches"

	<generated>
	<container>
	^ repository
]

{ #category : #accessing }
GLHBranch >> repository: anObject [

	<generated>
	repository := anObject
]

{ #category : #navigation }
GLHBranch >> repositoryGroup [
	<generated>
	<navigation: 'Repository'>
	^ MooseSpecializedGroup with: self repository
]
