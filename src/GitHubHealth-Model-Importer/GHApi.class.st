"
You can use me to extract query [GitHub REST Api](https://docs.github.com/en/rest)
"
Class {
	#name : 'GHApi',
	#superclass : 'Object',
	#instVars : [
		'baseAPIUrl',
		'client'
	],
	#category : 'GitHubHealth-Model-Importer',
	#package : 'GitHubHealth-Model-Importer'
}

{ #category : 'api' }
GHApi >> actionsRunOfRepo: aRepoName ofOrganization: anOrganizationName [

	^ self client get:
		  self baseAPIUrl , '/repos/' , anOrganizationName , '/' , aRepoName
		  , '/actions/runs'
]

{ #category : 'accessing' }
GHApi >> baseAPIUrl [

	^ baseAPIUrl
]

{ #category : 'accessing' }
GHApi >> baseAPIUrl: anObject [

	baseAPIUrl := anObject
]

{ #category : 'api' }
GHApi >> branchesOfRepo: aRepoName ofOrganization: anOrganizationName [

	self client url:
		self baseAPIUrl , '/repos/' , anOrganizationName , '/' , aRepoName
		, '/branches'.
	^ self client get
]

{ #category : 'accessing' }
GHApi >> client [

	^ client
]

{ #category : 'accessing' }
GHApi >> client: anObject [

	client := anObject
]

{ #category : 'api - commits' }
GHApi >> commit: commitSHA ofOrganisation: anOrganisation ofProject: aProjectId [

	self client path: (String streamContents: [ :str |
			 str
				 << self baseAPIUrl;
				 << '/repos/';
				 << anOrganisation asString;
				 << '/';
				 << aProjectId asString;
				 << '/commits/';
				 << commitSHA asString ]).


	('Call: ' , self client request url asString) recordInfo.

	^ (NeoJSONReader on: (self client get) readStream) next
]

{ #category : 'api - commits' }
GHApi >> commitDiff: commitSHA ofProject: aProjectId unidiff: unidiff [ 
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

{ #category : 'api - commits' }
GHApi >> commitsOfProject: aProjectId ofOrganization: organisationName [

	^ self
		  commitsOfProject: aProjectId
		  ofOrganization: organisationName
		  since: nil
		  perPage: nil
		  page: nil
]

{ #category : 'api - commits' }
GHApi >> commitsOfProject: aProjectId ofOrganization: organisationName since: aSinceDate perPage: itemPerPage page: pageNumber [

	self client url:
		self baseAPIUrl , '/repos/' , organisationName , '/' , aProjectId
		, '/commits'.
	aSinceDate ifNotNil: [ self client queryAt: #since put: aSinceDate ].
	itemPerPage ifNotNil: [
		self client queryAt: #per_page put: itemPerPage ].
	pageNumber ifNotNil: [ self client queryAt: #page put: pageNumber ].
	^ self client get
]

{ #category : 'api' }
GHApi >> contentsOfRepo: aRepoName ofOrganization: anOrganizationName inBranch: aBranchRef withPath: aPath [

	self client url:
		self baseAPIUrl , '/repos/' , anOrganizationName , '/' , aRepoName
		, '/contents/' , (aPath ifNil: [ '' ]).
	aBranchRef ifNotNil: [ self client queryAt: #ref put: aBranchRef ].
	^ self client get
]

{ #category : 'initialization' }
GHApi >> initialize [

	self baseAPIUrl: 'https://api.github.com'.
	self client: (ZnClient new
			 accept: ZnMimeType applicationJson;
			 yourself)
]

{ #category : 'as yet unclassified' }
GHApi >> mergeRequestsOfRepo: aRepoName ofProject: aProjectName [

	^ self
		  mergeRequestsOfRepo: aRepoName
		  ofProject: aProjectName
		  state: 'all'
		  head: nil
		  base: nil
		  sort: nil
		  direction: nil
		  per_page: nil
		  page: nil
]

{ #category : 'merge request' }
GHApi >> mergeRequestsOfRepo: organisationName ofProject: projectName state: state head: head base: base sort: sort direction: direction per_page: per_page page: page [ 
	self client url:
		self baseAPIUrl , '/repos/' , organisationName , '/' , projectName
		, '/pulls'.
		
	state ifNotNil: [ self client queryAt: #state put: state ].
	head ifNotNil: [ self client queryAt: #head put: head ].
	base ifNotNil: [ self client queryAt: #base put: base ].
	base ifNotNil: [ self client queryAt: #base put: base ].
	sort ifNotNil: [ self client queryAt: #sort put: sort ].	
	direction ifNotNil: [ self client queryAt: #direction put: direction ].
	per_page ifNotNil: [ self client queryAt: #per_page put: per_page ].
	page ifNotNil: [ self client queryAt: #page put: page ].
	
	('Call: ' , self client request url asString) recordInfo.

	^ (NeoJSONReader on: self client get readStream) next
	
]

{ #category : 'api' }
GHApi >> organization: anOrganizationName [

	^ self client get: self baseAPIUrl , '/orgs/' , anOrganizationName
]

{ #category : 'api' }
GHApi >> organization: aGroupName repo: aRepoName [

	^ self client get:
		  self baseAPIUrl , '/repos/' , aGroupName , '/' , aRepoName
]

{ #category : 'accessing' }
GHApi >> privateToken [

		^ self client request headers at: #'Authorization'
]

{ #category : 'accessing' }
GHApi >> privateToken: anObject [

	self client headerAt: #'Authorization' add: ('token ', anObject)
]

{ #category : 'api - repositories' }
GHApi >> reposOfOrganization: anOrganizationName [

	^ self reposOfOrganization: anOrganizationName perPage: nil page: nil
]

{ #category : 'api - repositories' }
GHApi >> reposOfOrganization: anOrganizationName perPage: itemPerPage page: pageNumber [

	self client url:
		self baseAPIUrl , '/orgs/' , anOrganizationName , '/repos'.
	itemPerPage ifNotNil: [
		self client queryAt: #per_page put: itemPerPage ].
	pageNumber ifNotNil: [ self client queryAt: #page put: pageNumber ].
	^ self client get
]

{ #category : 'api - users' }
GHApi >> user: aUserID [

	^ self client get: self baseAPIUrl , '/user/' , aUserID asString
]
