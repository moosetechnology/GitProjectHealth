Class {
	#name : #BitbucketUsersMock,
	#superclass : #BitbucketApiMock,
	#category : #'BitBucketHealth-Model-Importer-Tests'
}

{ #category : #api }
BitbucketUsersMock >> allWithParams: paramsDict [

	userMock ifNil: [ ^Array new ] ifNotNil: [ ^{ userMock }]
]
