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
GLHModelImporterTestResource >> importModel [

	model := GLPHEModel new.

	glphApi := GLPHApi new
		           privateToken: '';
		           baseAPIUrl: 'https://gitlab.com/api/v4';
		           yourself.

	glhImporter := GLHModelImporter new
		               glhApi: glphApi;
		               glhModel: model;
		               withFiles: false;
		               withCommitDiffs: true.

	glhImporter importGroup: 87194534
]
