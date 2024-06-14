"
A GLHModelImporterTest is a test class for testing the behavior of GLHModelImporter
"
Class {
	#name : #GLHModelImporterTest,
	#superclass : #TestCase,
	#instVars : [
		'glphModel',
		'glphApi',
		'since',
		'glhImporter'
	],
	#category : #'GitLabHealth-Model-Importer-Tests'
}

{ #category : #accessing }
GLHModelImporterTest class >> resources [

	^ Array with: GLHModelImporterTestResource
]

{ #category : #running }
GLHModelImporterTest >> model [

	^ self class resources first current model
]

{ #category : #tests }
GLHModelImporterTest >> testImportProject [

	self assert: (self model allWithType: GLHProject) size equals: 1.
	self assert:
		((self model allWithType: GLHProject) anySatisfy: [ :project |
			 project id = 57841283 ])
]
