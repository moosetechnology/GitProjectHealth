Class {
	#name : 'GHApiFile',
	#superclass : 'Object',
	#instVars : [
		'name',
		'type'
	],
	#category : 'GitHubHealth-Model-Importer',
	#package : 'GitHubHealth-Model-Importer'
}

{ #category : 'accessing' }
GHApiFile >> name [

	^ name
]

{ #category : 'accessing' }
GHApiFile >> name: anObject [

	name := anObject
]

{ #category : 'accessing' }
GHApiFile >> type [

	^ type
]

{ #category : 'accessing' }
GHApiFile >> type: anObject [

	type := anObject
]
