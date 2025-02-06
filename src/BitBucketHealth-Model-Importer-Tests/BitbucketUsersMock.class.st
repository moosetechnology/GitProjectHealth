Class {
	#name : #BitBucketUsersMock,
	#superclass : #BitBucketApiMock,
	#category : #'BitBucketHealth-Model-Importer-Tests'
}

{ #category : #api }
BitBucketUsersMock >> allWithParams: paramsDict [

	userMock ifNil: [ ^Array new ] ifNotNil: [ ^{ userMock }]
]
