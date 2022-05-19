"
You can use me to extract query GitHub
"
Class {
	#name : #GHApi,
	#superclass : #Object,
	#instVars : [
		'baseAPIUrl',
		'client'
	],
	#category : #'BL-GitHubHealth-Model-Importer'
}

{ #category : #api }
GHApi >> actionsRunOfRepo: aRepoName ofOrganization: anOrganizationName [

	^ self client get:
		  self baseAPIUrl , '/repos/' , anOrganizationName , '/' , aRepoName
		  , '/actions/runs'
]

{ #category : #accessing }
GHApi >> baseAPIUrl [

	^ baseAPIUrl
]

{ #category : #accessing }
GHApi >> baseAPIUrl: anObject [

	baseAPIUrl := anObject
]

{ #category : #accessing }
GHApi >> client [

	^ client
]

{ #category : #accessing }
GHApi >> client: anObject [

	client := anObject
]

{ #category : #initialization }
GHApi >> initialize [

	self baseAPIUrl: 'https://api.github.com'.
	self client: (ZnClient new
			 accept: ZnMimeType applicationJson;
			 yourself)
]

{ #category : #api }
GHApi >> organization: anOrganizationName [

	^ self client get: self baseAPIUrl , '/orgs/' , anOrganizationName
]

{ #category : #accessing }
GHApi >> privateToken [

		^ self client request headers at: #'Authorization'
]

{ #category : #accessing }
GHApi >> privateToken: anObject [

	self client headerAt: #'Authorization' add: ('token ', anObject)
]

{ #category : #api }
GHApi >> reposOfOrganization: anOrganizationName [

	^ self client get: self baseAPIUrl , '/orgs/' , anOrganizationName, '/repos'
]
