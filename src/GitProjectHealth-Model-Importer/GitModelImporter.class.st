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
		'withCommitDiffs'
	],
	#classVars : [
		'currentImporter'
	],
	#category : #'GitProjectHealth-Model-Importer'
}

{ #category : #'accessing - global variables' }
GitModelImporter class >> importers [
	^ currentImporter 
]

{ #category : #initialization }
GitModelImporter class >> reset [
	currentImporter := OrderedDictionary new.
]

{ #category : #accessing }
GitModelImporter >> beWithFiles [

	withFiles := true
]

{ #category : #accessing }
GitModelImporter >> beWithoutFiles [

	withFiles := false
]

{ #category : #'as yet unclassified' }
GitModelImporter >> blockEqualityOn: aSymbol [
	^ [ :existing :new |
	  (existing perform: aSymbol) = (new perform: aSymbol) ]
]

{ #category : #equality }
GitModelImporter >> blockForDiffEquality [
	^ [ :existing :new |
			existing diffString size = new diffString size and: [
				existing diffString = new diffString ] ]
]

{ #category : #'as yet unclassified' }
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

{ #category : #commit }
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

{ #category : #commit }
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

{ #category : #'as yet unclassified' }
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

{ #category : #import }
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

{ #category : #pipelines }
GitModelImporter >> importLatestPipelinesOfProject: aGLHProject [ 
	(self pipelinesOf: aGLHProject id withLimit:30) do: [ :pipeline |
		self glhModel add: pipeline unless: self blockOnIdEquality .
		aGLHProject pipelines add: pipeline unless: self blockOnIdEquality]
]

{ #category : #'import - notes' }
GitModelImporter >> importNotesfromMergeRequest: mergeRequest [

	self subclassResponsibility
]

{ #category : #'import - projects' }
GitModelImporter >> importProject: id [
	"id can be a string or an integer depending on the APi implementation"

	"return the project created or retrieved"

	^ self subclassResponsibility
]

{ #category : #'import - projects' }
GitModelImporter >> importProjects: aCollectionOfProjectID [


	^ aCollectionOfProjectID collect: [ :id | self importProject: id ]
]

{ #category : #initialization }
GitModelImporter >> initialize [

	super initialize.
	self withCommitsSince: (Date today - 1 week) asDateAndTime.
		userCatalogue := GLHUserCatalogueV2 new
		                 anImporter: self;
		                 yourself.
]

{ #category : #'as yet unclassified' }
GitModelImporter >> makeGlobal [
	^ self makeGlobal: DateAndTime now printString.
]

{ #category : #'as yet unclassified' }
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
