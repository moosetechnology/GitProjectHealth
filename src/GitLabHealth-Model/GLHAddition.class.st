"
a detected addition of a line, seen within a diff 

## Properties
======================

| Name | Type | Default value | Comment |
|---|
| `delimiter` | `String` | '#+' | |

"
Class {
	#name : #GLHAddition,
	#superclass : #GLHChange,
	#instVars : [
		'#delimiter => FMProperty defaultValue: \'#+\''
	],
	#category : #'GitLabHealth-Model-Entities'
}

{ #category : #meta }
GLHAddition class >> annotation [

	<FMClass: #Addition super: #GLHChange>
	<package: #'GitLabHealth-Model'>
	<generated>
	^ self
]

{ #category : #accessing }
GLHAddition >> delimiter [

	<FMProperty: #delimiter type: #String defaultValue: '#+'>
	<generated>
	^ delimiter ifNil: [ delimiter := '#+' ]
]

{ #category : #accessing }
GLHAddition >> delimiter: anObject [
	<generated>
	delimiter := anObject
]

{ #category : #testing }
GLHAddition >> isAddition [

	<generated>
	^ true
]
