"
A BitBucketModelImporterTest is a test class for testing the behavior of BitBucketModelImporter
"
Class {
	#name : #BitBucketModelImporterTest,
	#superclass : #TestCase,
	#category : #'BitBucketHealth-Model-Importer-Tests'
}

{ #category : #tests }
BitBucketModelImporterTest >> testCompleteImportProject [
	"Given"

	| glphModel project bitBucketApi bitBucketImporter |
		bitBucketApi := BitBucketApiMock new.
	glphModel := GLPHEModel new name: 'test'.

	project := GLHProject new.

	glphModel add: project.

	bitBucketImporter := BitBucketModelImporter new
		                     bitBucketApi: bitBucketApi;
		                     glhModel: glphModel.

	"When"
	project := bitBucketImporter completeImportProject: project.

	"Then"
	self deny: project repository equals: nil.
	self
		assert: (bitBucketImporter glhModel allWithType: GLHRepository) size
		equals: 1
]

{ #category : #tests }
BitBucketModelImporterTest >> testImportCommitsOfProjectSinceUntil [

	| bitBucketApi glphModel bitBucketImporter project commits group repo |
	"Given"
	bitBucketApi := BitBucketApiMock new.

	glphModel := GLPHEModel new name: 'test'.

	bitBucketImporter := BitBucketModelImporter new
		                     bitBucketApi: bitBucketApi;
		                     glhModel: glphModel.

	group := GLHGroup new id: 1.
	repo := GLHRepository new.
	project := GLHProject new
		           group: group;
		           repository: repo.

	"When"
	commits := bitBucketImporter
		           importCommitsOfProject: project
		           since: '09-23-2024'
		           until: '09-25-2024'.

	"Then"
	self
		assert: (bitBucketImporter glhModel allWithType: GLHCommit) size
		equals: 1.
		
  self assert: project repository commits size equals: 1. 
]

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

{ #category : #tests }
BitBucketModelImporterTest >> testImportUser [
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
	self assert: user equals: modelUser
]
