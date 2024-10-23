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
	self assert: change class equals: GLHAddition.
	self assert: change sourceCode equals: '+ helloWorld'
]

{ #category : 'tests' }
GLHChangeTest >> testNewEntityFromStringDeletion [

	| change |
	change := GLHChange newFrom: '- helloWorld'.
	self assert: change class equals: GLHDeletion.
	self assert: change sourceCode equals: '- helloWorld'
]

{ #category : 'tests' }
GLHChangeTest >> testNewEntityFromStringLOC [

	| change |
	change := GLHChange newFrom: 'helloWorld'.
	self assert: change class equals: GLHLineOfCode.
	self assert: change sourceCode equals: 'helloWorld'
]
