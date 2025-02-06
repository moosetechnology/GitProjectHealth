Class {
	#name : #BitbucketCommitsMock,
	#superclass : #BitbucketApiMock,
	#category : #'BitBucketHealth-Model-Importer-Tests'
}

{ #category : #'api - get' }
BitbucketCommitsMock >> allSince: since until: until inRepository: repositorySlug ofProject: projectKey [

	^ self commitsMock select: [ :commit |
		  | commitDate |
		  commitDate := DateAndTime fromUnixTime:
			                (commit at: #committerTimestamp) / 1000.

		  commitDate >= since asDate and: commitDate <= until asDate ]
]

{ #category : #'api - get' }
BitbucketCommitsMock >> diffOf: commitId inRepository: repositorySlug ofProject: projectKey [

		^ diffs
]
