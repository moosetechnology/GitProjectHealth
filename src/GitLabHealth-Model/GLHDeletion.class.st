"
a detected deletion of a line, seen within a diff 

## Properties
======================

| Name | Type | Default value | Comment |
|---|
| `delimiter` | `String` | '#-' | |

"
Class {
	#name : #GLHDeletion,
	#superclass : #GLHChange,
	#instVars : [
		'#delimiter => FMProperty defaultValue: #-'
	],
	#category : 'GitLabHealth-Model-Entities'
}

{ #category : #meta }
GLHDeletion class >> annotation [

	<FMClass: #Deletion super: #GLHChange>
	<package: #'GitLabHealth-Model'>
	<generated>
	^ self
]

{ #category : #accessing }
GLHDeletion >> delimiter: anObject [
	<generated>
	delimiter := anObject
]

{ #category : #testing }
GLHDeletion >> isDeletion [

	<generated>
	^ true
]
