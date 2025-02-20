Class {
	#name : #GitlabCommitsMock,
	#superclass : #Object,
	#category : #'GitLabHealth-Model-Importer-Tests'
}

{ #category : #api }
GitlabCommitsMock >> diffOf: commitSha inProject: projectId uniDiff: unidiff [
	commitSha = 'createError' ifTrue: [
		^ '{"message":"500 Internal Server Error"}' ]
]
