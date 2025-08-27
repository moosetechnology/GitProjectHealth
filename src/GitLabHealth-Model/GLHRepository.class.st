"
A git repository

## Relations
======================

### Parents
| Relation | Origin | Opposite | Type | Comment |
|---|
| `project` | `GLHRepository` | `repository` | `GLHProject` | |

### Children
| Relation | Origin | Opposite | Type | Comment |
|---|
| `branches` | `GLHRepository` | `repository` | `GLHBranch` | |
| `commits` | `GLHRepository` | `repository` | `GLHCommit` | |
| `tags` | `GLHRepository` | `repository` | `GLHTag` | |



"
Class {
	#name : #GLHRepository,
	#superclass : #GLHEntity,
	#instVars : [
		'#branches => FMMany type: #GLHBranch opposite: #repository',
		'#commits => FMMany type: #GLHCommit opposite: #repository',
		'#project => FMOne type: #GLHProject opposite: #repository',
		'#tags => FMMany type: #GLHTag opposite: #repository'
	],
	#category : #'GitLabHealth-Model-Entities'
}

{ #category : #meta }
GLHRepository class >> annotation [

	<FMClass: #Repository super: #GLHEntity>
	<package: #'GitLabHealth-Model'>
	<generated>
	^ self
]

{ #category : #adding }
GLHRepository >> addBranch: anObject [
	<generated>
	^ self branches add: anObject
]

{ #category : #adding }
GLHRepository >> addCommit: anObject [
	<generated>
	^ self commits add: anObject
]

{ #category : #adding }
GLHRepository >> addTag: anObject [
	<generated>
	^ self tags add: anObject
]

{ #category : #accessing }
GLHRepository >> branches [
	"Relation named: #branches type: #GLHBranch opposite: #repository"

	<generated>
	<derived>
	^ branches
]

{ #category : #accessing }
GLHRepository >> branches: anObject [

	<generated>
	branches value: anObject
]

{ #category : #navigation }
GLHRepository >> branchesGroup [
	<generated>
	<navigation: 'Branches'>
	^ MooseSpecializedGroup withAll: self branches asSet
]

{ #category : #accessing }
GLHRepository >> commits [
	"Relation named: #commits type: #GLHCommit opposite: #repository"

	<generated>
	<derived>
	^ commits
]

{ #category : #accessing }
GLHRepository >> commits: anObject [

	<generated>
	commits value: anObject
]

{ #category : #navigation }
GLHRepository >> commitsGroup [
	<generated>
	<navigation: 'Commits'>
	^ MooseSpecializedGroup withAll: self commits asSet
]

{ #category : #accessing }
GLHRepository >> project [
	"Relation named: #project type: #GLHProject opposite: #repository"

	<generated>
	<container>
	<derived>
	^ project
]

{ #category : #accessing }
GLHRepository >> project: anObject [

	<generated>
	project := anObject
]

{ #category : #navigation }
GLHRepository >> projectGroup [
	<generated>
	<navigation: 'Project'>
	^ MooseSpecializedGroup with: self project
]

{ #category : #accessing }
GLHRepository >> tags [
	"Relation named: #tags type: #GLHTag opposite: #repository"

	<generated>
	<derived>
	^ tags
]

{ #category : #accessing }
GLHRepository >> tags: anObject [

	<generated>
	tags value: anObject
]

{ #category : #navigation }
GLHRepository >> tagsGroup [
	<generated>
	<navigation: 'Tags'>
	^ MooseSpecializedGroup withAll: self tags asSet
]
