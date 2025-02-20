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

	| gitlabApi |
	model := GLHModel new.

	gitlabApi := GitlabApi new privateToken: ''; hostUrl: 'https://gitlab.com/api/v4'; output: 'json'.
	
	"GLPHApi new
		           privateToken: '';
		           baseAPIUrl: 'https://gitlab.com/api/v4';
		           yourself."

	glhImporter := GitlabModelImporter new
		               repoApi: gitlabApi;
		               glhModel: model;
		               withFiles: false;
		               withCommitDiffs: true.

	glhImporter importGroup: 87194534
]
