"
super class for addition and deletion 

## Relations
======================

### Other
| Relation | Origin | Opposite | Type | Comment |
|---|
| `diffRange` | `GLPHEChange` | `changes` | `GLPHEDiffRange` | |


## Properties
======================

| Name | Type | Default value | Comment |
|---|
| `index` | `Number` | nil | |
| `name` | `String` | nil | Basic name of the entity, not full reference.|
| `relativeIndex` | `Number` | nil | |
| `sourceCode` | `String` | nil | |

"
Class {
	#name : #GLPHEChange,
	#superclass : #GLPHEEntity,
	#traits : 'FamixTNamedEntity',
	#classTraits : 'FamixTNamedEntity classTrait',
	#instVars : [
		'#diffRange => FMOne type: #GLPHEDiffRange opposite: #changes',
		'#index => FMProperty',
		'#relativeIndex => FMProperty',
		'#sourceCode => FMProperty'
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
GLPHEChange >> diffRange [
	"Relation named: #diffRange type: #GLPHEDiffRange opposite: #changes"

	<generated>
	^ diffRange
]

{ #category : #accessing }
GLPHEChange >> diffRange: anObject [

	<generated>
	diffRange := anObject
]

{ #category : #accessing }
GLPHEChange >> index [

	<FMProperty: #index type: #Number>
	<generated>
	^ index
]

{ #category : #accessing }
GLPHEChange >> index: anObject [
	<generated>
	index := anObject
]

{ #category : #accessing }
GLPHEChange >> relativeIndex [

	<FMProperty: #relativeIndex type: #Number>
	<generated>
	^ relativeIndex
]

{ #category : #accessing }
GLPHEChange >> relativeIndex: anObject [
	<generated>
	relativeIndex := anObject
]

{ #category : #accessing }
GLPHEChange >> sourceCode [

	<FMProperty: #sourceCode type: #String>
	<generated>
	^ sourceCode
]

{ #category : #accessing }
GLPHEChange >> sourceCode: anObject [
	<generated>
	sourceCode := anObject
]
