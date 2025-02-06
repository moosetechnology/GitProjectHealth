Class {
	#name : #BitbucketRepositoriesMock,
	#superclass : #BitbucketApiMock,
	#category : #'BitBucketHealth-Model-Importer-Tests'
}

{ #category : #'api - get' }
BitbucketRepositoriesMock >> allInProject: projectKey [

	^self repositoriesMock.
]
