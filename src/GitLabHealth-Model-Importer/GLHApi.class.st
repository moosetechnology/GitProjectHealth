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

{ #category : #'api - commits' }
GLHApi >> commit: commitSHA ofProject: aProjectId [

	self client path: (String streamContents: [ :str |
			 str
				 << self baseAPIUrl;
				 << '/projects/';
				 << aProjectId asString;
				 << '/repository/commits/';
				 << commitSHA asString;
				 << '' ]).

	^ self client get
]

{ #category : #'api - commits' }
GLHApi >> commit: commitSHA ofProject: aProjectId withStat: stats [

	self client path: (String streamContents: [ :str |
			 str
				 << self baseAPIUrl;
				 << '/projects/';
				 << aProjectId asString;
				 << '/repository/commits/';
				 << commitSHA asString;
				 << '' ]).
			

	stats ifNotNil: [ self client queryAt: #stats put: stats ].

	^ self client get
]

{ #category : #'api - commits' }
GLHApi >> commitDiff: commitSHA ofProject: aProjectId unidiff: unidiff [

	self client path: (String streamContents: [ :str |
			 str
				 << self baseAPIUrl;
				 << '/projects/';
				 << aProjectId asString;
				 << '/repository/commits/';
				 << commitSHA asString;
				 << '/diff' ]).

	unidiff ifNotNil: [ self client queryAt: #unidiff put: unidiff ].


	('Call: ' , self client request url asString) recordInfo.

	^ self client get
]

{ #category : #'api - commits' }
GLHApi >> commitsOfProject: aProjectId [

	^ self
		  commitsOfProject: aProjectId
		  forRefName: nil
		  since: nil
		  until: nil
		  path: nil
		  author: nil
		  all: nil
		  with_stats: nil
		  firstParent: nil
		  order: nil
		  trailers: nil
		  perPage: nil
		  page: nil
]

{ #category : #commits }
GLHApi >> commitsOfProject: anInteger forRefName: refName since: since [ 

	^ self commitsOfProject: anInteger
		  forRefName: refName
		  since: since
		  until: nil
		  path: nil
		  author: nil
		  all: nil
		  with_stats: nil
		  firstParent: nil
		  order: nil
		  trailers: nil
		  perPage: nil
		  page: nil.
]

{ #category : #'api - commits' }
GLHApi >> commitsOfProject: aProjectId forRefName: refName since: since until: until path: aPath author: author all: aAllBoolean with_stats: withStateBoolean firstParent: firstParent order: orderString trailers: trailers perPage: aPerPageNumber page: aPageNumber [
	"https://docs.gitlab.com/ee/api/commits.html#list-repository-commits"

	self client path:
		self baseAPIUrl , '/projects/' , aProjectId printString
		, '/repository/commits'.
	refName ifNotNil: [ self client queryAt: #ref_name put: refName ].
	since ifNotNil: [ self client queryAt: #since put: since ].
	until ifNotNil: [ self client queryAt: #until put: until ].
	aPath ifNotNil: [ self client queryAt: #path put: aPath ].
	author ifNotNil: [ self client queryAt: #author put: author ].
	aAllBoolean ifNotNil: [ self client queryAt: #all put: aAllBoolean ].
	withStateBoolean ifNotNil: [
		self client queryAt: #with_stats put: withStateBoolean ].
	firstParent ifNotNil: [
		self client queryAt: #first_parent put: firstParent ].
	orderString ifNotNil: [ self client queryAt: #order put: orderString ].
	trailers ifNotNil: [ self client queryAt: #trailers put: trailers ].
	aPerPageNumber ifNotNil: [
		self client queryAt: #per_page put: aPerPageNumber ].
	aPageNumber ifNotNil: [ self client queryAt: #page put: aPageNumber ].

	^ self client get
]

{ #category : #'api - repositories' }
GLHApi >> compareProject: aProjectID from: fromSha to: toSha fromProject: fromProjectID straight: straight unidiff: unidiff [

	self client path:
		self baseAPIUrl , '/projects/' , aProjectID printString
		, '/repository/compare'.

	self client queryAt: #from put: fromSha.
	self client queryAt: #to put: toSha.

	fromProjectID ifNotNil: [
		self client queryAt: #from_project_id put: fromProjectID ].
	straight ifNotNil: [ self client queryAt: #straight put: straight ].
	unidiff ifNotNil: [ self client queryAt: #unidiff put: unidiff ].

	^ self client get
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

{ #category : #'api - projects' }
GLHApi >> editProject: aProjectID usingDictionary: aDictionaryOfNewParam [

	self client url:
		self baseAPIUrl , '/projects/' , aProjectID printString.
	aDictionaryOfNewParam keysAndValuesDo: [ :k :v | 
		self client queryAt: k put: v ].

	^ self client put
]

{ #category : #'api - repository files' }
GLHApi >> getFileBlameForProject: aProjectId andFilePath: aFilePath inRef: aRef fromLine: rangeStart toLine: rangeEnd [
	"filePath is converted here. So give a path such as ""path/to/file.md"""

	"https://docs.gitlab.com/ee/api/repository_files.html#get-file-blame-from-repository"

	self client url:
		self baseAPIUrl , '/projects/' , aProjectId printString
		, '/repository/files/' , (aFilePath withoutPrefix: '/') urlEncoded
		, '/blame'.
	self client queryAt: #ref put: aRef.
	self client queryAt: #'range[start]' put: rangeStart.
	self client queryAt: #'range[end]' put: rangeEnd.

	^ self client get
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

{ #category : #'api - jobs' }
GLHApi >> jobsOfProject: aProjectID ofPipelines: aPipelineID [

	^ self client get:
		  self baseAPIUrl , '/projects/' , aProjectID printString
		  , '/pipelines/' , aPipelineID printString , '/jobs'
]

{ #category : #'api - groups' }
GLHApi >> listGroupsWithTopLevelOnly: topLevelOnly page: aPageNumber [
	"https://docs.gitlab.com/ee/api/groups.html#list-groups"

	self client url: self baseAPIUrl , '/groups'.
	topLevelOnly ifNotNil: [
		self client queryAt: #top_level_only put: topLevelOnly ].
	aPageNumber ifNotNil: [ self client queryAt: #page put: aPageNumber ].
	self client queryAt: #per_page put: 100.
	^ self client get
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

{ #category : #api }
GLHApi >> userWithUsername: anUsername [

	^ self client get: self baseAPIUrl , '/users?username=' , anUsername
]
