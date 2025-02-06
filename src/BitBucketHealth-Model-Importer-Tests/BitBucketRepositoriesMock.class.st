Class {
	#name : #BitbucketRepositoriesMock,
	#superclass : #BitBucketApiMock,
	#category : #'BitBucketHealth-Model-Importer-Tests'
}

{ #category : #'api - get' }
BitbucketRepositoriesMock >> allInProject: projectKey [

	^self repositoriesMock.
]
