Class {
	#name : #GLHApiMock,
	#superclass : #GLHApi,
	#category : #'GitLabHealth-Model-Importer-Tests'
}

{ #category : #'api - commits' }
GLHApiMock >> commitDiff: aCommitID ofProject: aProjectId unidiff: aBoolean [

	aCommitID = 'createError' ifTrue: [
		^ '{"message":"500 Internal Server Error"}' ]
]
