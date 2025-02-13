"
A GPModelImporterTest is a test class for testing the behavior of GPModelImporter
"
Class {
	#name : #GPModelImporterTest,
	#superclass : #TestCase,
	#category : #'GitProjectHealth-Model-Importer-Tests'
}

{ #category : #tests }
GPModelImporterTest >> testParseDiffString [

	"Given"
	| diff diffRange |
	diff := GLHDiff new.
	
	diff diffString: '--- a/etc/name.properties
+++ b/etc/new-name.properties'.

	"When"
	diffRange := GitModelImporter new parseDiffString: diff.
	
	"Then"
	self assert: diffRange equals: diff diffRanges.
]
