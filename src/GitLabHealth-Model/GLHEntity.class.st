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
	^self
]

{ #category : #meta }
GLHEntity class >> metamodel [

	<generated>
	^ GLHModel metamodel
]
