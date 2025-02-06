Class {
	#name : #BitBucketPullRequestsMock,
	#superclass : #BitBucketApiMock,
	#category : #'BitBucketHealth-Model-Importer-Tests'
}

{ #category : #'api - get' }
BitBucketPullRequestsMock >> activitiesOf: pullRequestId inRepository: repositorySlug ofProject: projectKey [

		^ self pullRequestActivities
]

{ #category : #'api - get' }
BitBucketPullRequestsMock >> allSince: since until: until withParams: paramsDictionary inRepository: repositorySlug ofProject: projectKey [

	^ mergeRequests
]

{ #category : #'api - get' }
BitBucketPullRequestsMock >> commitsOf: pullRequestId inRepository: repositorySlug ofProject: projectKey [

		^ commitsMock
]
