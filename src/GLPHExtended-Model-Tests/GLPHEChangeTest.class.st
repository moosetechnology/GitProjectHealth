"
A GLPHEChangeTest is a test class for testing the behavior of GLPHEChange
"
Class {
	#name : #GLPHEChangeTest,
	#superclass : #TestCase,
	#category : #'GLPHExtended-Model-Tests-Entities'
}

{ #category : #tests }
GLPHEChangeTest >> testNewEntityFromString [

	| change |
	change := GLPHEChange newFrom: '+ helloWorld'.
	self assert: change class equals: GLPHEAddition.
	self assert: change sourceCode equals: '+ helloWorld'
]

{ #category : #tests }
GLPHEChangeTest >> testNewEntityFromStringDeletion [

	| change |
	change := GLPHEChange newFrom: '- helloWorld'.
	self assert: change class equals: GLPHEDeletion.
	self assert: change sourceCode equals: '- helloWorld'
]

{ #category : #tests }
GLPHEChangeTest >> testNewEntityFromStringLOC [

	| change |
	change := GLPHEChange newFrom: 'helloWorld'.
	self assert: change class equals: GLPHELineOfCode.
	self assert: change sourceCode equals: 'helloWorld'
]
