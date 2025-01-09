Class {
	#name : #GLPHApi,
	#superclass : #GLHApi,
	#category : #'GitLabProjectHealth-Model-Importer'
}

{ #category : #initialization }
GLPHApi >> initialize [

	super initialize
]

{ #category : #mergeRequest }
GLPHApi >> mergeRequestsOfProject: aProjectId createdAfter: createdAfter createdBefore: createdBefore authorId: authorId authorUsername: authorUsername scope: scope orderBy: orderBy page: page [

	self client path:
		self baseAPIUrl , '/projects/' , aProjectId printString
		, '/merge_requests'.

	createdAfter ifNotNil: [
		self client queryAt: #created_after put: createdAfter ].
	createdBefore ifNotNil: [
		self client queryAt: #created_before put: createdBefore ].
	authorId ifNotNil: [ self client queryAt: #author_id put: authorId ].
	authorUsername ifNotNil: [
		self client queryAt: #author_username put: authorUsername ].
	scope ifNotNil: [ self client queryAt: #scope put: scope ].
	orderBy ifNotNil: [ self client queryAt: #order_by put: orderBy ].
	page ifNotNil: [ self client queryAt: #page put: page ].

	^ self client get
]

{ #category : #accessing }
GLPHApi >> project: aProjectID [

	^ self client get:
		  self baseAPIUrl , '/projects/' , aProjectID printString
]

{ #category : #user }
GLPHApi >> usersSearchByUsername: aUserName [ 
	|name|
	
	name := (aUserName splitOn: ' ') collect: [:part | part urlEncoded].
	name := '+' join: name.
	
	^ self client get: self baseAPIUrl , '/users?search=' , name 
]
