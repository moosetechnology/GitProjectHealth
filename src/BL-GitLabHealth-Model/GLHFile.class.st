"
A file
"
Class {
	#name : #GLHFile,
	#superclass : #GLHEntity,
	#instVars : [
		'#branch => FMOne type: #GLHBranch opposite: #files'
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
