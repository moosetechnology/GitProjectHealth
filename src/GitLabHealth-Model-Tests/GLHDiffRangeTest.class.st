"
A GLHDiffRangeTest is a test class for testing the behavior of GLHDiffRange
"
Class {
	#name : 'GLHDiffRangeTest',
	#superclass : 'TestCase',
	#category : 'GitLabHealth-Model-Tests-Entities',
	#package : 'GitLabHealth-Model-Tests',
	#tag : 'Entities'
}

{ #category : 'tests' }
GLHDiffRangeTest >> testNewEntityFromString [

	| diffRange |
	diffRange := GLPHEDiffRange newFrom:
		             '@@ -15,9 +15,9 @@ LLMModifierTest >> testGetViolationsMessage ['.
	self assert: diffRange originalLineRange equals: '-15,9'.
	self assert: diffRange newLineRange equals: '+15,9'
]

{ #category : 'tests' }
GLHDiffRangeTest >> testNewEntityFromStringWithDifferentValues [

	| diffRange |
	diffRange := GLPHEDiffRange newFrom:
		             '@@ -15,7 +15,8 @@ LLMModifier >> getViolationsMessage: violations ['.
	self assert: diffRange originalLineRange equals: '-15,7'.
	self assert: diffRange newLineRange equals: '+15,8'
]
