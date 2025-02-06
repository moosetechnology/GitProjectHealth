Class {
	#name : #BitbucketUsersMock,
	#superclass : #BitBucketApiMock,
	#category : #'BitBucketHealth-Model-Importer-Tests'
}

{ #category : #api }
BitbucketUsersMock >> allWithParams: paramsDict [

	userMock ifNil: [ ^Array new ] ifNotNil: [ ^{ userMock }]
]
