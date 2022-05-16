"
You can use me to extract query GitHub
"
Class {
	#name : #GHApi,
	#superclass : #Object,
	#instVars : [
		'baseAPIUrl',
		'privateToken',
		'client'
	],
	#category : #'BL-GitHubHealth-Model-Importer'
}

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

{ #category : #accessing }
GHApi >> initialize [

	self baseAPIUrl: 'https://api.github.com'.
	self client: (ZnClient new
			 accept: ZnMimeType applicationJson;
			 yourself)
]

{ #category : #accessing }
GHApi >> organization: anOrganizationName [

	^ self client get: self baseAPIUrl , '/orgs/' , anOrganizationName
]
