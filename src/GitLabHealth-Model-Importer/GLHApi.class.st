"
This is the API. I do not perform any kinds of JSON transformation
"
Class {
	#name : #GLHApi,
	#superclass : #Object,
	#instVars : [
		'baseAPIUrl',
		'client'
	],
	#classVars : [
		'currentAPI'
	],
	#category : #'GitLabHealth-Model-Importer'
}

{ #category : #accessing }
GLHApi class >> current [

	^ currentAPI
]

{ #category : #accessing }
GLHApi >> baseAPIUrl [

	^ baseAPIUrl
]

{ #category : #accessing }
GLHApi >> baseAPIUrl: anObject [

	baseAPIUrl := anObject
]

{ #category : #accessing }
GLHApi >> client [

	^ client
]

{ #category : #accessing }
GLHApi >> client: anObject [

	client := anObject
]

{ #category : #initialization }
GLHApi >> initialize [

	self client: (ZnClient new
			 accept: ZnMimeType applicationJson;
			 yourself).

]

{ #category : #'as yet unclassified' }
GLHApi >> makeGlobal [ 
		currentAPI := self
]

{ #category : #accessing }
GLHApi >> privateToken [

	^ self client request headers at: #'PRIVATE-TOKEN'
]

{ #category : #accessing }
GLHApi >> privateToken: anObject [

	self client headerAt: #'PRIVATE-TOKEN' add: anObject
]

{ #category : #private }
GLHApi >> resetClient [

	| token |
	token := self privateToken.
	self client initialize.
	self privateToken: token.
	self client accept: ZnMimeType applicationJson
]
