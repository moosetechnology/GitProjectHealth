"
A file

## Relations
======================

### Parents
| Relation | Origin | Opposite | Type | Comment |
|---|
| `branch` | `GLHFile` | `files` | `GLHBranch` | |
| `diffs` | `GLHFile` | `file` | `GLHDiff` | |
| `directoryOwner` | `GLHFile` | `files` | `GLHFileDirectory` | |


## Properties
======================

| Name | Type | Default value | Comment |
|---|
| `name` | `String` | nil | |

"
Class {
	#name : #GLHFile,
	#superclass : #GLHEntity,
	#instVars : [
		'#branch => FMOne type: #GLHBranch opposite: #files',
		'#diffs => FMOne type: #GLHDiff opposite: #file',
		'#directoryOwner => FMOne type: #GLHFileDirectory opposite: #files',
		'#name => FMProperty'
	],
	#category : 'GitLabHealth-Model-Entities'
}

{ #category : #meta }
GLHFile class >> annotation [

	<FMClass: #File super: #GLHEntity>
	<package: #'GitLabHealth-Model'>
	<generated>
	^ self
]

{ #category : #accessing }
GLHFile >> branch [
	"Relation named: #branch type: #GLHBranch opposite: #files"

	<generated>
	<container>
	^ branch
]

{ #category : #accessing }
GLHFile >> branch: anObject [

	<generated>
	branch := anObject
]

{ #category : #navigation }
GLHFile >> branchGroup [
	<generated>
	<navigation: 'Branch'>
	^ MooseSpecializedGroup with: self branch
]

{ #category : #accessing }
GLHFile >> diffs [
	"Relation named: #diffs type: #GLHDiff opposite: #file"

	<generated>
	<container>
	^ diffs
]

{ #category : #accessing }
GLHFile >> diffs: anObject [

	<generated>
	diffs := anObject
]

{ #category : #navigation }
GLHFile >> diffsGroup [
	<generated>
	<navigation: 'Diffs'>
	^ MooseSpecializedGroup with: self diffs
]

{ #category : #accessing }
GLHFile >> directoryOwner [
	"Relation named: #directoryOwner type: #GLHFileDirectory opposite: #files"

	<generated>
	<container>
	^ directoryOwner
]

{ #category : #accessing }
GLHFile >> directoryOwner: anObject [

	<generated>
	directoryOwner := anObject
]

{ #category : #navigation }
GLHFile >> directoryOwnerGroup [
	<generated>
	<navigation: 'DirectoryOwner'>
	^ MooseSpecializedGroup with: self directoryOwner
]

{ #category : #accessing }
GLHFile >> name [

	<FMProperty: #name type: #String>
	<generated>
	^ name
]

{ #category : #accessing }
GLHFile >> name: anObject [
	<generated>
	name := anObject
]
