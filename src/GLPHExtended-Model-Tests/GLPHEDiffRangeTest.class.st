"
A GLPHEDiffRangeTest is a test class for testing the behavior of GLPHEDiffRange
"
Class {
	#name : #GLPHEDiffRangeTest,
	#superclass : #TestCase,
	#category : 'GLPHExtended-Model-Tests-Entities'
}

{ #category : #tests }
GLPHEDiffRangeTest >> testNewEntityFromString [

	| diffRange |
	diffRange := GLPHEDiffRange newFrom:
		             '@@ -15,9 +15,9 @@ LLMModifierTest >> testGetViolationsMessage ['.
	self assert: diffRange originalLineRange equals: '-15,9'.
	self assert: diffRange newLineRange equals: '+15,9'
]

{ #category : #tests }
GLPHEDiffRangeTest >> testNewEntityFromStringWithDifferentValues [

	| diffRange |
	diffRange := GLPHEDiffRange newFrom:
		             '@@ -15,7 +15,8 @@ LLMModifier >> getViolationsMessage: violations ['.
	self assert: diffRange originalLineRange equals: '-15,7'.
	self assert: diffRange newLineRange equals: '+15,8'
]
