Class {
	#name : #GLPHApi,
	#superclass : #GLHApi,
	#category : #'GitLabProjectHealth-Model-Importer'
}

{ #category : #'as yet unclassified' }
GLPHApi >> diffsMergeRequestOfProject: aProjectID withId: anMRiid [

	^ self client get:
		  self baseAPIUrl , '/projects/' , aProjectID printString
		  , '/merge_requests/' , anMRiid printString , '/diffs/'
]

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

{ #category : #'as yet unclassified' }
GLPHApi >> mergeRequestOfProject: aProjectID withId: anMRiid [

	^ self client get:
		  self baseAPIUrl , '/projects/' , aProjectID printString
		  , '/merge_requests/' , anMRiid printString
]

{ #category : #accessing }
GLPHApi >> project: aProjectID [

	^ self client get:
		  self baseAPIUrl , '/projects/' , aProjectID printString
]
