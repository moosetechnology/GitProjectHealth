"
I am a superclass for Model importer.
I am a try of normalization for the different importer.

I also define some contract so it is easier to switch from one importer to another
"
Class {
	#name : 'GPModelImporter',
	#superclass : 'Object',
	#instVars : [
		'withCommitsSince',
		'withFiles'
	],
	#category : 'GitProjectHealth-Model-Importer',
	#package : 'GitProjectHealth-Model-Importer'
}

{ #category : 'accessing' }
GPModelImporter >> beWithFiles [

	withFiles := true
]

{ #category : 'accessing' }
GPModelImporter >> beWithoutFiles [

	withFiles := false
]

{ #category : 'initialization' }
GPModelImporter >> initialize [

	super initialize.
	self withCommitsSince: (Date today - 1 week) asDateAndTime
]

{ #category : 'accessing' }
GPModelImporter >> withCommitsSince [

	^ withCommitsSince
]

{ #category : 'accessing' }
GPModelImporter >> withCommitsSince: anObject [

	withCommitsSince := anObject
]

{ #category : 'accessing' }
GPModelImporter >> withFiles [

	^ withFiles
]

{ #category : 'accessing' }
GPModelImporter >> withFiles: anObject [

	withFiles := anObject
]
