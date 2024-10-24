"
A BitBucketModelImporterTest is a test class for testing the behavior of BitBucketModelImporter
"
Class {
	#name : 'BitBucketModelImporterTest',
	#superclass : 'TestCase',
	#category : 'BitBucketHealth-Model-Importer-Tests',
	#package : 'BitBucketHealth-Model-Importer-Tests'
}

{ #category : 'tests' }
BitBucketModelImporterTest >> testCompleteImportProject [
	"Given"

	| glphModel project bitBucketApi bitBucketImporter |
		bitBucketApi := BitBucketApiMock new.
	glphModel := GLHModel new name: 'test'.

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

{ #category : 'tests' }
BitBucketModelImporterTest >> testGetContributionFromDiffs [
	"Given"

	| bitBucketApi glphModel bitBucketImporter diffs contribution |
	bitBucketApi := BitBucketApiMock new.

	glphModel := GLHModel new name: 'test'.

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

{ #category : 'tests' }
BitBucketModelImporterTest >> testGetContributionFromDiffsWithoutAdded [
	"Given"

	| bitBucketApi glphModel bitBucketImporter diffs contribution |
	bitBucketApi := BitBucketApiMock new.

	glphModel := GLHModel new name: 'test'.

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

{ #category : 'tests' }
BitBucketModelImporterTest >> testGetContributionFromDiffsWithoutHunks [
	"Given"

	| bitBucketApi glphModel bitBucketImporter diffs contribution |
	bitBucketApi := BitBucketApiMock new.

	glphModel := GLHModel new name: 'test'.

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

{ #category : 'tests' }
BitBucketModelImporterTest >> testGetContributionFromDiffsWithoutRemoved [
	"Given"

	| bitBucketApi glphModel bitBucketImporter diffs contribution |
	bitBucketApi := BitBucketApiMock new.

	glphModel := GLHModel new name: 'test'.

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

{ #category : 'tests' }
BitBucketModelImporterTest >> testImportAndLoadLatestsCommitsOfProject [

	| bitBucketApi glphModel bitBucketImporter project commits group repo firstCommit commit1 currentDate timestamp commit2 timestamp2 |
	"Given"
	bitBucketApi := BitBucketApiMock new.

	glphModel := GLHModel new name: 'test'.

	bitBucketImporter := BitBucketModelImporter new
		                     bitBucketApi: bitBucketApi;
		                     glhModel: glphModel;
		                     withCommitDiffs: true.

	group := GLHGroup new id: 1.
	repo := GLHRepository new.
	project := GLHProject new
		           group: group;
		           repository: repo.

	commit1 := bitBucketApi commits1 first.
	currentDate := DateAndTime today.
	timestamp := (currentDate - 1 weeks) asUnixTime * 1000.
	commit1 at: 'committerTimestamp' put: timestamp.

	commit2 := bitBucketApi commit2.
	timestamp2 := (currentDate - 4 weeks) asUnixTime * 1000.
	commit2 at: 'committerTimestamp' put: timestamp2.


	bitBucketApi commits: {
			commit1.
			commit2 }.

	"When"
	commits := bitBucketImporter importAndLoadLatestsCommitsOfProject:
		           project.

	"Then"
	self
		assert: (bitBucketImporter glhModel allWithType: GLHCommit) size
		equals: 1.

	self assert: project repository commits size equals: 1.
	firstCommit := project repository commits first.
	self assert: firstCommit additions equals: 1
]

{ #category : 'tests' }
BitBucketModelImporterTest >> testImportCommitsOfProjectSinceUntil [

	| bitBucketApi glphModel bitBucketImporter project commits group repo firstCommit |
	"Given"
	bitBucketApi := BitBucketApiMock new.

	glphModel := GLHModel new name: 'test'.

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
	firstCommit := project repository commits first.
	self assert: firstCommit additions equals: 1
]

{ #category : 'tests' }
BitBucketModelImporterTest >> testImportContributedProjectsOfUser [

	| bitBucketApi glphModel bitBucketImporter user projects commits yesterdayAsTimestamp |
	bitBucketApi := BitBucketApiMock new.

	glphModel := GLHModel new name: 'test'.

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

{ #category : 'tests' }
BitBucketModelImporterTest >> testImportCreatorOfCommit [

	| bitBucketApi glphModel bitBucketImporter creator commit |
	
	"Given"
	bitBucketApi := BitBucketApiMock new.

	glphModel := GLHModel new name: 'test'.

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

{ #category : 'tests' }
BitBucketModelImporterTest >> testImportCreatorOfCommitIfAlreadyExist [

	| bitBucketApi glphModel bitBucketImporter creator commit |
	"Given"
	bitBucketApi := BitBucketApiMock new.

	glphModel := GLHModel new name: 'test'.

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

{ #category : 'tests' }
BitBucketModelImporterTest >> testImportMergeRequestCommits [

	| bitBucketApi glphModel bitBucketImporter mergeRequest commits |
	"Given"
	bitBucketApi := BitBucketApiMock new.

	glphModel := GLHModel new name: 'test'.

	bitBucketImporter := BitBucketModelImporter new
		                     bitBucketApi: bitBucketApi;
		                     glhModel: glphModel.

	mergeRequest := bitBucketImporter
		                parsePullRequestIntoGLPHEMergeRequest:
		                bitBucketApi mergedMergeRequest.


	"When"
	commits := bitBucketImporter importMergeRequestCommits: mergeRequest.

	"Then"
	self deny: mergeRequest commits equals: nil.
	self assert: mergeRequest commits equals: commits.
	self assert: mergeRequest commits first additions equals: 1
]

{ #category : 'tests' }
BitBucketModelImporterTest >> testImportMergeRequestsSinceUntil [

	| bitBucketApi glphModel bitBucketImporter group repo project mergeRequests mergeRequest |
	"Given"
	bitBucketApi := BitBucketApiMock new.

	glphModel := GLHModel new name: 'test'.

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
		(bitBucketImporter glhModel allWithType: GLHMergeRequest) size
		equals: 1.

	self assert: mergeRequests size equals: 1.
	
	mergeRequest := mergeRequests first.
	self assert: mergeRequest state equals: 'opened'.
	self assert: mergeRequest closed_at equals: nil.
]

{ #category : 'tests' }
BitBucketModelImporterTest >> testImportMergeRequestsSinceUntilClosedMR [

	| bitBucketApi glphModel bitBucketImporter group repo project mergeRequests mergeRequest |
	"Given"
	bitBucketApi := BitBucketApiMock new.

	glphModel := GLHModel new name: 'test'.

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
		(bitBucketImporter glhModel allWithType: GLHMergeRequest) size
		equals: 1.

	self assert: mergeRequests size equals: 1.

	mergeRequest := mergeRequests first.
	self assert: mergeRequest state equals: 'merged'.
	self assert: mergeRequest closed_at equals: nil.
	self deny: mergeRequest merged_at equals: nil.
]

{ #category : 'tests' }
BitBucketModelImporterTest >> testImportMergeRequestsSinceUntilDeclinedMR [

	| bitBucketApi glphModel bitBucketImporter group repo project mergeRequests mergeRequest |
	"Given"
	bitBucketApi := BitBucketApiMock new.

	glphModel := GLHModel new name: 'test'.

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
		(bitBucketImporter glhModel allWithType: GLHMergeRequest) size
		equals: 1.

	self assert: mergeRequests size equals: 1.

	mergeRequest := mergeRequests first.
	self assert: mergeRequest state equals: 'closed'.
	self deny: mergeRequest closed_at equals: nil.
	self assert: mergeRequest merged_at equals: nil
]

{ #category : 'tests' }
BitBucketModelImporterTest >> testImportMergeResquestMerger [

	| bitBucketApi glphModel bitBucketImporter mergeRequest mergeUser |
	"Given"
	bitBucketApi := BitBucketApiMock new.

	glphModel := GLHModel new name: 'test'.

	bitBucketImporter := BitBucketModelImporter new
		                     bitBucketApi: bitBucketApi;
		                     glhModel: glphModel.

	mergeRequest := bitBucketImporter
		                parsePullRequestIntoGLPHEMergeRequest:
		                bitBucketApi mergedMergeRequest.


	"When"
	mergeUser := bitBucketImporter importMergeResquestMerger:
		             mergeRequest.

	"Then"
	self deny: mergeRequest merge_user equals: nil.
	self assert: mergeRequest merge_user equals: mergeUser
]

{ #category : 'tests' }
BitBucketModelImporterTest >> testImportUserByUsername [
	"Given"

	| bitBucketApi glphModel bitBucketImporter user |
	bitBucketApi := BitBucketApiMock new.

	glphModel := GLHModel new name: 'test'.

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

{ #category : 'tests' }
BitBucketModelImporterTest >> testImportUserByUsernameWithoutUsers [
	"Given"

	| bitBucketApi glphModel bitBucketImporter user |
	bitBucketApi := BitBucketApiMock new.

	glphModel := GLHModel new name: 'test'.

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
