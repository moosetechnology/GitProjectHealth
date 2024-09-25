"
A BitBucketModelImporterTest is a test class for testing the behavior of BitBucketModelImporter
"
Class {
	#name : #BitBucketModelImporterTest,
	#superclass : #TestCase,
	#category : #'BitBucketHealth-Model-Importer-Tests'
}

{ #category : #tests }
BitBucketModelImporterTest >> testImportContributedProjectsOfUser [

	| bitBucketApi glphModel bitBucketImporter user projects |
	bitBucketApi := BitBucketApiMock new.

	glphModel := GLPHEModel new name: 'test'.

	bitBucketImporter := BitBucketModelImporter new
		                     bitBucketApi: bitBucketApi;
		                     glhModel: glphModel.

	user := GLHUser new
		        id: 1;
		        name: 'charlie'.

	"When"
	projects := bitBucketImporter importContributedProjectsOfUser: user.

	"Then"
	self assert: projects size equals: 1.
	self assert: (bitBucketImporter glhModel allWithType: GLHProject) size equals: 1.
	self assert: (bitBucketImporter glhModel allWithType: GLHProject) first equals: projects first
]
