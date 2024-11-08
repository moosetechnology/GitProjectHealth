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
	#category : #'GitLabHealth-Model-Importer-Tests'
}

{ #category : #running }
GLHModelImporterLocalTest >> setUp [

	super setUp.

	importer := GLHModelImporter new.
	model := GLHModel new.
	importer glhModel: model.
	importer repoApi: GLHApiMock new
]

{ #category : #tests }
GLHModelImporterLocalTest >> testImportDiffOfCommitWithServerRaiseError [

	| commit repo project |
	commit := model newCommit.
	commit id: 'createError'.
	repo := model newRepository.
	commit repository: repo.
	project := model newProject.
	repo project: project.
	importer importDiffOfCommit: commit.
	self assert: commit diffs isEmpty
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

{ #category : #tests }
GLHModelImporterLocalTest >> testIsServerError [

	self assert:
		(importer isServerError: '{"message":"500 Internal Server Error"}')
]

{ #category : #tests }
GLHModelImporterLocalTest >> testParseUserResult [

	| user |
	user := importer importUser: 123.
	self assert: user id equals: 123.

	self assert: user name equals:  'dupond jack'.
	self assert: user email equals:  'jack.dupond@myCompany.com'.
	self assert: user public_email equals:  'jack.dupond-public@myCompany.com'.
]
