"
The diff of a commit

## Relations
======================

### Parents
| Relation | Origin | Opposite | Type | Comment |
|---|
| `commit` | `GLHDiff` | `diffs` | `GLHCommit` | |

### Children
| Relation | Origin | Opposite | Type | Comment |
|---|
| `diffRanges` | `GLHDiff` | `diff` | `GLHDiffRange` | |
| `file` | `GLHDiff` | `diffs` | `GLHFile` | |

### Other
| Relation | Origin | Opposite | Type | Comment |
|---|
| `mergeRequest` | `GLHDiff` | `diffs` | `GLHMergeRequest` | |


## Properties
======================

| Name | Type | Default value | Comment |
|---|
| `deleted_file` | `Boolean` | false | Is the file of the diff has been removed|
| `diffString` | `String` | nil | The string presenting the diff. It should follow the [Detailed-Unified](https://www.gnu.org/software/diffutils/manual/html_node/Detailed-Unified.html) format|
| `name` | `String` | nil | Basic name of the entity, not full reference.|
| `new_file` | `Boolean` | false | Is the file of the diff is a new file|
| `new_path` | `String` | nil | The path to the file in the resulted repository commitish|
| `old_path` | `String` | nil | The path to the file in the origin repository commitish|
| `renamed_file` | `Boolean` | false | Is the file of the diff has been renamed (see old_path/new_path) file|

"
Class {
	#name : #GLHDiff,
	#superclass : #GLHEntity,
	#traits : 'FamixTNamedEntity',
	#classTraits : 'FamixTNamedEntity classTrait',
	#instVars : [
		'#diffString => FMProperty',
		'#new_path => FMProperty',
		'#old_path => FMProperty',
		'#new_file => FMProperty defaultValue: false',
		'#renamed_file => FMProperty defaultValue: false',
		'#deleted_file => FMProperty defaultValue: false',
		'#commit => FMOne type: #GLHCommit opposite: #diffs',
		'#mergeRequest => FMOne type: #GLHMergeRequest opposite: #diffs',
		'#file => FMMany type: #GLHFile opposite: #diffs',
		'#diffRanges => FMMany type: #GLHDiffRange opposite: #diff'
	],
	#category : #'GitLabHealth-Model-Entities'
}

{ #category : #meta }
GLHDiff class >> annotation [

	<FMClass: #Diff super: #GLHEntity>
	<package: #'GitLabHealth-Model'>
	<generated>
	^ self
]

{ #category : #adding }
GLHDiff >> addDiffRange: anObject [
	<generated>
	^ self diffRanges add: anObject
]

{ #category : #adding }
GLHDiff >> addFile: anObject [
	<generated>
	^ self file add: anObject
]

{ #category : #accessing }
GLHDiff >> commit [
	"Relation named: #commit type: #GLHCommit opposite: #diffs"

	<generated>
	<container>
	^ commit
]

{ #category : #accessing }
GLHDiff >> commit: anObject [

	<generated>
	commit := anObject
]

{ #category : #navigation }
GLHDiff >> commitGroup [
	<generated>
	<navigation: 'Commit'>
	^ MooseSpecializedGroup with: self commit
]

{ #category : #accessing }
GLHDiff >> deleted_file [

	<FMProperty: #deleted_file type: #Boolean defaultValue: false>
	<generated>
	<FMComment: 'Is the file of the diff has been removed'>
	^ deleted_file ifNil: [ deleted_file := false ]
]

{ #category : #accessing }
GLHDiff >> deleted_file: anObject [
	<generated>
	deleted_file := anObject
]

{ #category : #accessing }
GLHDiff >> diffRanges [
	"Relation named: #diffRanges type: #GLHDiffRange opposite: #diff"

	<generated>
	<derived>
	^ diffRanges
]

{ #category : #accessing }
GLHDiff >> diffRanges: anObject [

	<generated>
	diffRanges value: anObject
]

{ #category : #navigation }
GLHDiff >> diffRangesGroup [
	<generated>
	<navigation: 'DiffRanges'>
	^ MooseSpecializedGroup withAll: self diffRanges asSet
]

{ #category : #accessing }
GLHDiff >> diffString [

	<FMProperty: #diffString type: #String>
	<generated>
	<FMComment: 'The string presenting the diff. It should follow the [Detailed-Unified](https://www.gnu.org/software/diffutils/manual/html_node/Detailed-Unified.html) format'>
	^ diffString
]

{ #category : #accessing }
GLHDiff >> diffString: anObject [
	<generated>
	diffString := anObject
]

{ #category : #accessing }
GLHDiff >> file [
	"Relation named: #file type: #GLHFile opposite: #diffs"

	<generated>
	<derived>
	^ file
]

{ #category : #accessing }
GLHDiff >> file: anObject [

	<generated>
	file value: anObject
]

{ #category : #navigation }
GLHDiff >> fileGroup [
	<generated>
	<navigation: 'File'>
	^ MooseSpecializedGroup withAll: self file asSet
]

{ #category : #accessing }
GLHDiff >> mergeRequest [
	"Relation named: #mergeRequest type: #GLHMergeRequest opposite: #diffs"

	<generated>
	^ mergeRequest
]

{ #category : #accessing }
GLHDiff >> mergeRequest: anObject [

	<generated>
	mergeRequest := anObject
]

{ #category : #accessing }
GLHDiff >> new_file [

	<FMProperty: #new_file type: #Boolean defaultValue: false>
	<generated>
	<FMComment: 'Is the file of the diff is a new file'>
	^ new_file ifNil: [ new_file := false ]
]

{ #category : #accessing }
GLHDiff >> new_file: anObject [
	<generated>
	new_file := anObject
]

{ #category : #accessing }
GLHDiff >> new_path [

	<FMProperty: #new_path type: #String>
	<generated>
	<FMComment: 'The path to the file in the resulted repository commitish'>
	^ new_path
]

{ #category : #accessing }
GLHDiff >> new_path: anObject [
	<generated>
	new_path := anObject
]

{ #category : #accessing }
GLHDiff >> old_path [

	<FMProperty: #old_path type: #String>
	<generated>
	<FMComment: 'The path to the file in the origin repository commitish'>
	^ old_path
]

{ #category : #accessing }
GLHDiff >> old_path: anObject [
	<generated>
	old_path := anObject
]

{ #category : #accessing }
GLHDiff >> renamed_file [

	<FMProperty: #renamed_file type: #Boolean defaultValue: false>
	<generated>
	<FMComment: 'Is the file of the diff has been renamed (see old_path/new_path) file'>
	^ renamed_file ifNil: [ renamed_file := false ]
]

{ #category : #accessing }
GLHDiff >> renamed_file: anObject [
	<generated>
	renamed_file := anObject
]
