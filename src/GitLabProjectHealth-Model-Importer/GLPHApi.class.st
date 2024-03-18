Class {
	#name : #GLPHApi,
	#superclass : #GLHApi,
	#category : #'GitLabProjectHealth-Model-Importer'
}

{ #category : #initialization }
GLPHApi >> initialize [

	super initialize
]

{ #category : #'as yet unclassified' }
GLPHApi >> mergeRequestOfProject: aProjectID [
	
	^ self client get:
		  self baseAPIUrl , '/projects/' , aProjectID printString
		  , '/merge_requests/'
]

{ #category : #accessing }
GLPHApi >> privateToken [

	^ self client request headers at: #'PRIVATE-TOKEN'
]

{ #category : #accessing }
GLPHApi >> privateToken: anObject [

	self client headerAt: #'PRIVATE-TOKEN' add: anObject
]
