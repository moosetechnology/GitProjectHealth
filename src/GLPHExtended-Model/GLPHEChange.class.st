"
super class for addition and deletion 

## Relations
======================

### Parents
| Relation | Origin | Opposite | Type | Comment |
|---|
| `diff` | `GLPHEChange` | `changes` | `GLHDiff` | |


## Properties
======================

| Name | Type | Default value | Comment |
|---|
| `linesOfCode` | `String` | nil | |
| `newLineRange` | `String` | nil | |
| `originalLineRange` | `String` | nil | |

"
Class {
	#name : #GLPHEChange,
	#superclass : #GLPHEEntity,
	#instVars : [
		'#linesOfCode => FMProperty',
		'#newLineRange => FMProperty',
		'#originalLineRange => FMProperty'
	],
	#category : #'GLPHExtended-Model-Entities'
}

{ #category : #meta }
GLPHEChange class >> annotation [

	<FMClass: #Change super: #GLPHEEntity>
	<package: #'GLPHExtended-Model'>
	<generated>
	^ self
]

{ #category : #accessing }
GLPHEChange >> diff [
	"Relation named: #diff type: #GLHDiff opposite: #changes"

	<generated>
	<container>
	<FMProperty: #diff type: #GLHDiff opposite: #changes>
	^ self attributeAt: #diff ifAbsent: [ nil ]
]

{ #category : #accessing }
GLPHEChange >> diff: anObject [

	<generated>
	self attributeAt: #diff put: (FMMultivalueLink on: self update: #changes from: self diff to: anObject).
]

{ #category : #navigation }
GLPHEChange >> diffGroup [
	<generated>
	<navigation: 'Diff'>
	^ MooseSpecializedGroup with: self diff
]

{ #category : #accessing }
GLPHEChange >> linesOfCode [

	<FMProperty: #linesOfCode type: #String>
	<generated>
	^ linesOfCode
]

{ #category : #accessing }
GLPHEChange >> linesOfCode: anObject [
	<generated>
	linesOfCode := anObject
]

{ #category : #accessing }
GLPHEChange >> newLineRange [

	<FMProperty: #newLineRange type: #String>
	<generated>
	^ newLineRange
]

{ #category : #accessing }
GLPHEChange >> newLineRange: anObject [
	<generated>
	newLineRange := anObject
]

{ #category : #accessing }
GLPHEChange >> originalLineRange [

	<FMProperty: #originalLineRange type: #String>
	<generated>
	^ originalLineRange
]

{ #category : #accessing }
GLPHEChange >> originalLineRange: anObject [
	<generated>
	originalLineRange := anObject
]
