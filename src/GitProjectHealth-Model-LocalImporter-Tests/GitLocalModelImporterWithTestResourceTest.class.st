"
This tests uses the test repository under GPHBridge (the files of the repository)
"
Class {
	#name : #GitLocalModelImporterWithTestResourceTest,
	#superclass : #TestCase,
	#instVars : [
		'localImporter',
		'model',
		'repository'
	],
	#category : #'GitProjectHealth-Model-LocalImporter-Tests'
}

{ #category : #accessing }
GitLocalModelImporterWithTestResourceTest class >> resources [

	^ Array with: GitLocalModelImporterWithTestResource
]

{ #category : #running }
GitLocalModelImporterWithTestResourceTest >> setUp [

	super setUp.
	localImporter := GitLocalModelImporter new.
	model := GLHModel new.
	localImporter glhModel: model.
	localImporter withFiles: true.
	localImporter withCommitDiffs: true.
	localImporter withDiffRanges: true.
	localImporter withCommitsSince: (DateAndTime year: 2026 day: 1).

	repository := GLHRepository new
		              cacheAt: #localImporterReference
		              put: GPHBridge testResources asFileReference;
		              yourself.

	model add: repository.
	localImporter importRepository: repository 
]

{ #category : #tests }
GitLocalModelImporterWithTestResourceTest >> testHasRenamedField [
	self halt.
]
