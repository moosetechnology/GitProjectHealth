"
super class for addition and deletion 

## Relations
======================

### Other
| Relation | Origin | Opposite | Type | Comment |
|---|
| `diffRange` | `GLHChange` | `changes` | `GLHDiffRange` | |


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
	#name : #GLHChange,
	#superclass : #GLHEntity,
	#traits : 'FamixTNamedEntity',
	#classTraits : 'FamixTNamedEntity classTrait',
	#instVars : [
		'#index => FMProperty',
		'#relativeIndex => FMProperty',
		'#sourceCode => FMProperty',
		'#diffRange => FMOne type: #GLHDiffRange opposite: #changes'
	],
	#category : #'GitLabHealth-Model-Entities'
}

{ #category : #meta }
GLHChange class >> annotation [

	<FMClass: #Change super: #GLHEntity>
	<package: #'GitLabHealth-Model'>
	<generated>
	^ self
]

{ #category : #accessing }
GLHChange >> diffRange [
	"Relation named: #diffRange type: #GLHDiffRange opposite: #changes"

	<generated>
	^ diffRange
]

{ #category : #accessing }
GLHChange >> diffRange: anObject [

	<generated>
	diffRange := anObject
]

{ #category : #accessing }
GLHChange >> index [

	<FMProperty: #index type: #Number>
	<generated>
	^ index
]

{ #category : #accessing }
GLHChange >> index: anObject [
	<generated>
	index := anObject
]

{ #category : #accessing }
GLHChange >> relativeIndex [

	<FMProperty: #relativeIndex type: #Number>
	<generated>
	^ relativeIndex
]

{ #category : #accessing }
GLHChange >> relativeIndex: anObject [
	<generated>
	relativeIndex := anObject
]

{ #category : #accessing }
GLHChange >> sourceCode [

	<FMProperty: #sourceCode type: #String>
	<generated>
	^ sourceCode
]

{ #category : #accessing }
GLHChange >> sourceCode: anObject [
	<generated>
	sourceCode := anObject
]
