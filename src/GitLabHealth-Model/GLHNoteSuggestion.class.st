"
suggestion of code made in a note

## Relations
======================

### Other
| Relation | Origin | Opposite | Type | Comment |
|---|
| `note` | `GLHNoteSuggestion` | `suggestions` | `GLHNote` | |


## Properties
======================

| Name | Type | Default value | Comment |
|---|
| `from_content` | `String` | nil | |
| `from_line` | `Number` | nil | |
| `name` | `String` | nil | Basic name of the entity, not full reference.|
| `to_content` | `String` | nil | |
| `to_line` | `Number` | nil | |

"
Class {
	#name : #GLHNoteSuggestion,
	#superclass : #GLHEntity,
	#traits : 'FamixTNamedEntity',
	#classTraits : 'FamixTNamedEntity classTrait',
	#instVars : [
		'#from_line => FMProperty',
		'#to_line => FMProperty',
		'#from_content => FMProperty',
		'#to_content => FMProperty',
		'#note => FMMany type: #GLHNote opposite: #suggestions'
	],
	#category : #'GitLabHealth-Model-Entities'
}

{ #category : #meta }
GLHNoteSuggestion class >> annotation [

	<FMClass: #NoteSuggestion super: #GLHEntity>
	<package: #'GitLabHealth-Model'>
	<generated>
	^ self
]

{ #category : #adding }
GLHNoteSuggestion >> addNote: anObject [
	<generated>
	^ self note add: anObject
]

{ #category : #accessing }
GLHNoteSuggestion >> from_content [

	<FMProperty: #from_content type: #String>
	<generated>
	^ from_content
]

{ #category : #accessing }
GLHNoteSuggestion >> from_content: anObject [
	<generated>
	from_content := anObject
]

{ #category : #accessing }
GLHNoteSuggestion >> from_line [

	<FMProperty: #from_line type: #Number>
	<generated>
	^ from_line
]

{ #category : #accessing }
GLHNoteSuggestion >> from_line: anObject [
	<generated>
	from_line := anObject
]

{ #category : #accessing }
GLHNoteSuggestion >> note [
	"Relation named: #note type: #GLHNote opposite: #suggestions"

	<generated>
	<derived>
	^ note
]

{ #category : #accessing }
GLHNoteSuggestion >> note: anObject [

	<generated>
	note value: anObject
]

{ #category : #accessing }
GLHNoteSuggestion >> to_content [

	<FMProperty: #to_content type: #String>
	<generated>
	^ to_content
]

{ #category : #accessing }
GLHNoteSuggestion >> to_content: anObject [
	<generated>
	to_content := anObject
]

{ #category : #accessing }
GLHNoteSuggestion >> to_line [

	<FMProperty: #to_line type: #Number>
	<generated>
	^ to_line
]

{ #category : #accessing }
GLHNoteSuggestion >> to_line: anObject [
	<generated>
	to_line := anObject
]
