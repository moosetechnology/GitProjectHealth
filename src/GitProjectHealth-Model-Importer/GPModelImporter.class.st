"
I am a superclass for Model importer.
I am a try of normalization for the different importer.

I also define some contract so it is easier to switch from one importer to another
"
Class {
	#name : #GPModelImporter,
	#superclass : #GitModelImporter,
	#classVars : [
		'currentImporter'
	],
	#category : #'GitProjectHealth-Model-Importer'
}

{ #category : #'accessing - global variables' }
GPModelImporter class >> importers [
	^ currentImporter 
]

{ #category : #testing }
GPModelImporter class >> isDeprecated [

	^ true
]

{ #category : #initialization }
GPModelImporter class >> reset [
	currentImporter := OrderedDictionary new.
]
