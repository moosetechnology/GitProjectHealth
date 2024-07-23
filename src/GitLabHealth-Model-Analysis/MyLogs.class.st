Class {
	#name : #MyLogs,
	#superclass : #Object,
	#classVars : [
		'i',
		'size'
	],
	#category : #'GitLabHealth-Model-Analysis'
}

{ #category : #accessing }
MyLogs class >> i [
	^ i 
]

{ #category : #accessing }
MyLogs class >> increment [

	^ i := i + 1
]

{ #category : #progress }
MyLogs class >> logProgress: aString over: aCollection [

	('' join: {
			 aString.
			 ' '.
			 self increment printString.
			 '/'.
			 aCollection size }) recordInfo.
	i >= aCollection size ifTrue: [ self reset ]
]

{ #category : #'instance creation' }
MyLogs class >> newLogNamed: aName [

	self reset. 
	TinyLogger default addFileLoggerNamed:
		'gitlabhealth-' , aName , '.log'
	
]

{ #category : #initialization }
MyLogs class >> reset [
	i := 0.
	size  := 0. 
]
