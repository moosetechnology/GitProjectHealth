Class {
	#name : #BitBucketCommitsMock,
	#superclass : #BitbucketApiMock,
	#category : #'BitBucketHealth-Model-Importer-Tests'
}

{ #category : #'api - get' }
BitBucketCommitsMock >> allSince: since until: until inRepository: repositorySlug ofProject: projectKey [

	^ self commitsMock select: [ :commit |
		  | commitDate |
		  commitDate := DateAndTime fromUnixTime:
			                (commit at: #committerTimestamp) / 1000.

		  commitDate >= since asDate and: commitDate <= until asDate ]
]

{ #category : #'api - get' }
BitBucketCommitsMock >> diffOf: commitId inRepository: repositorySlug ofProject: projectKey [

		^ diffs
]
