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

{ #category : 'api' }
GHApi >> organization: anOrganizationName [

	^ self client get: self baseAPIUrl , '/orgs/' , anOrganizationName
]

{ #category : 'accessing' }
GHApi >> privateToken [

		^ self client request headers at: #'Authorization'
]

{ #category : 'accessing' }
GHApi >> privateToken: anObject [

	self client headerAt: #'Authorization' add: ('token ', anObject)
]

{ #category : 'api' }
GHApi >> reposOfOrganization: anOrganizationName [

	^ self client get: self baseAPIUrl , '/orgs/' , anOrganizationName, '/repos'
]

{ #category : 'api - users' }
GHApi >> user: aUserID [

	^ self client get: self baseAPIUrl , '/user/' , aUserID asString
]
