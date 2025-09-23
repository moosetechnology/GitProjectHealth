Class {
	#name : #GitlabCommitsMock,
	#superclass : #Object,
	#category : #'GitLabHealth-Model-Importer-Tests'
}

{ #category : #api }
GitlabCommitsMock >> diffOf: commitSha inProject: projectId uniDiff: unidiff [

	commitSha = 'createError' ifTrue: [
		^ '{"message":"500 Internal Server Error"}' ].
	^ '[]'
]

{ #category : #api }
GitlabCommitsMock >> get: aString inProject: anUndefinedObject [ 
	^ '{
      "author_email": "admin@example.com",
      "author_name": "Administrator",
      "created_at": "2015-12-24T16:51:14.000+01:00",
      "id": "0ff3ae198f8601a285adcf5c0fff204ee6fba5fd",
      "message": "Test the CI integration.",
      "short_id": "0ff3ae19",
      "title": "Test the CI integration."
    }'
]

{ #category : #accessing }
GitlabCommitsMock >> readStream [
	self shouldBeImplemented.
]
