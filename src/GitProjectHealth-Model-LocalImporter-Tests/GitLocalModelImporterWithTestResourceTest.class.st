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
		              put: (GPHBridge testResources / 'testResource') asFileReference;
		              yourself.

	model add: repository.
]

{ #category : #tests }
GitLocalModelImporterWithTestResourceTest >> testFirstCommitHasADiff [

	| commit |
	localImporter importRepository: repository.
	commit := (model allWithType: GLHCommit) detect: [ :commi |
		          commi parentCommits isEmpty ].
	self assert: commit diffs isNotEmpty
]

{ #category : #tests }
GitLocalModelImporterWithTestResourceTest >> testHasRenamedField [

	| file |
	localImporter importRepository: repository.
	file := (model allWithType: GLHFileBlob) detect: [ :fileBlob |
		        fileBlob path endsWith: 'renamed-hello.st' ].
	self assert: file diffs size equals: 3.
	self assert: file diffs second renamed_file
]

{ #category : #tests }
GitLocalModelImporterWithTestResourceTest >> testImportFilesOfBranch [

	| file |
	localImporter importRepository: repository.
	file := (model allWithType: GLHFileBlob) detect: [ :fi |
		        fi name = 'renamed-hello.st' ].
	self assert: file isNotNil
]

{ #category : #tests }
GitLocalModelImporterWithTestResourceTest >> testImportFilesOfBranchDoNotImportNotCommitedFile [

	| file |
	(GPHBridge testResources / 'testResource' / 'wrong-file.st')
		ensureCreateFile.
	localImporter importRepository: repository.
	file := (model allWithType: GLHFileBlob)
		        detect: [ :fi | fi name = 'wrong-file.st' ]
		        ifNone: [ nil ].
	self assert: file isNil
]
