"
a detected addition of a line, seen within a diff 

## Properties
======================

| Name | Type | Default value | Comment |
|---|
| `delimiter` | `String` | '#+' | |

"
Class {
	#name : #GLPHEAddition,
	#superclass : #GLPHEChange,
	#instVars : [
		'#delimiter => FMProperty defaultValue: #+'
	],
	#category : #'GLPHExtended-Model-Entities'
}

{ #category : #meta }
GLPHEAddition class >> annotation [

	<FMClass: #Addition super: #GLPHEChange>
	<package: #'GLPHExtended-Model'>
	<generated>
	^ self
]

{ #category : #accessing }
GLPHEAddition >> delimiter: anObject [
	<generated>
	delimiter := anObject
]
