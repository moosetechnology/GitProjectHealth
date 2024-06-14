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
GLHModelImporterTest >> testImportGroup [

	| evrefGroup |
	self assert: (self model allWithType: GLHGroup) size equals: 1.
	evrefGroup := (self model allWithType: GLHGroup) anyOne.
	self assert: evrefGroup projects isNotEmpty.
	"project https://gitlab.com/evref-bl/test-code-churn"
	self assert:
		(evrefGroup projects anySatisfy: [ :project | project id = 57841283 ])
]

{ #category : #tests }
GLHModelImporterTest >> testImportProject [

	self assert: (self model allWithType: GLHProject) size equals: 1.
	self assert:
		((self model allWithType: GLHProject) anySatisfy: [ :project |
			 project id = 57841283 ])
]
