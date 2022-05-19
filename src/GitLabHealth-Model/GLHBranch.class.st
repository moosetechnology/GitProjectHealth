"
A git branch
"
Class {
	#name : #GLHBranch,
	#superclass : #GLHEntity,
	#instVars : [
		'#files => FMMany type: #GLHFile opposite: #branch',
		'#name => FMProperty',
		'#repository => FMOne type: #GLHRepository opposite: #branches'
	],
	#category : #'GitLabHealth-Model-Entities'
}

{ #category : #meta }
GLHBranch class >> annotation [

	<FMClass: #Branch super: #GLHEntity>
	<package: #'BL-GitLabHealth-Model'>
	<generated>
	^self
]

{ #category : #adding }
GLHBranch >> addFile: anObject [
	<generated>
	^ self files add: anObject
]

{ #category : #accessing }
GLHBranch >> files [
	"Relation named: #files type: #GLHFile opposite: #branch"

	<generated>
	<derived>
	^ files
]

{ #category : #accessing }
GLHBranch >> files: anObject [

	<generated>
	files value: anObject
]

{ #category : #navigation }
GLHBranch >> filesGroup [
	<generated>
	<navigation: 'Files'>
	^ MooseSpecializedGroup withAll: self files asSet
]

{ #category : #accessing }
GLHBranch >> name [

	<FMProperty: #name type: #String>
	<generated>
	^ name
]

{ #category : #accessing }
GLHBranch >> name: anObject [
	<generated>
	name := anObject
]

{ #category : #accessing }
GLHBranch >> repository [
	"Relation named: #repository type: #GLHRepository opposite: #branches"

	<generated>
	<container>
	^ repository
]

{ #category : #accessing }
GLHBranch >> repository: anObject [

	<generated>
	repository := anObject
]

{ #category : #navigation }
GLHBranch >> repositoryGroup [
	<generated>
	<navigation: 'Repository'>
	^ MooseSpecializedGroup with: self repository
]
