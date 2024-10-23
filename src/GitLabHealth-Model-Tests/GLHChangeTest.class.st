"
A GLHChangeTest is a test class for testing the behavior of GLHChange
"
Class {
	#name : 'GLHChangeTest',
	#superclass : 'TestCase',
	#category : 'GitLabHealth-Model-Tests-Entities',
	#package : 'GitLabHealth-Model-Tests',
	#tag : 'Entities'
}

{ #category : 'tests' }
GLHChangeTest >> testNewEntityFromString [

	| change |
	change := GLHChange newFrom: '+ helloWorld'.
	self assert: change class equals: GLPHEAddition.
	self assert: change sourceCode equals: '+ helloWorld'
]

{ #category : 'tests' }
GLHChangeTest >> testNewEntityFromStringDeletion [

	| change |
	change := GLPHEChange newFrom: '- helloWorld'.
	self assert: change class equals: GLPHEDeletion.
	self assert: change sourceCode equals: '- helloWorld'
]

{ #category : 'tests' }
GLHChangeTest >> testNewEntityFromStringLOC [

	| change |
	change := GLPHEChange newFrom: 'helloWorld'.
	self assert: change class equals: GLPHELineOfCode.
	self assert: change sourceCode equals: 'helloWorld'
]
