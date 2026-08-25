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
GPHBridge class >> testRessource [

	^ self root / 'res'
]
