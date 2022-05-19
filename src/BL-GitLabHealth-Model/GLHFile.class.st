"
A file
"
Class {
	#name : #GLHFile,
	#superclass : #GLHEntity,
	#instVars : [
		'#branch => FMOne type: #GLHBranch opposite: #files',
		'#directoryOwner => FMOne type: #GLHFileDirectory opposite: #files',
		'#name => FMProperty'
	],
	#category : #'BL-GitLabHealth-Model-Entities'
}

{ #category : #meta }
GLHFile class >> annotation [

	<FMClass: #File super: #GLHEntity>
	<package: #'BL-GitLabHealth-Model'>
	<generated>
	^self
]

{ #category : #accessing }
GLHFile >> branch [
	"Relation named: #branch type: #GLHBranch opposite: #files"

	<generated>
	<container>
	^ branch
]

{ #category : #accessing }
GLHFile >> branch: anObject [

	<generated>
	branch := anObject
]

{ #category : #navigation }
GLHFile >> branchGroup [
	<generated>
	<navigation: 'Branch'>
	^ MooseSpecializedGroup with: self branch
]

{ #category : #accessing }
GLHFile >> directoryOwner [
	"Relation named: #directoryOwner type: #GLHFileDirectory opposite: #files"

	<generated>
	<container>
	^ directoryOwner
]

{ #category : #accessing }
GLHFile >> directoryOwner: anObject [

	<generated>
	directoryOwner := anObject
]

{ #category : #navigation }
GLHFile >> directoryOwnerGroup [
	<generated>
	<navigation: 'DirectoryOwner'>
	^ MooseSpecializedGroup with: self directoryOwner
]

{ #category : #accessing }
GLHFile >> name [

	<FMProperty: #name type: #String>
	<generated>
	^ name
]

{ #category : #accessing }
GLHFile >> name: anObject [
	<generated>
	name := anObject
]

{ #category : #'*BL-GitLabHealth-Model-Extension' }
GLHFile >> path [

	^ (self directoryOwner
		   ifNotNil: [ :owner | owner path , '/' ]
		   ifNil: [ '' ]) , self name
]
