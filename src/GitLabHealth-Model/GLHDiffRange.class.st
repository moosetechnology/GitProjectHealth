"
a indicate on which line of code are concerned by a diff (usually declared with @@ oldRange, newRange @@) 

## Relations
======================

### Parents
| Relation | Origin | Opposite | Type | Comment |
|---|
| `diff` | `GLHDiffRange` | `diffRanges` | `GLHDiff` | |

### Other
| Relation | Origin | Opposite | Type | Comment |
|---|
| `changes` | `GLHDiffRange` | `diffRange` | `GLHChange` | |


## Properties
======================

| Name | Type | Default value | Comment |
|---|
| `lineOfCode` | `String` | nil | |
| `newLineRange` | `String` | nil | |
| `originalLineRange` | `String` | nil | |

"
Class {
	#name : #GLHDiffRange,
	#superclass : #GLHEntity,
	#instVars : [
		'#originalLineRange => FMProperty',
		'#newLineRange => FMProperty',
		'#lineOfCode => FMProperty',
		'#diff => FMOne type: #GLHDiff opposite: #diffRanges',
		'#changes => FMMany type: #GLHChange opposite: #diffRange'
	],
	#category : #'GitLabHealth-Model-Entities'
}

{ #category : #meta }
GLHDiffRange class >> annotation [

	<FMClass: #DiffRange super: #GLHEntity>
	<package: #'GitLabHealth-Model'>
	<generated>
	^ self
]

{ #category : #adding }
GLHDiffRange >> addChange: anObject [
	<generated>
	^ self changes add: anObject
]

{ #category : #accessing }
GLHDiffRange >> changes [
	"Relation named: #changes type: #GLHChange opposite: #diffRange"

	<generated>
	<derived>
	^ changes
]

{ #category : #accessing }
GLHDiffRange >> changes: anObject [

	<generated>
	changes value: anObject
]

{ #category : #accessing }
GLHDiffRange >> diff [
	"Relation named: #diff type: #GLHDiff opposite: #diffRanges"

	<generated>
	<container>
	^ diff
]

{ #category : #accessing }
GLHDiffRange >> diff: anObject [

	<generated>
	diff := anObject
]

{ #category : #navigation }
GLHDiffRange >> diffGroup [
	<generated>
	<navigation: 'Diff'>
	^ MooseSpecializedGroup with: self diff
]

{ #category : #accessing }
GLHDiffRange >> lineOfCode [

	<FMProperty: #lineOfCode type: #String>
	<generated>
	^ lineOfCode
]

{ #category : #accessing }
GLHDiffRange >> lineOfCode: anObject [
	<generated>
	lineOfCode := anObject
]

{ #category : #accessing }
GLHDiffRange >> newLineRange [

	<FMProperty: #newLineRange type: #String>
	<generated>
	^ newLineRange
]

{ #category : #accessing }
GLHDiffRange >> newLineRange: anObject [
	<generated>
	newLineRange := anObject
]

{ #category : #accessing }
GLHDiffRange >> originalLineRange [

	<FMProperty: #originalLineRange type: #String>
	<generated>
	^ originalLineRange
]

{ #category : #accessing }
GLHDiffRange >> originalLineRange: anObject [
	<generated>
	originalLineRange := anObject
]
