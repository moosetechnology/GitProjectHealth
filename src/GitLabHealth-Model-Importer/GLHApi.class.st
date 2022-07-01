Class {
	#name : #GLHApi,
	#superclass : #Object,
	#instVars : [
		'baseAPIUrl',
		'privateToken',
		'client'
	],
	#category : #'GitLabHealth-Model-Importer'
}

{ #category : #accessing }
GLHApi >> baseAPIUrl [

	^ baseAPIUrl
]

{ #category : #accessing }
GLHApi >> baseAPIUrl: anObject [

	baseAPIUrl := anObject
]

{ #category : #api }
GLHApi >> branchesOfRepository: aProjectID [

	^ self client get:
		  self baseAPIUrl , '/projects/' , aProjectID printString
		  , '/repository/branches'
]

{ #category : #accessing }
GLHApi >> client [

	^ client
]

{ #category : #accessing }
GLHApi >> client: anObject [

	client := anObject
]

{ #category : #'api - branches' }
GLHApi >> createBranch: newBranchName forProject: aProjectID fromBranch: refBranchName [

	self client url:
		self baseAPIUrl , '/projects/' , aProjectID printString
		, '/repository/branches'.
	self client queryAt: #ref put: refBranchName.
	self client queryAt: #branch put: newBranchName.
	^ self client post
]

{ #category : #'api - branches' }
GLHApi >> deleteBranch: branchName forProject: aProjectID [

	self client url:
		self baseAPIUrl , '/projects/' , aProjectID printString
		, '/repository/branches/' , branchName.
	^ self client delete
]

{ #category : #'api - projects' }
GLHApi >> editProject: aProjectID changeDefaultBranchTo: refBranchName [

	self client url:
		self baseAPIUrl , '/projects/' , aProjectID printString.
	self client queryAt: #default_branch put: refBranchName.
	^ self client put
]

{ #category : #api }
GLHApi >> group: aGroupID [

	^ self client get: self baseAPIUrl , '/groups/' , aGroupID printString
]

{ #category : #initialization }
GLHApi >> initialize [

	self client: (ZnClient new
			 accept: ZnMimeType applicationJson;
			 yourself)
]

{ #category : #api }
GLHApi >> pipelinesOfProject: aProjectID [
	^ self client get: self baseAPIUrl , '/projects/' , aProjectID printString, '/pipelines'
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

{ #category : #'api - groups' }
GLHApi >> subgroupsOfGroup: aGroupID [

	^ self client get:
		  self baseAPIUrl , '/groups/' , aGroupID printString , '/subgroups'
]

{ #category : #'api - groups' }
GLHApi >> subgroupsOfGroup: aGroupID page: aPageNumber [

	self client url:
		self baseAPIUrl , '/groups/' , aGroupID printString , '/subgroups'.
	aPageNumber ifNotNil: [ self client queryAt: #page put: aPageNumber ].
	^ self client get
]

{ #category : #api }
GLHApi >> treeOfRepository: aProjectID ofBranch: aBranchRef andPath: aPath [

	| result |
	self client url:
		self baseAPIUrl , '/projects/' , aProjectID printString
		, '/repository/tree'.
	aBranchRef ifNotNil: [ self client queryAt: #ref put: aBranchRef ].
	aPath ifNotNil: [ self client queryAt: #path put: aPath ].
	result := self client get.
	self resetClient.
	^ result
]

{ #category : #api }
GLHApi >> user: aUserID [

	^ self client get: self baseAPIUrl , '/users/' , aUserID printString
]
