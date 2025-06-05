"
a Release is typically associated with a tag and provide additional metadata and assets that can be distributed to users

## Relations
======================

### Parents
| Relation | Origin | Opposite | Type | Comment |
|---|
| `author` | `GLHRelease` | `releases` | `GLHUser` | |

### Other
| Relation | Origin | Opposite | Type | Comment |
|---|
| `tag` | `GLHRelease` | `release` | `GLHTag` | |



"
Class {
	#name : #GLHRelease,
	#superclass : #GLHEntity,
	#instVars : [
		'#tag => FMOne type: #GLHTag opposite: #release',
		'#author => FMOne type: #GLHUser opposite: #releases'
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
