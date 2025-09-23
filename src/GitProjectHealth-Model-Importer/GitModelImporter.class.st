"
I am a superclass for Model importer.
I am a try of normalization for the different importer.

I also define some contract so it is easier to switch from one importer to another
"
Class {
	#name : #GitModelImporter,
	#superclass : #Object,
	#instVars : [
		'withCommitsSince',
		'withFiles',
		'glhModel',
		'userCatalogue',
		'repoApi',
		'withCommitDiffs',
		'generalReader'
	],
	#classVars : [
		'currentImporter'
	],
	#category : #'GitProjectHealth-Model-Importer'
}

{ #category : #bitbucket }
GitModelImporter class >> forBitbucketHostOn: anHostURL withToken: anApiToken [
	
	^ self forBitbucketHostOn: anHostURL withToken: anApiToken andModel: GLHModel new. 
]

{ #category : #bitbucket }
GitModelImporter class >> forBitbucketHostOn: anHostURL withToken: anApiToken andModel: aGitModel [
	
	| bitbucketApi bitBucketImporter |
	bitbucketApi := BitbucketApi new
                host: anHostURL;
                bearerToken: anApiToken.

	bitBucketImporter := BitBucketModelImporter new
                     repoApi: bitbucketApi;
                     glhModel: aGitModel;
                     withFiles: false;
                     withCommitsSince: 3 day;
                     withCommitDiffs: false.
	^bitBucketImporter 
]

{ #category : #github }
GitModelImporter class >> forGithubWithToken: anApiToken [
	^ self forGithubWithToken: anApiToken andModel: GLHModel new
]

{ #category : #github }
GitModelImporter class >> forGithubWithToken: anApiToken andModel: aGitModel [

	| githubImport |
	githubImport := GithubModelImporter new
		                glhModel: aGitModel;
		                privateToken: anApiToken;
		                withCommitsSince: 3 day;
		                yourself.
	^ githubImport
]

{ #category : #gitlab }
GitModelImporter class >> forGitlabHostOn: anHostURL withToken: anApiToken [ 
	^ self forGitlabHostOn: anHostURL withToken: anApiToken andModel: GLHModel new. 
]

{ #category : #gitlab }
GitModelImporter class >> forGitlabHostOn: anHostURL withToken: anApiToken andModel: aGitModel [
	"use it when accessing onpremise or custom gitlab platform"
	| glphApi gitlabImporter |
	
	glphApi := GitlabApi new
    privateToken: anApiToken;
    hostUrl: anHostURL;
	 output: 'json';
    yourself.

	gitlabImporter := GitlabModelImporter new
    repoApi: glphApi;
    glhModel: aGitModel;
	 withFiles: false;
	 withCommitsSince: 3 day;
	 withCommitDiffs: false.
		
	^ gitlabImporter 
]

{ #category : #gitlab }
GitModelImporter class >> forGitlabWithToken: anApiToken [
	^ self forGitlabHostOn: 'https://gitlab.com/api/v4' withToken: anApiToken andModel: GLHModel new. 
]

{ #category : #gitlab }
GitModelImporter class >> forGitlabWithToken: anApiToken andModel: aGitModel [
	^ self forGitlabHostOn: 'https://gitlab.com/api/v4' withToken: anApiToken andModel: aGitModel
]

{ #category : #'accessing - global variables' }
GitModelImporter class >> importers [
	^ currentImporter 
]

{ #category : #'class initialization' }
GitModelImporter class >> initialize [ 
	currentImporter := Dictionary new. 
]

{ #category : #initialization }
GitModelImporter class >> reset [
	currentImporter := OrderedDictionary new.
]

{ #category : #initialization }
GitModelImporter >> beWithFiles [

	withFiles := true
]

{ #category : #initialization }
GitModelImporter >> beWithoutFiles [

	withFiles := false
]

{ #category : #equality }
GitModelImporter >> blockEqualityOn: aSymbol [
	^ [ :existing :new |
	  (existing perform: aSymbol) = (new perform: aSymbol) ]
]

{ #category : #equality }
GitModelImporter >> blockEqualityOn: aSymbol andOn: aSecondSymbol [
	^ (self blockEqualityOn: aSymbol) and: [ self blockEqualityOn: aSecondSymbol ]
]

{ #category : #equality }
GitModelImporter >> blockForBranchEquality [
	^ [ :existing :new |
	  (existing name = new name) and: [ existing repository project id = new repository project id ] ]
	
]

{ #category : #equality }
GitModelImporter >> blockForDiffEquality [
	^ [ :existing :new |
			existing diffString size = new diffString size and: [
				existing diffString = new diffString ] ]
]

{ #category : #equality }
GitModelImporter >> blockForDiffRangeEquality [

	^ [ :existing :new |
	  existing diff mooseID = new diff mooseID and: [
		  existing originalLineRange = new originalLineRange and: [
			  existing newLineRange = new newLineRange ] ] ]
]

{ #category : #equality }
GitModelImporter >> blockOnIdEquality [

	^ [ :existing :new |
	  existing id = new id ]
]

{ #category : #equality }
GitModelImporter >> blockOnNameEquality [

	^ self blockEqualityOn: #name
]

{ #category : #utils }
GitModelImporter >> chainsCommitsFrom: commitsCollection [

	| dic |
	('Chains ' , commitsCollection size printString , ' commits')
		recordInfo.

	dic := ((self glhModel allWithType: GLHCommit) collect: [ :commit |
		        commit id -> commit ]) asSet asDictionary.

	commitsCollection do: [ :commit |
		commit parent_ids do: [ :parentId |
			dic
				at: parentId
				ifPresent: [ :parentCommit |
					parentCommit childCommits
						add: commit
						unless: [ :existing :new | existing id = new id ] ]
				ifAbsent: [  ] ] ].
	^ commitsCollection
]

{ #category : #'import - commits' }
GitModelImporter >> completeImportedCommit: aGLHCommit [ 
	
	
	('completing commit: ' , aGLHCommit short_id printString) recordInfo.
	self importCreatorOfCommit: aGLHCommit.

	self withCommitDiffs ifTrue: [
		| diffs |
		aGLHCommit diffs ifEmpty: [
			diffs := self importDiffOfCommit: aGLHCommit.
			self glhModel addAll: diffs unless: self blockForDiffEquality ] ].

	^ aGLHCommit
]

{ #category : #'import - projects' }
GitModelImporter >> completeImportedProject: aGLHProject [
]

{ #category : #'private - configure reader' }
GitModelImporter >> configureReaderForBranch: reader [

	reader mapInstVarsFor: GLHBranch.

	reader
		for: #ArrayOfBranch
		customDo: [ :customMappting |
		customMappting listOfElementSchema: GLHBranch ]
]

{ #category : #'private - configure reader' }
GitModelImporter >> configureReaderForCommit: reader [
	
	reader mapInstVarsFor: GLHCommit .
	
	reader
		for: #ArrayOfCommit
		customDo: [ :customMappting |
		customMappting listOfElementSchema: GLHCommit ]
]

{ #category : #'private - configure reader' }
GitModelImporter >> configureReaderForDiff: reader [

	reader mapInstVarsFor: GLHDiff.

	reader
		for: #ArrayOfDiff
		customDo: [ :customMappting |
		customMappting listOfElementSchema: GLHDiff ]
]

{ #category : #'private - configure reader' }
GitModelImporter >> configureReaderForGroup: reader [

	reader mapInstVarsFor: GLHGroup.

	reader
		for: #ArrayOfGroup
		customDo: [ :customMappting |
		customMappting listOfElementSchema: GLHGroup ]
]

{ #category : #'private - configure reader' }
GitModelImporter >> configureReaderForIssue: reader [

	reader mapInstVarsFor: GLHIssue.

	reader
		for: #ArrayOfIssue
		customDo: [ :customMappting |
		customMappting listOfElementSchema: GLHIssue ]
]

{ #category : #'private - configure reader' }
GitModelImporter >> configureReaderForMergeRequest: reader [

	reader mapInstVarsFor: GLHMergeRequest.

	reader
		for: #ArrayOfMergeRequest
		customDo: [ :customMappting |
		customMappting listOfElementSchema: GLHMergeRequest ]
]

{ #category : #'private - configure reader' }
GitModelImporter >> configureReaderForMilestone: reader [

	reader mapInstVarsFor: GLHMilestone.

	reader
		for: #ArrayOfMilestone
		customDo: [ :customMappting |
		customMappting listOfElementSchema: GLHMilestone ]
]

{ #category : #'private - configure reader' }
GitModelImporter >> configureReaderForPipeline: reader [

	reader mapInstVarsFor: GLHPipeline.

	reader
		for: #ArrayOfPipeline
		customDo: [ :customMappting |
		customMappting listOfElementSchema: GLHPipeline ]
]

{ #category : #'private - configure reader' }
GitModelImporter >> configureReaderForProject: reader [

	reader mapInstVarsFor: GLHProject.

	reader
		for: #ArrayOfProject
		customDo: [ :customMappting |
		customMappting listOfElementSchema: GLHProject ]
]

{ #category : #'private - configure reader' }
GitModelImporter >> configureReaderForRelease: reader [

	reader mapInstVarsFor: GLHRelease.

	reader
		for: #ArrayOfRelease
		customDo: [ :customMappting |
		customMappting listOfElementSchema: GLHRelease ]
]

{ #category : #'private - configure reader' }
GitModelImporter >> configureReaderForTag: reader [

	reader mapInstVarsFor: GLHTag.

	reader
		for: #ArrayOfTag
		customDo: [ :customMappting |
		customMappting listOfElementSchema: GLHTag ]
]

{ #category : #'private - configure reader' }
GitModelImporter >> configureReaderForUser: reader [

	reader mapInstVarsFor: GLHUser.

	reader
		for: #ArrayOfUser
		customDo: [ :customMappting |
		customMappting listOfElementSchema: GLHUser ]
]

{ #category : #utils }
GitModelImporter >> filterCommitChanges: aCollection [

	^ aCollection reject: [ :line |
		  | trimmedLine |
		  trimmedLine := line trimLeft.
		  (trimmedLine beginsWith: '---') or: [
			  (trimmedLine beginsWith: '+++') or: [
				  trimmedLine beginsWith: '\ No newline at end of file' ] ] ]
]

{ #category : #accessing }
GitModelImporter >> glhModel [

	^ glhModel
]

{ #category : #accessing }
GitModelImporter >> glhModel: anObject [

	glhModel := anObject
]

{ #category : #'import - commits' }
GitModelImporter >> importAndLoadLatestsCommitsOfProject: aGLHProject [

	self subclassResponsibility 
]

{ #category : #'import - users' }
GitModelImporter >> importAuthorOfCommit: aGLHCommit [

	self
		deprecated: 'Use importCreatorOfCommit: instead of current one'
		on: '19 September 2025'
		in:
		'Pharo-12.0.0+SNAPSHOT.build.1571.sha.cf5fcd22e66957962c97dffc58b0393b7f368147 (64 Bit)'.

	self subclassResponsibility
]

{ #category : #'import - repositories' }
GitModelImporter >> importBranchesOf: aGLHProject [

	^ self subclassResponsibility
]

{ #category : #'import - commits' }
GitModelImporter >> importCommit: aCommitID ofProject: aGLHProject [

	self subclassResponsibility 
]

{ #category : #'import - commits' }
GitModelImporter >> importCommitsOfBranch: aGLHBranch [
	self subclassResponsibility 
	
	
]

{ #category : #'import - commits' }
GitModelImporter >> importCommitsOfProject: aGLHProject since: since until: until [

	self subclassResponsibility 
]

{ #category : #'import - projects' }
GitModelImporter >> importContributedProjectsOfUser: aGLHUser [
]

{ #category : #'import - users' }
GitModelImporter >> importCreatorOfCommit: aGLHCommit [

	self subclassResponsibility 
]

{ #category : #'import - diffs' }
GitModelImporter >> importDiffOfCommit: aCommit [

	self subclassResponsibility 
]

{ #category : #'import - diffs' }
GitModelImporter >> importDiffRangesForDiff: aGLHDiff [

	| diffRanges |
	aGLHDiff diffRanges ifNotEmpty: [
		('Diffs already imported for ' , aGLHDiff printString) recordInfo.
		^ aGLHDiff diffRanges ].

	('Import changes of diff ' , aGLHDiff printString) recordInfo.
	"the import of 'diffRanges' entites is technically done inside the parseDiffString"

	diffRanges := self glhModel
		              addAll: (self parseDiffString: aGLHDiff)
		              unless: self blockForDiffRangeEquality.
	^ aGLHDiff diffRanges
		  addAll: diffRanges
		  unless: self blockForDiffRangeEquality
]

{ #category : #'import - groups' }
GitModelImporter >> importGroup: aGroupID [

	self subclassResponsibility
]

{ #category : #'import - issues' }
GitModelImporter >> importIssuesOfProject: aGLHProject [
	self subclassResponsibility 
]

{ #category : #'import - jobs' }
GitModelImporter >> importJobsOf: aGLHPipeline [
	self subclassResponsibility 
]

{ #category : #'import - commits' }
GitModelImporter >> importLatestCommitsOfProject: aGLHProject [
	"limited to the last 50 commits"
	self subclassResponsibility 
]

{ #category : #'import - merge-requests' }
GitModelImporter >> importLatestMergeRequestsOfProject: aGLHProject [
	self subclassResponsibility 
]

{ #category : #'import - pipelines' }
GitModelImporter >> importLatestPipelinesOfProject: aGLHProject [
	self subclassResponsibility 
	
]

{ #category : #'import - releases' }
GitModelImporter >> importLatestReleaseOfProject: aGLHProject [
	^ self subclassResponsibility 
]

{ #category : #'import - merge-requests' }
GitModelImporter >> importMergeRequestCommits: mergeRequest [
]

{ #category : #'import - merge-requests' }
GitModelImporter >> importMergeRequestMergeCommits: aGLHMergeRequest [
]

{ #category : #'import - merge-requests' }
GitModelImporter >> importMergeRequestsOfProject: aGLHProject [

	self subclassResponsibility 
]

{ #category : #'import - merge-requests' }
GitModelImporter >> importMergeRequestsOfProject: aGLHProject since: fromDate until: toDate [
	self subclassResponsibility 
]

{ #category : #'import - merge-requests' }
GitModelImporter >> importMergeResquestAuthor: mergeRequest [
]

{ #category : #'import - merge-requests' }
GitModelImporter >> importMergeResquestMerger: mergeRequest [
]

{ #category : #'import - milestones' }
GitModelImporter >> importMilestonesOfProject: aGLHProject [
	self subclassResponsibility 
]

{ #category : #'import - notes' }
GitModelImporter >> importNotesOfMergeRequest: mergeRequest [

	self subclassResponsibility
]

{ #category : #'import - pipelines' }
GitModelImporter >> importPipeline: aPipelineId OfProject: aGLHProject [

	self subclassResponsibility 
]

{ #category : #'import - merge-requests' }
GitModelImporter >> importPipelinesOfProject: aGLHProject [
	^ self subclassResponsibility 
]

{ #category : #'import - projects' }
GitModelImporter >> importProject: id [
	"id can be a string or an integer depending on the APi implementation"

	"return the project created or retrieved"

	^ self subclassResponsibility
]

{ #category : #'import - projects' }
GitModelImporter >> importProject: aProjectID ofGroup: aGroup [
]

{ #category : #'import - projects' }
GitModelImporter >> importProjects: aCollectionOfProjectID [


	^ aCollectionOfProjectID collect: [ :id | self importProject: id ]
]

{ #category : #'import - projects' }
GitModelImporter >> importProjectsOfUser: aGLHUser [
	"https://docs.github.com/fr/rest/repos/repos?apiVersion=2022-11-28#list-repositories-for-a-user"
	
	self subclassResponsibility 
]

{ #category : #'as yet unclassified' }
GitModelImporter >> importRefCommitOfBranch: aGLHBranch [
	|commit|
	commit := self
				 importCommit: aGLHBranch sha
				 ofProject: aGLHBranch repository project.
	commit := aGLHBranch commits
		add: commit
		unless: self blockOnIdEquality.
	^ commit
]

{ #category : #'import - releases' }
GitModelImporter >> importRelease: aReleaseID ofProject: aGLHProject [
	self subclassResponsibility 
]

{ #category : #'import - tags' }
GitModelImporter >> importTagsForProject: aGLHProject [
	self subclassResponsibility 
]

{ #category : #'import - users' }
GitModelImporter >> importUser: aUserID [
	self subclassResponsibility 
]

{ #category : #'import - users' }
GitModelImporter >> importUserByUsername: username [

	self subclassResponsibility 
]

{ #category : #'private - configure reader' }
GitModelImporter >> initReader [

	generalReader := NeoJSONReader new.

	"will be reuse for all reader next"
	generalReader for: DateAndTime customDo: [ :mapping |
		mapping decoder: [ :string |
			string ifNil: [ nil ] ifNotNil: [ DateAndTime fromString: string ] ] ].


	self configureReaderForCommit: generalReader.
	self configureReaderForGroup: generalReader.
	self configureReaderForDiff: generalReader.
	self configureReaderForMergeRequest: generalReader.
	self configureReaderForPipeline: generalReader.
	self configureReaderForTag: generalReader.
	self configureReaderForRelease: generalReader.
	self configureReaderForUser: generalReader.
	self configureReaderForBranch: generalReader.
	self configureReaderForIssue: generalReader.
	self configureReaderForMilestone: generalReader.
	self configureReaderForProject: generalReader. 
]

{ #category : #initialization }
GitModelImporter >> initialize [

	super initialize.
	self withCommitsSince: (Date today - 1 week) asDateAndTime.
	userCatalogue := GLHUserCatalogueV2 new
		                 anImporter: self;
		                 yourself.
		
	self initReader
]

{ #category : #initialization }
GitModelImporter >> makeGlobal [
	^ self makeGlobal: DateAndTime now printString.
]

{ #category : #initialization }
GitModelImporter >> makeGlobal: aLabel [ 

	currentImporter := GithubModelImporter importers ifNil: [ OrderedDictionary new ].
	currentImporter at: aLabel put: self. 
	^ currentImporter 
]

{ #category : #parsing }
GitModelImporter >> parseDiffString: aDiff [
	"parse diff string to create entities for each lines"

	| lines range index firstChangeRange |
	lines := aDiff diffString lines.
	index := 0.
	range := nil.

	lines ifEmpty: [ ^ aDiff diffRanges ].
	lines := self filterCommitChanges: lines.
	lines ifEmpty: [ ^ aDiff diffRanges ].
	(lines first beginsWith: '@@') ifFalse: [ ^ aDiff diffRanges ].

	lines do: [ :line |
		| aChange |
		firstChangeRange := false.
		(line trim beginsWith: #'@@') ifTrue: [
			range := GLHDiffRange newFrom: line.
			firstChangeRange := true.
			range := aDiff diffRanges add: range unless: [ :existing :new |
				         existing originalLineRange = new originalLineRange and: [
					         existing newLineRange = new newLineRange ] ] ].

		self withCommitDiffs ifTrue: [
			firstChangeRange ifFalse: [
				aChange := GLHChange newFrom: line.
				aChange relativeIndex: index.
				aChange := range changes add: aChange unless: [ :existing :new |
					           existing sourceCode = new sourceCode and: [
						           existing index = new index ] ].
				index := index + 1 ] ] ].

	"add changes to the diff range"
	aDiff diffRanges do: [ :diffRange |
		self glhModel addAll: diffRange changes unless: [ :existing :new |
			existing diffRange mooseID = new diffRange mooseID and: [
				existing sourceCode = new sourceCode and: [
					existing index = new index ] ] ] ].

	^ aDiff diffRanges
]

{ #category : #accessing }
GitModelImporter >> repoApi [

	^ repoApi
]

{ #category : #accessing }
GitModelImporter >> repoApi: anObject [

	repoApi := anObject
]

{ #category : #accessing }
GitModelImporter >> userCatalogue [
	^ userCatalogue 
]

{ #category : #accessing }
GitModelImporter >> userCatalogue: aGLHUserCatalogue [

	userCatalogue := aGLHUserCatalogue.
	aGLHUserCatalogue anImporter: self. 
]

{ #category : #accessing }
GitModelImporter >> withCommitDiffs [

	^ withCommitDiffs
]

{ #category : #accessing }
GitModelImporter >> withCommitDiffs: anObject [

	withCommitDiffs := anObject
]

{ #category : #accessing }
GitModelImporter >> withCommitsSince [

	^ withCommitsSince
]

{ #category : #accessing }
GitModelImporter >> withCommitsSince: someDays [
	"substract the current date with a given number of days. Use to retrieve the commits submit in the last giving days"

	"(GitlabModelImporter new withCommitsSince: 1 week ) >>> (Date today - 1 week) asDateAndTime"

	"(GitlabModelImporter new withCommitsSince: 30 day ) >>> (Date today - 30 day) asDateAndTime"

	(someDays isKindOf: DateAndTime)
		ifTrue: [ withCommitsSince := someDays ]
		ifFalse: [
		withCommitsSince := (DateAndTime today - someDays) ].
	^ withCommitsSince
]

{ #category : #accessing }
GitModelImporter >> withFiles [

	^ withFiles
]

{ #category : #accessing }
GitModelImporter >> withFiles: anObject [

	withFiles := anObject
]
