Class {
	#name : #BitBucketProjectsMock,
	#superclass : #BitBucketApiMock,
	#category : #'BitBucketHealth-Model-Importer-Tests'
}

{ #category : #accessing }
BitBucketProjectsMock >> all [

	^self projectsMock
]

{ #category : #api }
BitBucketProjectsMock >> get: aString [
	"string from https://docs.atlassian.com/bitbucket-server/rest/5.9.0/bitbucket-rest.html#idm29457918096"

	| content |
	content := '{"key":"PRJ","id":1,"name":"My Cool Project","description":"The description for my cool project.","public":true,"type":"NORMAL","links":{"self":[{"href":"http://link/to/project"}]}}'.
	^ (NeoJSONReader on: content readStream) next
]
