"
A GitModelImporterTest is a test class for testing the behavior of GitModelImporter
"
Class {
	#name : #GitModelImporterTest,
	#superclass : #TestCase,
	#instVars : [
		'model',
		'importer'
	],
	#category : #'GitProjectHealth-Model-Importer-Tests'
}

{ #category : #tests }
GitModelImporterTest >> setUp [

	super setUp.
	model := GLHModel new.
	importer := GitModelImporter new.
	importer glhModel: model.
	importer withCommitDiffs: true
]

{ #category : #tests }
GitModelImporterTest >> testFilterCommitChanges [

	| string |
	string := '--- hello
	world
	+++ how
	\ No newline at end of file
	you' lines.
	self assert: (importer filterCommitChanges: string) equals: '	world
	you' lines
]

{ #category : #tests }
GitModelImporterTest >> testParseDiffString [

	"Given"
	| diff diffRange |
	diff := GLHDiff new.
	
	diff diffString: '--- a/etc/name.properties
+++ b/etc/new-name.properties'.

	"When"
	diffRange := importer parseDiffString: diff.
	
	"Then"
	self assert: diffRange equals: diff diffRanges.
]

{ #category : #tests }
GitModelImporterTest >> testParseDiffStringComplete [

	| diff diffRange |
	diff := GLHDiff new.
	diff new_path: 'new/test/path.txt'.
	model add: diff.
	diff diffString:
		'@@ -15,9 +15,9 @@ LLMModifierTest >> testGetViolationsMessage [
 	message1 := ''message1''.
 	message2 := ''message2''.
 
-	violations := OrderedCollection new.
+	violations := MooseSpecializedGroup new.
 	violations add: (Violation new message: message1).
-	
+
 	violations add: (Violation new message: message2).
 	violations add: (Violation new message: message2).'.
	importer parseDiffString: diff.
	self assert: diff diffRanges size equals: 1.
	diffRange := diff diffRanges anyOne.
	self assert: diffRange changes size equals: 9.
	self
		assert:
		(diffRange changes asMooseGroup allWithType: GLHDeletion) size
		equals: 2.
	self
		assert:
		(diffRange changes asMooseGroup allWithType: GLHAddition) size
		equals: 2
]

{ #category : #tests }
GitModelImporterTest >> testParseEmptyDiffString [
	"Given"

	| diff diffRange |
	diff := GLHDiff new.

	diff diffString: ''.

	"When"
	diffRange := importer parseDiffString: diff.

	"Then"
	self assert: diffRange isEmpty
]
