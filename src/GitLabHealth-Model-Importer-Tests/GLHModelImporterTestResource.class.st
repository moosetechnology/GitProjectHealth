Class {
	#name : #GLHModelImporterTestResource,
	#superclass : #MooseModelTestResource,
	#instVars : [
		'glphApi',
		'since',
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

	since := Date today - 2 day.

	glhImporter := GLPHModelImporter new
		               glhApi: glphApi;
		               glhModel: model;
		               withFiles: false;
		               withCommitsSince: 0 day;
		               withCommitDiffs: true.

	glhImporter importGroup: 87194534
]
