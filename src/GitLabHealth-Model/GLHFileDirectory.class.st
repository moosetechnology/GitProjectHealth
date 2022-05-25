"
A file directory
"
Class {
	#name : #GLHFileDirectory,
	#superclass : #GLHFile,
	#instVars : [
		'#files => FMMany type: #GLHFile opposite: #directoryOwner'
	],
	#category : #'GitLabHealth-Model-Entities'
}

{ #category : #meta }
GLHFileDirectory class >> annotation [

	<FMClass: #FileDirectory super: #GLHFile>
	<package: #'GitLabHealth-Model'>
	<generated>
	^self
]

{ #category : #adding }
GLHFileDirectory >> addFile: anObject [
	<generated>
	^ self files add: anObject
]

{ #category : #accessing }
GLHFileDirectory >> files [
	"Relation named: #files type: #GLHFile opposite: #directoryOwner"

	<generated>
	<derived>
	^ files
]

{ #category : #accessing }
GLHFileDirectory >> files: anObject [

	<generated>
	files value: anObject
]

{ #category : #navigation }
GLHFileDirectory >> filesGroup [
	<generated>
	<navigation: 'Files'>
	^ MooseSpecializedGroup withAll: self files asSet
]
