Class {
	#name : #GLHEntity,
	#superclass : #MooseEntity,
	#traits : 'TEntityMetaLevelDependency',
	#classTraits : 'TEntityMetaLevelDependency classTrait',
	#category : #'BL-GitLabHealth-Model-Entities'
}

{ #category : #meta }
GLHEntity class >> annotation [

	<FMClass: #Entity super: #MooseEntity>
	<package: #'BL-GitLabHealth-Model'>
	<generated>
	^self
]

{ #category : #meta }
GLHEntity class >> metamodel [

	<generated>
	^ GLHModel metamodel
]
