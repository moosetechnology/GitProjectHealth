"
The diff of a commit

## Relations
======================

### Parents
| Relation | Origin | Opposite | Type | Comment |
|---|
| `commit` | `GLHDiff` | `diffs` | `GLHCommit` | |


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
		'#commit => FMOne type: #GLHCommit opposite: #diffs',
		'#deleted_file => FMProperty defaultValue: false',
		'#diffString => FMProperty',
		'#new_file => FMProperty defaultValue: false',
		'#new_path => FMProperty',
		'#old_path => FMProperty',
		'#renamed_file => FMProperty defaultValue: false'
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

{ #category : #'as yet unclassified' }
GLHDiff >> inspectionGLHDiff [

	<inspectorPresentationOrder: 3 title: 'Files Impacted'>
	| canvas |
	canvas := RSCommitDiff canvasFor: self.

	^ canvas asPresenter
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
