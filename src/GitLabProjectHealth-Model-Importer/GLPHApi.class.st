Class {
	#name : #GLPHApi,
	#superclass : #GLHApi,
	#category : #'GitLabProjectHealth-Model-Importer'
}

{ #category : #initialization }
GLPHApi >> initialize [

	super initialize
]

{ #category : #accessing }
GLPHApi >> project: aProjectID [

	^ self client get:
		  self baseAPIUrl , '/projects/' , aProjectID printString
]

{ #category : #user }
GLPHApi >> usersSearchByUsername: aUserName [ 
	|name|
	
	name := (aUserName splitOn: ' ') collect: [:part | part urlEncoded].
	name := '+' join: name.
	
	^ self client get: self baseAPIUrl , '/users?search=' , name 
]
