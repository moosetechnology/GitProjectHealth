"
You can use me to extract query [GitHub REST Api](https://docs.github.com/en/rest)
"
Class {
	#name : #GHApi,
	#superclass : #GithubApi,
	#instVars : [
		'baseAPIUrl'
	],
	#category : #'GitHubHealth-Model-Importer'
}

{ #category : #testing }
GHApi class >> isDeprecated [
		" Uses GithubApi instead of GHApi"
		^ true
]

{ #category : #api }
GHApi >> actionsRunOfRepo: aRepoName ofOrganization: anOrganizationName [

	^ self client get:
		  self baseAPIUrl , '/repos/' , anOrganizationName , '/' , aRepoName
		  , '/actions/runs'
]

{ #category : #accessing }
GHApi >> baseAPIUrl [

	self
		deprecated: 'Use hostUrl instead of current one'
		on: '31 July 2025'
		in:
		'Pharo-12.0.0+SNAPSHOT.build.1571.sha.cf5fcd22e66957962c97dffc58b0393b7f368147 (64 Bit)'.

	^ self hostUrl
]

{ #category : #accessing }
GHApi >> baseAPIUrl: anObject [

	self
		deprecated: 'Use hostUrl: instead of current one'
		on: '31 July 2025'
		in:
		'Pharo-12.0.0+SNAPSHOT.build.1571.sha.cf5fcd22e66957962c97dffc58b0393b7f368147 (64 Bit)'.

	self hostUrl: anObject
]

{ #category : #api }
GHApi >> branchesOfRepo: aRepoName ofOrganization: anOrganizationName [

	self client url:
		self baseAPIUrl , '/repos/' , anOrganizationName , '/' , aRepoName
		, '/branches'.
	^ self client get
]

{ #category : #'api - commits' }
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

{ #category : #'api - commits' }
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

{ #category : #'api - commits' }
GHApi >> commitsOfProject: aProjectId ofOrganization: organisationName [

	^ self
		  commitsOfProject: aProjectId
		  ofOrganization: organisationName
		  since: nil
		  perPage: nil
		  page: nil
]

{ #category : #'api - commits' }
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

{ #category : #api }
GHApi >> contentsOfRepo: aRepoName ofOrganization: anOrganizationName inBranch: aBranchRef withPath: aPath [

	self client url:
		self baseAPIUrl , '/repos/' , anOrganizationName , '/' , aRepoName
		, '/contents/' , (aPath ifNil: [ '' ]).
	aBranchRef ifNotNil: [ self client queryAt: #ref put: aBranchRef ].
	^ self client get
]

{ #category : #'merge request' }
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

{ #category : #'merge request' }
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

{ #category : #api }
GHApi >> organization: anOrganizationName [

	^ self client get: self baseAPIUrl , '/orgs/' , anOrganizationName
]

{ #category : #api }
GHApi >> organization: aGroupName repo: aRepoName [

	^ self client get:
		  self baseAPIUrl , '/repos/' , aGroupName , '/' , aRepoName
]

{ #category : #'api - repositories' }
GHApi >> reposOfOrganization: anOrganizationName [

	^ self reposOfOrganization: anOrganizationName perPage: nil page: nil
]

{ #category : #'api - repositories' }
GHApi >> reposOfOrganization: anOrganizationName perPage: itemPerPage page: pageNumber [

	self client url:
		self baseAPIUrl , '/orgs/' , anOrganizationName , '/repos'.
	itemPerPage ifNotNil: [
		self client queryAt: #per_page put: itemPerPage ].
	pageNumber ifNotNil: [ self client queryAt: #page put: pageNumber ].
	^ self client get
]

{ #category : #'api - users' }
GHApi >> user: aUserID [
	
	"^ self client get: self baseAPIUrl , '/user/' , aUserID asString"
	
	^ self users getUserId: aUserID 

	
]
