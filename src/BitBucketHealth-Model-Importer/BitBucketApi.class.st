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

{ #category : #'api - pull-requests' }
BitBucketApi >> activitiesOfPullRequest: pullRequestId inRepo: repositorySlug ofProject: projectKey [

	^ self allValuesOfPath:
		  self basePath , '/projects/' , projectKey , '/repos/'
		  , repositorySlug , '/pull-requests/' , pullRequestId printString
		  , '/activities'
]

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

{ #category : #'api - pull-requests' }
BitBucketApi >> commitsOfPullRequest: pullRequestId ofRepo: repoSlug inProject: projectKey [
	^ self allValuesOfPath: self basePath, '/projects/', projectKey, '/repos/', repoSlug, '/pull-requests/', pullRequestId printString, '/commits'.
	
]

{ #category : #'api - commits' }
BitBucketApi >> commitsOfRepo: repositorySlug inProject: projectKey since: since until: until [
	"/rest/api/1.0/projects/{projectKey}/repos/{repositorySlug}/commits"

	| results lastDate lastCommitterTimestamp commits |
	self prepareZnClient.
	self client path:
		self basePath , '/projects/' , projectKey , '/repos/'
		, repositorySlug , '/commits'.
	self client queryAt: 'merges' put: 'exclude'.

	commits := OrderedCollection new.

	[
	results := self client get.
	results := (NeoJSONReader on: results readStream) next.
	commits addAll: (results at: #values).
	results
		at: #nextPageStart
		ifPresent: [
		client queryAt: #start put: (results at: #nextPageStart) ].

	(results at: #isLastPage)
		ifTrue: [ false ]
		ifFalse: [
			lastCommitterTimestamp := commits last at: #committerTimestamp.
			lastDate := DateAndTime fromUnixTime: lastCommitterTimestamp / 1000.
			since asDate <= lastDate ] ] whileTrue.

	^ commits select: [ :commit |
		  | commitDate |
		  commitDate := DateAndTime fromUnixTime:
			                (commit at: #committerTimestamp) / 1000.
		  commitDate >= since asDateAndTime and:
			  commitDate <= until asDateAndTime ]
]

{ #category : #'api - commits' }
BitBucketApi >> diffsOfCommit: commitID inRepo: repositorySlug inProject: projectKey [

	| results |
	self prepareZnClient.

	self client path:
		self basePath , '/projects/' , projectKey , '/repos/'
		, repositorySlug , '/commits/' , commitID , '/diff'.

	results := self client get.

	^ (NeoJSONReader on: results readStream) next
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

{ #category : #'api - projects' }
BitBucketApi >> projects [
	"/rest/api/1.0/projects"

	^ self allValuesOfPath: self basePath , '/projects'.
]

{ #category : #'api - pull-requests' }
BitBucketApi >> pullRequestsOfRepo: repositorySlug inProject: projectKey since: since until: until [

	| pullRequests results lastCommitterTimestamp lastDate |
	self prepareZnClient.
	self client path:
		self basePath , '/projects/' , projectKey , '/repos/'
		, repositorySlug , '/pull-requests'.

	self client queryAt: 'state' put: 'all'.

	pullRequests := OrderedCollection new.

	[
	results := self client get.
	results := (NeoJSONReader on: results readStream) next.
	pullRequests addAll: (results at: #values).
	results
		at: #nextPageStart
		ifPresent: [
		client queryAt: #start put: (results at: #nextPageStart) ].

	(results at: #isLastPage)
		ifTrue: [ false ]
		ifFalse: [
			lastCommitterTimestamp := pullRequests last at: #createdDate.
			lastDate := DateAndTime fromUnixTime: lastCommitterTimestamp / 1000.
			since asDate <= lastDate ] ] whileTrue.

	^ pullRequests select: [ :commit |
		  | commitDate |
		  commitDate := DateAndTime fromUnixTime:
			                (commit at: #createdDate) / 1000.
		  commitDate >= since asDate and: commitDate <= until asDate ]
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

{ #category : #'api - user' }
BitBucketApi >> usersByUsername: usernameString [

	| users |
	self prepareZnClient.
	self client path: self basePath , '/admin/users'.
	self client queryAt: 'filter' put: usernameString.

	users := self client get.
	users := (NeoJSONReader on: users readStream) next.

	^ (users at: #values)
]
