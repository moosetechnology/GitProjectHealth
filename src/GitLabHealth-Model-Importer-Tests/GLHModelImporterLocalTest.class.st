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

	importer := GitlabModelImporter new.
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
GLHModelImporterLocalTest >> testParseNote [
	| jsonNote notesArray note |
	
	jsonNote := '[{
  "id": 301,
  "body": "Comment for MR",
  "attachment": null,
  "author": {
    "id": 1,
    "username": "pipin",
    "email": "admin@example.com",
    "name": "Pip",
    "state": "active",
    "created_at": "2013-09-30T13:46:01Z"
  },
  "created_at": "2013-10-02T08:57:14Z",
  "updated_at": "2013-10-02T08:57:14Z",
  "system": false,
  "noteable_id": 2,
  "noteable_type": "MergeRequest",
  "project_id": 5,
  "noteable_iid": 2,
  "resolvable": false,
  "confidential": false,
  "internal": false
}]'.
	notesArray := importer parseNoteJson: jsonNote.
	note := notesArray first.
	self assert: notesArray size equals: 1.
	self assert: note body equals: 'Comment for MR'
	
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
