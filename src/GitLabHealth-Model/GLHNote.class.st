"
a indicate on which line of code are concerned by a diff (usually declared with @@ oldRange, newRange @@) 

## Relations
======================

### Other
| Relation | Origin | Opposite | Type | Comment |
|---|
| `MergeRequest` | `GLHNote` | `note` | `GLHMergeRequest` | |


## Properties
======================

| Name | Type | Default value | Comment |
|---|
| `body` | `String` | nil | |
| `name` | `String` | nil | Basic name of the entity, not full reference.|

"
Class {
	#name : #GLHNote,
	#superclass : #GLHEntity,
	#traits : 'FamixTNamedEntity',
	#classTraits : 'FamixTNamedEntity classTrait',
	#instVars : [
		'#body => FMProperty',
		'#MergeRequest => FMOne type: #GLHMergeRequest opposite: #note'
	],
	#category : #'GitLabHealth-Model-Entities'
}

{ #category : #meta }
GLHNote class >> annotation [

	<FMClass: #Note super: #GLHEntity>
	<package: #'GitLabHealth-Model'>
	<generated>
	^ self
]

{ #category : #accessing }
GLHNote >> MergeRequest [
	"Relation named: #MergeRequest type: #GLHMergeRequest opposite: #note"

	<generated>
	^ MergeRequest
]

{ #category : #accessing }
GLHNote >> MergeRequest: anObject [

	<generated>
	MergeRequest := anObject
]

{ #category : #accessing }
GLHNote >> body [

	<FMProperty: #body type: #String>
	<generated>
	^ body
]

{ #category : #accessing }
GLHNote >> body: anObject [
	<generated>
	body := anObject
]
