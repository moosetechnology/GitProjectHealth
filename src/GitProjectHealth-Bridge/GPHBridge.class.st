Class {
	#name : #GPHBridge,
	#superclass : #GitBridge,
	#category : #'GitProjectHealth-Bridge'
}

{ #category : #'class initialization' }
GPHBridge class >> initialize [

	SessionManager default registerSystemClassNamed: self name
]

{ #category : #'class initialization' }
GPHBridge class >> resources [
	^ self root / 'res'
]

{ #category : #'class initialization' }
GPHBridge class >> testResources [

	^ self resources / 'testResource'
]

{ #category : #'class initialization' }
GPHBridge class >> testResourcesZip [

	^ self resources / 'testResource.zip'
]
