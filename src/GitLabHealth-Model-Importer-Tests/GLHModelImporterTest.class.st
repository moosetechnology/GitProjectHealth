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

{ #category : #'class initialization' }
GLHModelImporterTest class >> initialize [

	
]

{ #category : #running }
GLHModelImporterTest >> setUp [

	super setUp.

	"Put here a common initialization logic for tests"
	glphModel := GLPHEModel new.

	glphApi := GLPHApi new
		           privateToken: '';
		           baseAPIUrl: 'https://gitlab.com/api/v4';
		           yourself.

	since := Date today - 2 day.

	glhImporter := GLPHModelImporter new
		               glhApi: glphApi;
		               glhModel: glphModel;
		               withFiles: false;
		               withCommitsSince: 0 day;
		               withCommitDiffs: true.
		
	glhImporter importGroup: 87194534.
]

{ #category : #tests }
GLHModelImporterTest >> testImport [
]
