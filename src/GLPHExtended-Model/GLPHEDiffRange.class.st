"
a indicate on which line of code are concerned by a diff (usually declared with @@ oldRange, newRange @@) 

## Relations
======================

### Parents
| Relation | Origin | Opposite | Type | Comment |
|---|
| `diff` | `GLPHEDiffRange` | `diffRanges` | `GLHDiff` | |

### Other
| Relation | Origin | Opposite | Type | Comment |
|---|
| `changes` | `GLPHEDiffRange` | `diffRange` | `GLPHEChange` | |


## Properties
======================

| Name | Type | Default value | Comment |
|---|
| `lineOfCode` | `String` | nil | |
| `newLineRange` | `String` | nil | |
| `originalLineRange` | `String` | nil | |

"
Class {
	#name : #GLPHEDiffRange,
	#superclass : #GLPHEEntity,
	#instVars : [
		'#originalLineRange => FMProperty',
		'#newLineRange => FMProperty',
		'#lineOfCode => FMProperty',
		'#changes => FMMany type: #GLPHEChange opposite: #diffRange'
	],
	#category : #'GLPHExtended-Model-Entities'
}

{ #category : #meta }
GLPHEDiffRange class >> annotation [

	<FMClass: #DiffRange super: #GLPHEEntity>
	<package: #'GLPHExtended-Model'>
	<generated>
	^ self
]

{ #category : #adding }
GLPHEDiffRange >> addChange: anObject [
	<generated>
	^ self changes add: anObject
]

{ #category : #accessing }
GLPHEDiffRange >> changes [
	"Relation named: #changes type: #GLPHEChange opposite: #diffRange"

	<generated>
	<derived>
	^ changes
]

{ #category : #accessing }
GLPHEDiffRange >> changes: anObject [

	<generated>
	changes value: anObject
]

{ #category : #accessing }
GLPHEDiffRange >> diff [
	"Relation named: #diff type: #GLHDiff opposite: #diffRanges"

	<generated>
	<container>
	<FMProperty: #diff type: #GLHDiff opposite: #diffRanges>
	^ self attributeAt: #diff ifAbsent: [ nil ]
]

{ #category : #accessing }
GLPHEDiffRange >> diff: anObject [

	<generated>
	self attributeAt: #diff put: (FMMultivalueLink on: self update: #diffRanges from: self diff to: anObject).
]

{ #category : #navigation }
GLPHEDiffRange >> diffGroup [
	<generated>
	<navigation: 'Diff'>
	^ MooseSpecializedGroup with: self diff
]

{ #category : #accessing }
GLPHEDiffRange >> lineOfCode [

	<FMProperty: #lineOfCode type: #String>
	<generated>
	^ lineOfCode
]

{ #category : #accessing }
GLPHEDiffRange >> lineOfCode: anObject [
	<generated>
	lineOfCode := anObject
]

{ #category : #accessing }
GLPHEDiffRange >> newLineRange [

	<FMProperty: #newLineRange type: #String>
	<generated>
	^ newLineRange
]

{ #category : #accessing }
GLPHEDiffRange >> newLineRange: anObject [
	<generated>
	newLineRange := anObject
]

{ #category : #accessing }
GLPHEDiffRange >> originalLineRange [

	<FMProperty: #originalLineRange type: #String>
	<generated>
	^ originalLineRange
]

{ #category : #accessing }
GLPHEDiffRange >> originalLineRange: anObject [
	<generated>
	originalLineRange := anObject
]
