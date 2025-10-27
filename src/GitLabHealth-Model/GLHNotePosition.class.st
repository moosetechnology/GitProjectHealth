"
indicate the position of a note

## Relations
======================

### Other
| Relation | Origin | Opposite | Type | Comment |
|---|
| `note` | `GLHNotePosition` | `position` | `GLHNote` | |
| `note` | `GLHNotePosition` | `position` | `GLHNote` | |
| `note` | `GLHNotePosition` | `position` | `GLHNote` | |


## Properties
======================

| Name | Type | Default value | Comment |
|---|
| `end_line` | `Number` | nil | |
| `end_line_type` | `String` | nil | |
| `file_path` | `String` | nil | |
| `name` | `String` | nil | Basic name of the entity, not full reference.|
| `original_file_path` | `String` | nil | |
| `start_line` | `Number` | nil | |
| `start_line_type` | `String` | nil | |

"
Class {
	#name : #GLHNotePosition,
	#superclass : #GLHEntity,
	#traits : 'FamixTNamedEntity',
	#classTraits : 'FamixTNamedEntity classTrait',
	#instVars : [
		'#file_path => FMProperty',
		'#original_file_path => FMProperty',
		'#start_line => FMProperty',
		'#start_line_type => FMProperty',
		'#end_line => FMProperty',
		'#end_line_type => FMProperty',
		'#note => FMOne type: #GLHNote opposite: #position'
	],
	#category : #'GitLabHealth-Model-Entities'
}

{ #category : #meta }
GLHNotePosition class >> annotation [

	<FMClass: #NotePosition super: #GLHEntity>
	<package: #'GitLabHealth-Model'>
	<generated>
	^ self
]

{ #category : #accessing }
GLHNotePosition >> end_line [

	<FMProperty: #end_line type: #Number>
	<generated>
	^ end_line
]

{ #category : #accessing }
GLHNotePosition >> end_line: anObject [
	<generated>
	end_line := anObject
]

{ #category : #accessing }
GLHNotePosition >> end_line_type [

	<FMProperty: #end_line_type type: #String>
	<generated>
	^ end_line_type
]

{ #category : #accessing }
GLHNotePosition >> end_line_type: anObject [
	<generated>
	end_line_type := anObject
]

{ #category : #accessing }
GLHNotePosition >> file_path [

	<FMProperty: #file_path type: #String>
	<generated>
	^ file_path
]

{ #category : #accessing }
GLHNotePosition >> file_path: anObject [
	<generated>
	file_path := anObject
]

{ #category : #accessing }
GLHNotePosition >> note [
	"Relation named: #note type: #GLHNote opposite: #position"

	<generated>
	<derived>
	^ note
]

{ #category : #accessing }
GLHNotePosition >> note: anObject [

	<generated>
	note := anObject
]

{ #category : #accessing }
GLHNotePosition >> original_file_path [

	<FMProperty: #original_file_path type: #String>
	<generated>
	^ original_file_path
]

{ #category : #accessing }
GLHNotePosition >> original_file_path: anObject [
	<generated>
	original_file_path := anObject
]

{ #category : #accessing }
GLHNotePosition >> start_line [

	<FMProperty: #start_line type: #Number>
	<generated>
	^ start_line
]

{ #category : #accessing }
GLHNotePosition >> start_line: anObject [
	<generated>
	start_line := anObject
]

{ #category : #accessing }
GLHNotePosition >> start_line_type [

	<FMProperty: #start_line_type type: #String>
	<generated>
	^ start_line_type
]

{ #category : #accessing }
GLHNotePosition >> start_line_type: anObject [
	<generated>
	start_line_type := anObject
]
