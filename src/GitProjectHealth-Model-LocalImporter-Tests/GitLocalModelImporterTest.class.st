"
A GitLocalModelImporterTest is a test class for testing the behavior of GitLocalModelImporter
"
Class {
	#name : #GitLocalModelImporterTest,
	#superclass : #TestCase,
	#instVars : [
		'localImporter',
		'model',
		'root'
	],
	#category : #'GitProjectHealth-Model-LocalImporter-Tests'
}

{ #category : #running }
GitLocalModelImporterTest >> setUp [

	super setUp.
	localImporter := GitLocalModelImporter new.
	model := GLHModel new.
	localImporter glhModel: model.
	root := FileSystem memory root.
	(root / 'src') ensureCreateDirectory.
	(root / 'src' / 'en') ensureCreateDirectory.
	(root / 'src' / 'en' / 'test.st') ensureCreateFile
]

{ #category : #tests }
GitLocalModelImporterTest >> testBuildGPHFileFor [

	localImporter buildGPHFileFor: root.
	self assert: (model allWithSubTypesOf: GLHFile) isNotEmpty
]

{ #category : #tests }
GitLocalModelImporterTest >> testBuildGPHFileForMultipleTimes [
	"in case there are more and more files, we can parse several times. But we need to have only one time each file"

	localImporter buildGPHFileFor: root.
	localImporter buildGPHFileFor: root.
	self
		assert: ((model allWithType: GLHFileDirectory) select: [ :f |
				 f path endsWith: '/src' ]) size
		equals: 1
]

{ #category : #tests }
GitLocalModelImporterTest >> testBuildGPHFileForMultipleTimesAddItems [
	"in case there are more and more files, we can parse several times. But we need to have only one time each file"

	| size sizeAfter |
	localImporter buildGPHFileFor: root.
	size := (model allWithSubTypesOf: GLHFile) size.
	(root / 'src' / 'fr') ensureCreateDirectory.
	(root / 'src' / 'fr' / 'test.st') ensureCreateFile.
	localImporter buildGPHFileFor: root.
	sizeAfter := (model allWithSubTypesOf: GLHFile) size.

	self assert: size + 2 equals: sizeAfter
]
