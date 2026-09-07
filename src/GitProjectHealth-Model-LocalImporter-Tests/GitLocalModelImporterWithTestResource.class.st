Class {
	#name : #GitLocalModelImporterWithTestResource,
	#superclass : #TestResource,
	#category : #'GitProjectHealth-Model-LocalImporter-Tests'
}

{ #category : #running }
GitLocalModelImporterWithTestResource >> setUp [ 

	super setUp.
	ZipArchive extractFrom: (GPHBridge testResourcesZip) to: GPHBridge testResources

]

{ #category : #running }
GitLocalModelImporterWithTestResource >> tearDown [

	GPHBridge testResources ensureDeleteAll.
	super tearDown
]
