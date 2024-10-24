"
a detected deletion of a line, seen within a diff 

## Properties
======================

| Name | Type | Default value | Comment |
|---|
| `delimiter` | `String` | '#-' | |

"
Class {
	#name : #GLPHEDeletion,
	#superclass : #GLPHEChange,
	#instVars : [
		'#delimiter => FMProperty defaultValue: #-'
	],
	#category : #'GLPHExtended-Model-Entities'
}

{ #category : #meta }
GLPHEDeletion class >> annotation [

	<FMClass: #Deletion super: #GLPHEChange>
	<package: #'GLPHExtended-Model'>
	<generated>
	^ self
]

{ #category : #accessing }
GLPHEDeletion >> delimiter: anObject [
	<generated>
	delimiter := anObject
]
