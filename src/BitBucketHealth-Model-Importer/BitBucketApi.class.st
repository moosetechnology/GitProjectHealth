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

{ #category : #'api - projects' }
BitBucketApi >> commitsOfRepo: repositorySlug inProject: projectKey since: since until: until [
	"/rest/api/1.0/projects/{projectKey}/repos/{repositorySlug}/commits"

	| results lastDate lastCommitterTimestamp commits |
	self prepareZnClient.
	self client path:
		self basePath , '/projects/' , projectKey , '/repos/'
		, repositorySlug , '/commits'.

	commits := OrderedCollection new.

	[
	results := self client get.
	results := (NeoJSONReader on: results readStream) next.
	commits addAll: (results at: #values).
	results
		at: #nextPageStart
		ifPresent: [
		client queryAt: #start put: (results at: #nextPageStart) ].

	lastCommitterTimestamp := commits last at: #committerTimestamp.
	lastDate := DateAndTime fromUnixTime: lastCommitterTimestamp / 1000.

	(results at: #isLastPage) not and: since asDate <= lastDate ]
		whileTrue.

	^ commits select: [ :commit |
		  | commitDate |
		  commitDate := DateAndTime fromUnixTime:
			                (commit at: #committerTimestamp) / 1000.
		  commitDate >= since asDate and: commitDate <= until asDate ]
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

	self bearerToken ifNotNil: [ :anApiKey |
		client headerAt: #Authorization put: 'Bearer ' , anApiKey ].
	self apiToken ifNotNil: [ :anApiKey |
		client headerAt: #Authorization put: 'Basic '
			, (self username , ':' , self apiToken) utf8Encoded base64Encoded ]
]

{ #category : #'api - projects' }
BitBucketApi >> projects [
	"/rest/api/1.0/projects"

	^ self allValuesOfPath: self basePath , '/projects'.
]

{ #category : #'api - projects' }
BitBucketApi >> repositoriesOfProject: projectKey [
	^self allValuesOfPath: self basePath, '/projects/', projectKey, '/repos'.
]

{ #category : #'api - user' }
BitBucketApi >> user: accountId [
	"https://developer.atlassian.com/cloud/bitbucket/rest/api-group-users/#api-user-get"

	self prepareZnClient.
	
	self client path: self basePath, '/user/' , accountId printString.
	^ self client get
]

{ #category : #accessing }
BitBucketApi >> username [

	^ username
]

{ #category : #accessing }
BitBucketApi >> username: anObject [

	username := anObject
]
