Class {
	#name : 'GLPHEEntity',
	#superclass : 'MooseEntity',
	#traits : 'TEntityMetaLevelDependency',
	#classTraits : 'TEntityMetaLevelDependency classTrait',
	#category : 'GLPHExtended-Model-Entities',
	#package : 'GLPHExtended-Model',
	#tag : 'Entities'
}

{ #category : 'meta' }
GLPHEEntity class >> annotation [

	<FMClass: #Entity super: #MooseEntity>
	<package: #'GLPHExtended-Model'>
	<generated>
	<abstract>
	^ self
]

{ #category : 'testing' }
GLPHEEntity class >> isAbstract [

	<generated>
	^ self == GLPHEEntity
]

{ #category : 'meta' }
GLPHEEntity class >> metamodel [

	<generated>
	^ GLPHEModel metamodel
]
