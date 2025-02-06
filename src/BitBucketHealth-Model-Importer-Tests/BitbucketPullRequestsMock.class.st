Class {
	#name : #BitbucketPullRequestsMock,
	#superclass : #BitBucketApiMock,
	#category : #'BitBucketHealth-Model-Importer-Tests'
}

{ #category : #'api - get' }
BitbucketPullRequestsMock >> activitiesOf: pullRequestId inRepository: repositorySlug ofProject: projectKey [

		^ self pullRequestActivities
]

{ #category : #'api - get' }
BitbucketPullRequestsMock >> allSince: since until: until withParams: paramsDictionary inRepository: repositorySlug ofProject: projectKey [

	^ mergeRequests
]

{ #category : #'api - get' }
BitbucketPullRequestsMock >> commitsOf: pullRequestId inRepository: repositorySlug ofProject: projectKey [

		^ commitsMock
]
