"
The test suite for `GLHModelImporter` but not using remote API
"
Class {
	#name : #GLHModelImporterLocalTest,
	#superclass : #TestCase,
	#instVars : [
		'importer',
		'model'
	],
	#category : 'GitLabHealth-Model-Importer-Tests'
}

{ #category : #running }
GLHModelImporterLocalTest >> setUp [

	super setUp.

	importer := GLHModelImporter new.
	model := GLPHEModel new.
	importer glhModel: model
]

{ #category : #tests }
GLHModelImporterLocalTest >> testImportUserAlreadyInModel [

	| user |
	user := GLHUser new
		        id: 12;
		        yourself.
	model add: user.
	self assert: (importer importUser: 12) equals: user
]
