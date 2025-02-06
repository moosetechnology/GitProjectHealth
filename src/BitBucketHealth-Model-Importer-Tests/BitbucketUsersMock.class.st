Class {
	#name : #BitbucketUsersMock,
	#superclass : #Object,
	#instVars : [
		'userMock'
	],
	#category : #'BitBucketHealth-Model-Importer-Tests'
}

{ #category : #api }
BitbucketUsersMock >> allWithParams: paramsDict [

		userMock ifNil: [ ^ Array new ] ifNotNil: [ ^ { userMock } ]
]

{ #category : #initialization }
BitbucketUsersMock >> initialize [
		userMock := self user1.
]

{ #category : #accessing }
BitbucketUsersMock >> user1 [

	| user1 |
	user1 := '
    {
      "name": "test",
      "emailAddress": "test@test.com",
      "id": 1,
      "displayName": "test test",
      "active": true,
      "slug": "test",
      "type": "NORMAL",
      "directoryName": "directory",
      "deletable": false,
      "lastAuthenticationTimestamp": 1727444943000,
      "mutableDetails": false,
      "mutableGroups": true,
      "links": {
        "self": [
          {
            "href": "test.com"
          }
        ]
      }
    }
  '.


	^ user1 := (NeoJSONReader on: user1 readStream) next
]
