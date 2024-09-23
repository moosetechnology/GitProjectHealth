Class {
	#name : #BitBucketApi,
	#superclass : #Object,
	#instVars : [
		'baseAPIUrl',
		'client',
		'bearerToken',
		'apiToken',
		'username'
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

	client := ZnClient new
		          accept: ZnMimeType applicationJson;
		          yourself.

	self bearerToken ifNotNil: [ :anApiKey |
		client headerAt: #Authorization put: 'Bearer ' , anApiKey ].
	self apiToken ifNotNil: [ :anApiKey |
		client
			headerAt: #Authorization
			put:
			'Basic '
			, (self username , ':' , self apiToken) utf8Encoded base64Encoded ]
]

{ #category : #'api - user' }
BitBucketApi >> user: accountId [
	"https://developer.atlassian.com/cloud/bitbucket/rest/api-group-users/#api-user-get"

	self prepareZnClient.

	^ self client get: self baseAPIUrl , '/user/' , accountId printString
]

{ #category : #accessing }
BitBucketApi >> username [

	^ username
]

{ #category : #accessing }
BitBucketApi >> username: anObject [

	username := anObject
]
