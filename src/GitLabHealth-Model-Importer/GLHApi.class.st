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
	#classVars : [
		'currentAPI'
	],
	#category : #'GitLabHealth-Model-Importer'
}

{ #category : #accessing }
GLHApi class >> current [

	^ currentAPI
]

{ #category : #accessing }
GLHApi >> baseAPIUrl [

	^ baseAPIUrl
]

{ #category : #accessing }
GLHApi >> baseAPIUrl: anObject [

	baseAPIUrl := anObject
]

{ #category : #accessing }
GLHApi >> client [

	^ client
]

{ #category : #accessing }
GLHApi >> client: anObject [

	client := anObject
]

{ #category : #projects }
GLHApi >> importProjects: first after: after [ 
	 | request query variables body response |

		

        query := 'query getAllProjects($first: Int!, $after: String) {
            projects(first: $first, after: $after) {
                pageInfo {
                    endCursor
                    hasNextPage
                }
                edges {
                    node {
                        id
                    }
                }
            }
        }'.

        variables := String streamContents: [ :stream |
            stream nextPutAll: '{'.
            stream
                nextPutAll: '"first": ', first printString, ',';
                nextPutAll: '"after": "', after, '"'.
            stream nextPutAll: '}'
        ].

        body := String streamContents: [ :stream |
            stream nextPutAll: '{'.
            stream
                nextPutAll: '"query": "', (' ' join: query lines) , '",';
                nextPutAll: '"variables": ', variables.
            stream nextPutAll: '}'
        ].

       response := client entity: (ZnEntity with: body); contentType: 'application/json'; 
            url: (self baseAPIUrl replaceSuffix: 'v4' with: 'graphql'); post.
        
        ^ response contents
]

{ #category : #initialization }
GLHApi >> initialize [

	self client: (ZnClient new
			 accept: ZnMimeType applicationJson;
			 yourself).

]

{ #category : #'as yet unclassified' }
GLHApi >> makeGlobal [ 
		currentAPI := self
]

{ #category : #accessing }
GLHApi >> privateToken [

	^ self client request headers at: #'PRIVATE-TOKEN'
]

{ #category : #accessing }
GLHApi >> privateToken: anObject [

	self client headerAt: #'PRIVATE-TOKEN' add: anObject
]

{ #category : #accessing }
GLHApi >> projects [
	"use GraphQL"
	
	 | projectIds after hasNextPage response data edges pageInfo jsonParser |

        projectIds := Set new.
        after := ''.
        hasNextPage := true.
       " jsonParser := NeoJSONArray readFromString: self class."

        [ hasNextPage ] whileTrue: [
	
            response := self importProjects: 10 after: after.
            data := NeoJSONReader fromString: response.
            edges := (data at: 'data') at: 'projects' at: 'edges'.
            pageInfo := (data at: 'data') at: 'projects' at: 'pageInfo'.

            edges do: [:edge | |id| 
						id := (edge at: 'node' at: 'id'). 
						 projectIds add: id ].

            after := pageInfo at: 'endCursor'.
            hasNextPage := pageInfo at: 'hasNextPage'.
        ].

        ^ projectIds
]

{ #category : #private }
GLHApi >> resetClient [

	| token |
	token := self privateToken.
	self client initialize.
	self privateToken: token.
	self client accept: ZnMimeType applicationJson
]
