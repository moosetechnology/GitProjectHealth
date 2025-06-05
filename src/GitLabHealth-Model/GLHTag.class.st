"
a Tag is a reference to a specific point in the repository's history

## Relations
======================

### Other
| Relation | Origin | Opposite | Type | Comment |
|---|
| `commit` | `GLHTag` | `tag` | `GLHCommit` | |
| `release` | `GLHTag` | `tag` | `GLHRelease` | |



"
Class {
	#name : #GLHTag,
	#superclass : #GLHEntity,
	#instVars : [
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
