Class {
	#name : #GLHEntity,
	#superclass : #MooseEntity,
	#traits : 'TEntityMetaLevelDependency',
	#classTraits : 'TEntityMetaLevelDependency classTrait',
	#category : #'GitLabHealth-Model-Entities'
}

{ #category : #meta }
GLHEntity class >> annotation [

	<FMClass: #Entity super: #MooseEntity>
	<package: #'GitLabHealth-Model'>
	<generated>
	<abstract>
	^ self
]

{ #category : #testing }
GLHEntity class >> isAbstract [

	<generated>
	^ self == GLHEntity
]

{ #category : #meta }
GLHEntity class >> metamodel [

	<generated>
	^ GLHModel metamodel
]

{ #category : #testing }
GLHEntity >> isAddition [

	<generated>
	^ false
]

{ #category : #testing }
GLHEntity >> isDeletion [

	<generated>
	^ false
]

{ #category : #testing }
GLHEntity >> isRef [

	<generated>
	^ false
]
