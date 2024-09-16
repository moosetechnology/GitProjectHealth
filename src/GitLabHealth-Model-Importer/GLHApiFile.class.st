Class {
	#name : #GLHApiFile,
	#superclass : #Object,
	#instVars : [
		'name',
		'type'
	],
	#category : 'GitLabHealth-Model-Importer'
}

{ #category : #accessing }
GLHApiFile >> name [

	^ name
]

{ #category : #accessing }
GLHApiFile >> name: anObject [

	name := anObject
]

{ #category : #accessing }
GLHApiFile >> type [

	^ type
]

{ #category : #accessing }
GLHApiFile >> type: anObject [

	type := anObject
]
