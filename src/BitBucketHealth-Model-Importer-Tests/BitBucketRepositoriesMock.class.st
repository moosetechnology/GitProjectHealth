Class {
	#name : #BitBucketRepositoriesMock,
	#superclass : #BitBucketApiMock,
	#category : #'BitBucketHealth-Model-Importer-Tests'
}

{ #category : #'api - get' }
BitBucketRepositoriesMock >> allInProject: projectKey [

	^self repositoriesMock.
]
