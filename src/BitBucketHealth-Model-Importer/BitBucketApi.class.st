Class {
	#name : #BitBucketApi,
	#superclass : #Object,
	#instVars : [
		'endpoint',
		'basePath',
		'client',
		'bearerToken',
		'apiToken',
		'username'
	],
	#category : #'BitBucketHealth-Model-Importer'
}

{ #category : #'private - building' }
BitBucketApi >> allValuesOfPath: path [

	| results values |
	self prepareZnClient.
	self client path: path.
	values := OrderedCollection new.

	[
	results := self client get.
	results := (NeoJSONReader on: results readStream) next.
	values addAll: (results at: #values).
	results
		at: #nextPageStart
		ifPresent: [
		client queryAt: #start put: (results at: #nextPageStart) ].
	results at: #isLastPage ] whileFalse.

	^ values
]

{ #category : #accessing }
BitBucketApi >> apiToken [

	^ apiToken
]

{ #category : #accessing }
BitBucketApi >> apiToken: anObject [

	apiToken := anObject
]

{ #category : #accessing }
BitBucketApi >> basePath [

	^ basePath
]

{ #category : #accessing }
BitBucketApi >> basePath: anObject [

	basePath := anObject
]

{ #category : #accessing }
BitBucketApi >> bearerToken [

	^ bearerToken
]

{ #category : #accessing }
BitBucketApi >> bearerToken: anObject [

	bearerToken := anObject
]

{ #category : #accessing }
BitBucketApi >> client [

	^ client
]

{ #category : #accessing }
BitBucketApi >> client: anObject [

	client := anObject
]

{ #category : #accessing }
BitBucketApi >> endpoint [

	^ endpoint
]

{ #category : #accessing }
BitBucketApi >> endpoint: anObject [

	endpoint := anObject
]

{ #category : #initialization }
BitBucketApi >> initialize [

	self client: (ZnClient new
			 accept: ZnMimeType applicationJson;
			 yourself).
			
	self basePath: 'rest/api/1.0'
]

{ #category : #'private - building' }
BitBucketApi >> prepareZnClient [

	client := ZnClient new
		          accept: ZnMimeType applicationJson;
		          yourself.

	client host: self endpoint.
	client http.

	self bearerToken ifNotNil: [ :token |
		client headerAt: #Authorization put: 'Bearer ' , token ].
	self apiToken ifNotNil: [ :anApiKey |
		client headerAt: #Authorization put: 'Basic '
			, (self username , ':' , self apiToken) utf8Encoded base64Encoded ].
]

{ #category : #accessing }
BitBucketApi >> username [

	^ username
]

{ #category : #accessing }
BitBucketApi >> username: anObject [

	username := anObject
]
