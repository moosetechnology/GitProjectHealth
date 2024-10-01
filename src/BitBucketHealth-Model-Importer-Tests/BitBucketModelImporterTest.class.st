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
BitBucketModelImporterTest >> testGetContributionFromDiffs [
	"Given"

	| bitBucketApi glphModel bitBucketImporter diffs contribution |
	bitBucketApi := BitBucketApiMock new.

	glphModel := GLPHEModel new name: 'test'.

	bitBucketImporter := BitBucketModelImporter new
		                     bitBucketApi: bitBucketApi;
		                     glhModel: glphModel.

	diffs := bitBucketApi diffs.

	"When"
	contribution := bitBucketImporter getContributionFromDiffs: (diffs at: #diffs).

	"Then"
	self assert: (contribution at: #additions) equals: 1.
	self assert: (contribution at: #deletions) equals: 1
]

{ #category : #tests }
BitBucketModelImporterTest >> testGetContributionFromDiffsWithoutAdded [
	"Given"

	| bitBucketApi glphModel bitBucketImporter diffs contribution |
	bitBucketApi := BitBucketApiMock new.

	glphModel := GLPHEModel new name: 'test'.

	bitBucketImporter := BitBucketModelImporter new
		                     bitBucketApi: bitBucketApi;
		                     glhModel: glphModel.

	diffs := bitBucketApi diffsWithoutAdded.
	bitBucketApi diffs: diffs.

	"When"
	contribution := bitBucketImporter getContributionFromDiffs:
		                (diffs at: #diffs).

	"Then"
	self assert: (contribution at: #additions) equals: 0.
	self assert: (contribution at: #deletions) equals: 1
]

{ #category : #tests }
BitBucketModelImporterTest >> testGetContributionFromDiffsWithoutHunks [
	"Given"

	| bitBucketApi glphModel bitBucketImporter diffs contribution |
	bitBucketApi := BitBucketApiMock new.

	glphModel := GLPHEModel new name: 'test'.

	bitBucketImporter := BitBucketModelImporter new
		                     bitBucketApi: bitBucketApi;
		                     glhModel: glphModel.

	diffs := bitBucketApi diffsWithoutHunks.
	bitBucketApi diffs: diffs.

	"When"
	contribution := bitBucketImporter getContributionFromDiffs:
		                (diffs at: #diffs).

	"Then"
	self assert: (contribution at: #additions) equals: 0.
	self assert: (contribution at: #deletions) equals: 0
]

{ #category : #tests }
BitBucketModelImporterTest >> testGetContributionFromDiffsWithoutRemoved [
	"Given"

	| bitBucketApi glphModel bitBucketImporter diffs contribution |
	bitBucketApi := BitBucketApiMock new.

	glphModel := GLPHEModel new name: 'test'.

	bitBucketImporter := BitBucketModelImporter new
		                     bitBucketApi: bitBucketApi;
		                     glhModel: glphModel.

	diffs := bitBucketApi diffsWithoutRemoved.
	bitBucketApi diffs: diffs.

	"When"
	contribution := bitBucketImporter getContributionFromDiffs:
		                (diffs at: #diffs).

	"Then"
	self assert: (contribution at: #additions) equals: 1.
	self assert: (contribution at: #deletions) equals: 0
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

	| bitBucketApi glphModel bitBucketImporter user projects commits yesterdayAsTimestamp |
	bitBucketApi := BitBucketApiMock new.

	glphModel := GLPHEModel new name: 'test'.

	bitBucketImporter := BitBucketModelImporter new
		                     bitBucketApi: bitBucketApi;
		                     glhModel: glphModel.

	user := GLHUser new
		        id: 1;
		        username: 'charlie'.

	commits := bitBucketApi commits1.
	yesterdayAsTimestamp := (Date today - 1 days) asDateAndTime
		                        asUnixTime * 1000.
	commits first at: #committerTimestamp put: yesterdayAsTimestamp.
	bitBucketApi commits: commits.

	"When"
	projects := bitBucketImporter importContributedProjectsOfUser: user.

	"Then"
	self assert: projects size equals: 1.
	self
		assert: (bitBucketImporter glhModel allWithType: GLHProject) size
		equals: 1.
	self
		assert: (bitBucketImporter glhModel allWithType: GLHProject) first
		equals: projects first.
	self
		assertCollection: user contributedProjects
		hasSameElements: projects
]

{ #category : #tests }
BitBucketModelImporterTest >> testImportCreatorOfCommit [

	| bitBucketApi glphModel bitBucketImporter creator commit |
	
	"Given"
	bitBucketApi := BitBucketApiMock new.

	glphModel := GLPHEModel new name: 'test'.

	bitBucketImporter := BitBucketModelImporter new
		                     bitBucketApi: bitBucketApi;
		                     glhModel: glphModel.

	commit := GLHCommit new author_name: 'test'.


	"When"
	creator := bitBucketImporter importCreatorOfCommit: commit.

	"Then"
	self
		assert: creator id
		equals:
		(bitBucketImporter parseUserIntoGLHUser: bitBucketApi userMock) id.
	self assert: commit commitCreator equals: creator
]

{ #category : #tests }
BitBucketModelImporterTest >> testImportCreatorOfCommitIfAlreadyExist [

	| bitBucketApi glphModel bitBucketImporter creator commit |
	"Given"
	bitBucketApi := BitBucketApiMock new.

	glphModel := GLPHEModel new name: 'test'.

	bitBucketImporter := BitBucketModelImporter new
		                     bitBucketApi: bitBucketApi;
		                     glhModel: glphModel.
		
	glphModel add: (bitBucketImporter parseUserIntoGLHUser: bitBucketApi userMock).

	commit := GLHCommit new author_name: 'test'.


	"When"
	creator := bitBucketImporter importCreatorOfCommit: commit.

	"Then"
	self
		assert: creator id
		equals:
		(bitBucketImporter parseUserIntoGLHUser: bitBucketApi userMock) id.
	self assert: commit commitCreator equals: creator
]

{ #category : #tests }
BitBucketModelImporterTest >> testImportMergeRequestsSinceUntil [

	| bitBucketApi glphModel bitBucketImporter group repo project mergeRequests mergeRequest |
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
	mergeRequests := bitBucketImporter
		                 importMergeRequests: project
		                 since: '09-23-2024'
		                 until: '09-25-2024'.

	"Then"
	self
		assert:
		(bitBucketImporter glhModel allWithType: GLPHEMergeRequest) size
		equals: 1.

	self assert: mergeRequests size equals: 1.
	
	mergeRequest := mergeRequests first.
	self assert: mergeRequest state equals: 'opened'.
	self assert: mergeRequest closed_at equals: nil.
]

{ #category : #tests }
BitBucketModelImporterTest >> testImportMergeRequestsSinceUntilClosedMR [

	| bitBucketApi glphModel bitBucketImporter group repo project mergeRequests mergeRequest |
	"Given"
	bitBucketApi := BitBucketApiMock new.

	glphModel := GLPHEModel new name: 'test'.

	bitBucketImporter := BitBucketModelImporter new
		                     bitBucketApi: bitBucketApi;
		                     glhModel: glphModel.

	bitBucketApi mergeRequests: { bitBucketApi mergedMergeRequest }.

	group := GLHGroup new id: 1.
	repo := GLHRepository new.
	project := GLHProject new
		           group: group;
		           repository: repo.

	"When"
	mergeRequests := bitBucketImporter
		                 importMergeRequests: project
		                 since: '09-23-2024'
		                 until: '09-25-2024'.

	"Then"
	self
		assert:
		(bitBucketImporter glhModel allWithType: GLPHEMergeRequest) size
		equals: 1.

	self assert: mergeRequests size equals: 1.

	mergeRequest := mergeRequests first.
	self assert: mergeRequest state equals: 'merged'.
	self assert: mergeRequest closed_at equals: nil.
	self deny: mergeRequest merged_at equals: nil.
]

{ #category : #tests }
BitBucketModelImporterTest >> testImportMergeRequestsSinceUntilDeclinedMR [

	| bitBucketApi glphModel bitBucketImporter group repo project mergeRequests mergeRequest |
	"Given"
	bitBucketApi := BitBucketApiMock new.

	glphModel := GLPHEModel new name: 'test'.

	bitBucketImporter := BitBucketModelImporter new
		                     bitBucketApi: bitBucketApi;
		                     glhModel: glphModel.

	bitBucketApi mergeRequests: { bitBucketApi declinedMergeRequest }.

	group := GLHGroup new id: 1.
	repo := GLHRepository new.
	project := GLHProject new
		           group: group;
		           repository: repo.

	"When"
	mergeRequests := bitBucketImporter
		                 importMergeRequests: project
		                 since: '09-23-2024'
		                 until: '09-25-2024'.

	"Then"
	self
		assert:
		(bitBucketImporter glhModel allWithType: GLPHEMergeRequest) size
		equals: 1.

	self assert: mergeRequests size equals: 1.

	mergeRequest := mergeRequests first.
	self assert: mergeRequest state equals: 'closed'.
	self deny: mergeRequest closed_at equals: nil.
	self assert: mergeRequest merged_at equals: nil
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

{ #category : #tests }
BitBucketModelImporterTest >> testImportUserByUsername [
	"Given"

	| bitBucketApi glphModel bitBucketImporter user |
	bitBucketApi := BitBucketApiMock new.

	glphModel := GLPHEModel new name: 'test'.

	bitBucketImporter := BitBucketModelImporter new
		                     bitBucketApi: bitBucketApi;
		                     glhModel: glphModel.
		
	"When"
	user := bitBucketImporter importUserByUsername: 'test'.
	
   "Then"
	self assert: (glphModel allWithType: GLHUser) size equals: 1.
	self
		assertCollection: (glphModel allWithType: GLHUser)
		hasSameElements: {user}.
]

{ #category : #tests }
BitBucketModelImporterTest >> testImportUserByUsernameWithoutUsers [
	"Given"

	| bitBucketApi glphModel bitBucketImporter user |
	bitBucketApi := BitBucketApiMock new.

	glphModel := GLPHEModel new name: 'test'.

	bitBucketImporter := BitBucketModelImporter new
		                     bitBucketApi: bitBucketApi;
		                     glhModel: glphModel.
		
	bitBucketApi userMock: nil.

	"When"
	user := bitBucketImporter importUserByUsername: 'test'.

	"Then"
	self assert: (glphModel allWithType: GLHUser) size equals: 0.
	self assert: user equals: nil
]
