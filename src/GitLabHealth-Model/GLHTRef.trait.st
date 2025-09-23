"
I'm representing a Git reference, that is a reference point in a repository's history

## Properties
======================

| Name | Type | Default value | Comment |
|---|
| `name` | `String` | nil | Basic name of the entity, not full reference.|
| `sha` | `String` | nil | |

"
Trait {
	#name : #GLHTRef,
	#instVars : [
		'#sha => FMProperty'
	],
	#traits : 'FamixTNamedEntity',
	#classTraits : 'FamixTNamedEntity classTrait',
	#category : #'GitLabHealth-Model-Traits'
}

{ #category : #meta }
GLHTRef classSide >> annotation [

	<FMClass: #TRef super: #Object>
	<package: #'GitLabHealth-Model'>
	<generated>
	^ self
]

{ #category : #testing }
GLHTRef >> isRef [

	<generated>
	^ true
]

{ #category : #accessing }
GLHTRef >> sha [

	<FMProperty: #sha type: #String>
	<generated>
	^ sha
]

{ #category : #accessing }
GLHTRef >> sha: anObject [
	<generated>
	sha := anObject
]
