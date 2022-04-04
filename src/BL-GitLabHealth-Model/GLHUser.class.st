"
A GitLab User
"
Class {
	#name : #GLHUser,
	#superclass : #GLHEntity,
	#instVars : [
		'#id => FMProperty',
		'#username => FMProperty',
		'#name => FMProperty',
		'#createdProjects => FMMany type: #GLHProject opposite: #creator'
	],
	#category : #'BL-GitLabHealth-Model-Entities'
}

{ #category : #meta }
GLHUser class >> annotation [

	<FMClass: #User super: #GLHEntity>
	<package: #'BL-GitLabHealth-Model'>
	<generated>
	^self
]

{ #category : #adding }
GLHUser >> addCreatedProject: anObject [
	<generated>
	^ self createdProjects add: anObject
]

{ #category : #accessing }
GLHUser >> createdProjects [
	"Relation named: #createdProjects type: #GLHProject opposite: #creator"

	<generated>
	<derived>
	^ createdProjects
]

{ #category : #accessing }
GLHUser >> createdProjects: anObject [

	<generated>
	createdProjects value: anObject
]

{ #category : #accessing }
GLHUser >> id [

	<FMProperty: #id type: #Number>
	<generated>
	^ id
]

{ #category : #accessing }
GLHUser >> id: anObject [
	<generated>
	id := anObject
]

{ #category : #accessing }
GLHUser >> name [

	<FMProperty: #name type: #String>
	<generated>
	^ name
]

{ #category : #accessing }
GLHUser >> name: anObject [
	<generated>
	name := anObject
]

{ #category : #accessing }
GLHUser >> username [

	<FMProperty: #username type: #String>
	<generated>
	^ username
]

{ #category : #accessing }
GLHUser >> username: anObject [
	<generated>
	username := anObject
]
