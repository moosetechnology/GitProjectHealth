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

"	^ self client get:
		  self baseAPIUrl , '/repos/' , anOrganizationName , '/' , aRepoName
		  , '/actions/runs'"
		
	self
		deprecated: 'Use self actions getLatestForRepo:ofOwner: instead of current one'
		on: '21 august 2025'
		in:
		'Pharo-12.0.0+SNAPSHOT.build.1571.sha.cf5fcd22e66957962c97dffc58b0393b7f368147 (64 Bit)'.
		
	^ self actions getLatestForRepo: aRepoName  ofOwner: anOrganizationName. 
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

"	self client url:
		self baseAPIUrl , '/repos/' , anOrganizationName , '/' , aRepoName
		, '/branches'.
	^ self client get"
	
	self
		deprecated: 'Use self branches getAllForRepo:ofOwner: instead of current one'
		on: '31 July 2025'
		in:
		'Pharo-12.0.0+SNAPSHOT.build.1571.sha.cf5fcd22e66957962c97dffc58b0393b7f368147 (64 Bit)'.
	
	^ self branches getLatestForRepo: aRepoName ofOwner: anOrganizationName .
]

{ #category : #'api - commits' }
GHApi >> commit: commitSHA ofOrganisation: anOrganisation ofProject: aProjectId [

"	self client path: (String streamContents: [ :str |
			 str
				 << self baseAPIUrl;
				 << '/repos/';
				 << anOrganisation asString;
				 << '/';
				 << aProjectId asString;
				 << '/commits/';
				 << commitSHA asString ]).


	('Call: ' , self client request url asString) recordInfo.

	^ (NeoJSONReader on: (self client get) readStream) next"
	
	
	self
		deprecated: 'Use self commits getCommit:ForRepo:ofOwner: instead of current one'
		on: '31 July 2025'
		in:
		'Pharo-12.0.0+SNAPSHOT.build.1571.sha.cf5fcd22e66957962c97dffc58b0393b7f368147 (64 Bit)'.
	
	^ NeoJSONReader fromString: (self commits getCommit: commitSHA ForRepo: aProjectId asString ofOwner: anOrganisation asString)
]

{ #category : #'api - commits' }
GHApi >> commitDiff: commitSHA ofProject: aProjectId unidiff: unidiff [ 
	
	self
		deprecated: 'Use self commits getCommit:ForRepo:ofOwner: instead of current one'
		on: '31 July 2025'
		in:
		'Pharo-12.0.0+SNAPSHOT.build.1571.sha.cf5fcd22e66957962c97dffc58b0393b7f368147 (64 Bit)'.
	
	
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

"	^ self
		  commitsOfProject: aProjectId
		  ofOrganization: organisationName
		  since: nil
		  perPage: nil
		  page: nil"
		
		self
		deprecated: 'Use self commits getLatestForRepo:ofOwner: instead of current one'
		on: '31 July 2025'
		in:
		'Pharo-12.0.0+SNAPSHOT.build.1571.sha.cf5fcd22e66957962c97dffc58b0393b7f368147 (64 Bit)'.
		
		^ self commits getLatestForRepo: aProjectId ofOwner: organisationName.
]

{ #category : #'api - commits' }
GHApi >> commitsOfProject: aProjectId ofOrganization: organisationName since: aSinceDate perPage: itemPerPage page: pageNumber [

	|parms|

"	self client url:
		self baseAPIUrl , '/repos/' , organisationName , '/' , aProjectId
		, '/commits'.
	aSinceDate ifNotNil: [ self client queryAt: #since put: aSinceDate ].
	itemPerPage ifNotNil: [
		self client queryAt: #per_page put: itemPerPage ].
	pageNumber ifNotNil: [ self client queryAt: #page put: pageNumber ].
	^ self client get"
	
		self
		deprecated: 'Use self commits getForRepo:ofOwner:withParms: instead of current one'
		on: '31 July 2025'
		in:
		'Pharo-12.0.0+SNAPSHOT.build.1571.sha.cf5fcd22e66957962c97dffc58b0393b7f368147 (64 Bit)'.
	
	parms := Dictionary new. 
		aSinceDate ifNotNil: [ parms at: #since put: aSinceDate ].
	itemPerPage ifNotNil: [
		parms at: #per_page put: itemPerPage ].
	pageNumber ifNotNil: [ parms at: #page put: pageNumber ].
	
	^ self commits getForRepo: aProjectId ofOwner: organisationName withParms: parms. 
]

{ #category : #api }
GHApi >> contentsOfRepo: aRepoName ofOrganization: anOrganizationName inBranch: aBranchRef withPath: aPath [

	"self client url:
		self baseAPIUrl , '/repos/' , anOrganizationName , '/' , aRepoName
		, '/contents/' , (aPath ifNil: [ '' ]).
	aBranchRef ifNotNil: [ self client queryAt: #ref put: aBranchRef ].
	^ self client get"
	
	self
		deprecated: 'Use self contents getContent:forRepo:ofOwner:onBranchRef: instead of current one'
		on: '31 July 2025'
		in:
		'Pharo-12.0.0+SNAPSHOT.build.1571.sha.cf5fcd22e66957962c97dffc58b0393b7f368147 (64 Bit)'.
	
	^ self contents getContent:  aPath forRepo: aRepoName ofOwner: anOrganizationName onBranchRef: aBranchRef.
]

{ #category : #'merge request' }
GHApi >> mergeRequestsOfRepo: anOrganisation ofProject: aRepo [

	"self
		  mergeRequestsOfRepo: anOrganisation
		  ofProject: aRepo
		  state: 'all'
		  head: nil
		  base: nil
		  sort: nil
		  direction: nil
		  per_page: nil
		  page: nil.
"
	self
		deprecated: 'Use self pullRequests getLatestForRepo:ofOwner: instead of current one'
		on: '31 July 2025'
		in:
		'Pharo-12.0.0+SNAPSHOT.build.1571.sha.cf5fcd22e66957962c97dffc58b0393b7f368147 (64 Bit)'.
	
	
	
	^ self pullRequests getLatestForRepo: aRepo ofOwner: anOrganisation.
	
]

{ #category : #'merge request' }
GHApi >> mergeRequestsOfRepo: organisationName ofProject: projectName state: state head: head base: base sort: sort direction: direction per_page: per_page page: page [ 

	|parms|
	self
		deprecated: 'Use self pullRequests getForRepo:ofOwner:withParms: instead of current one'
		on: '31 July 2025'
		in:
		'Pharo-12.0.0+SNAPSHOT.build.1571.sha.cf5fcd22e66957962c97dffc58b0393b7f368147 (64 Bit)'.
		

	
	"self client url:
		self baseAPIUrl , '/repos/' , organisationName , '/' , projectName
		, '/pulls'.
		
	state ifNotNil: [ self client queryAt: #state put: state ].
	head ifNotNil: [ self client queryAt: #head put: head ].
	base ifNotNil: [ self client queryAt: #base put: base ].
	sort ifNotNil: [ self client queryAt: #sort put: sort ].	
	direction ifNotNil: [ self client queryAt: #direction put: direction ].
	per_page ifNotNil: [ self client queryAt: #per_page put: per_page ].
	page ifNotNil: [ self client queryAt: #page put: page ].
	
	('Call: ' , self client request url asString) recordInfo.
	
	
	(NeoJSONReader on: self client get readStream) next."
	
	parms := Dictionary new. 
	state ifNotNil: [ parms at: #state put: state ].
	head ifNotNil: [ parms at: #head put: head ].
	base ifNotNil: [ parms at: #base put: base ].
	sort ifNotNil: [ parms at: #sort put: sort ].	
	direction ifNotNil: [ parms at: #direction put: direction ].
	per_page ifNotNil: [ parms at: #per_page put: per_page ].
	page ifNotNil: [ parms at: #page put: page ].
	

 ^	NeoJSONReader fromString: (self pullRequests getForRepo: projectName ofOwner: organisationName withParms: parms)
	
	
]

{ #category : #api }
GHApi >> organization: anOrganizationName [

"	^ self client get: self baseAPIUrl , '/orgs/' , anOrganizationName"
		self
		deprecated: 'Use self organizations get: instead of current one'
		on: '31 July 2025'
		in:
		'Pharo-12.0.0+SNAPSHOT.build.1571.sha.cf5fcd22e66957962c97dffc58b0393b7f368147 (64 Bit)'.
	
	^ self organizations get: anOrganizationName.
]

{ #category : #api }
GHApi >> organization: anOrganisationOrOwner repo: aRepoName [

	"^ self client get:
		  self baseAPIUrl , '/repos/' , aGroupName , '/' , aRepoName"
		
	self
		deprecated: 'Use self organizations getRepository:OfOrganization: instead of current one'
		on: '31 July 2025'
		in:
		'Pharo-12.0.0+SNAPSHOT.build.1571.sha.cf5fcd22e66957962c97dffc58b0393b7f368147 (64 Bit)'.
		
	self organizations getRepository: aRepoName ofOrganization: anOrganisationOrOwner.
]

{ #category : #'api - repositories' }
GHApi >> reposOfOrganization: anOrganizationName [

	"^ self reposOfOrganization: anOrganizationName perPage: nil page: nil"
	
	self
		deprecated: 'Use self organizations getRepositoriesOfOrganization: instead of current one'
		on: '31 July 2025'
		in:
		'Pharo-12.0.0+SNAPSHOT.build.1571.sha.cf5fcd22e66957962c97dffc58b0393b7f368147 (64 Bit)'.
	
	self organizations getRepositoriesOfOrganization: anOrganizationName. 
]

{ #category : #'api - repositories' }
GHApi >> reposOfOrganization: anOrganizationName perPage: itemPerPage page: pageNumber [

"	self client url:
		self baseAPIUrl , '/orgs/' , anOrganizationName , '/repos'.
	itemPerPage ifNotNil: [
		self client queryAt: #per_page put: itemPerPage ].
	pageNumber ifNotNil: [ self client queryAt: #page put: pageNumber ].
	^ self client get"
	
	
	self
		deprecated: 'Use self organizations getRepositoriesOfOrganization:perPage:page: instead of current one'
		on: '31 July 2025'
		in:
		'Pharo-12.0.0+SNAPSHOT.build.1571.sha.cf5fcd22e66957962c97dffc58b0393b7f368147 (64 Bit)'.
	
	^ self organizations getRepositoriesOfOrganization: anOrganizationName perPage: itemPerPage page: pageNumber.
]

{ #category : #'api - users' }
GHApi >> user: aUserID [
	
	"^ self client get: self baseAPIUrl , '/user/' , aUserID asString"
	
	self
		deprecated: 'Use self users getUserId: instead of current one'
		on: '31 July 2025'
		in:
		'Pharo-12.0.0+SNAPSHOT.build.1571.sha.cf5fcd22e66957962c97dffc58b0393b7f368147 (64 Bit)'.
	
	^ self users getUserId: aUserID 

	
]
