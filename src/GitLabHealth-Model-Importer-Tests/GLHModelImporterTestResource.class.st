Class {
	#name : #GLHModelImporterTestResource,
	#superclass : #MooseModelTestResource,
	#instVars : [
		'glphApi',
		'glhImporter'
	],
	#category : #'GitLabHealth-Model-Importer-Tests'
}

{ #category : #setup }
GLHModelImporterTestResource >> glhImporter [

	^ glhImporter
]

{ #category : #setup }
GLHModelImporterTestResource >> importModel [

	model := GLHModel new.

	glphApi := GLPHApi new
		           privateToken: '';
		           baseAPIUrl: 'https://gitlab.com/api/v4';
		           yourself.

	glhImporter := GitlabModelImporter new
		               repoApi: glphApi;
		               glhModel: model;
		               withFiles: false;
		               withCommitDiffs: true.

	glhImporter importGroup: 87194534
]
