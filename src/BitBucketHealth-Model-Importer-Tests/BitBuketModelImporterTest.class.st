"
A BitBuketModelImporterTest is a test class for testing the behavior of BitBuketModelImporter
"
Class {
	#name : #BitBuketModelImporterTest,
	#superclass : #TestCase,
	#category : #'BitBucketHealth-Model-Importer-Tests'
}

{ #category : #tests }
BitBuketModelImporterTest >> testImportUser [
	"Given"

	| bitBucketApi glphModel bitBucketImporter user modelUser |
	bitBucketApi := BitBucketApiMock new.

	glphModel := GLPHEModel new name: 'test'.

	bitBucketImporter := BitBucketModelImporter new
		                     bitBucketApi: bitBucketApi;
		                     glhModel: glphModel.

	"When"
	user := bitBucketImporter importUser: 1.

	"Then"
	self
		assert: (bitBucketImporter glhModel allWithType: GLHUser) size
		equals: 1.

	modelUser := (bitBucketImporter glhModel allWithType: GLHUser) first.
	self assert: user equals: modelUser.
]
