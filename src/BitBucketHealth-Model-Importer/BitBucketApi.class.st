Class {
	#name : #BitBucketApi,
	#superclass : #Object,
	#instVars : [
		'baseAPIUrl',
		'client',
		'bearerToken',
		'apiToken',
		'user'
	],
	#category : #'BitBucketHealth-Model-Importer'
}

{ #category : #accessing }
BitBucketApi >> apiToken [

	^ apiToken
]

{ #category : #accessing }
BitBucketApi >> apiToken: anObject [

	apiToken := anObject
]

{ #category : #accessing }
BitBucketApi >> baseAPIUrl [

	^ baseAPIUrl
]

{ #category : #accessing }
BitBucketApi >> baseAPIUrl: anObject [

	baseAPIUrl := anObject
]

{ #category : #accessing }
BitBucketApi >> bearerToken [

	^ bearerToken
]

{ #category : #accessing }
BitBucketApi >> bearerToken: token [
	self client headerAt: #Authorization put: 'Bearer ' , token.
]

{ #category : #accessing }
BitBucketApi >> client [

	^ client
]

{ #category : #accessing }
BitBucketApi >> client: anObject [

	client := anObject
]

{ #category : #initialization }
BitBucketApi >> initialize [

		self client: (ZnClient new
			 accept: ZnMimeType applicationJson;
			 yourself)
]

{ #category : #'private - building' }
BitBucketApi >> prepareZnClient [

	client := ZnClient new.
	client host: self baseAPIUrl.

	self bearerToken ifNotNil: [ :anApiKey |
		client headerAt: #Authorization put: 'Bearer ' , anApiKey ].
	self apiToken ifNotNil: [ :anApiKey |
		client
			headerAt: #Authorization
			put:
			'Basic '
			, (self user , ':' , self apiToken) utf8Encoded base64Encoded ]
]

{ #category : #accessing }
BitBucketApi >> user [

	^ user
]

{ #category : #accessing }
BitBucketApi >> user: anObject [

	user := anObject
]
