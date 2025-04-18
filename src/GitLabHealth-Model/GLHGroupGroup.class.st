Class {
	#name : #GLHGroupGroup,
	#superclass : #MooseSpecializedGroup,
	#category : #'GitLabHealth-Model-Groups'
}

{ #category : #meta }
GLHGroupGroup class >> annotation [

	<FMClass: #GroupGroup super: #MooseSpecializedGroup>
	<package: #'GitLabHealth-Model'>
	<generated>
	^ self
]

{ #category : #meta }
GLHGroupGroup class >> metamodel [

	<generated>
	^ GLHModel metamodel
]

{ #category : #testing }
GLHGroupGroup >> isAddition [

	<generated>
	^ false
]

{ #category : #testing }
GLHGroupGroup >> isDeletion [

	<generated>
	^ false
]

{ #category : #testing }
GLHGroupGroup >> isQueryable [

	<generated>
	^ false
]
