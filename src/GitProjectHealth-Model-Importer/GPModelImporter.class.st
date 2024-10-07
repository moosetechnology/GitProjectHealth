"
I am a superclass for Model importer.
I am a try of normalization for the different importer.

I also define some contract so it is easier to switch from one importer to another
"
Class {
	#name : #GPModelImporter,
	#superclass : #Object,
	#instVars : [
		'withCommitsSince',
		'withFiles',
		'glhModel'
	],
	#classVars : [
		'currentImporter'
	],
	#category : #'GitProjectHealth-Model-Importer'
}

{ #category : #'accessing - global variables' }
GPModelImporter class >> importers [
	^ currentImporter 
]

{ #category : #initialization }
GPModelImporter class >> reset [
	currentImporter := OrderedDictionary new.
]

{ #category : #accessing }
GPModelImporter >> beWithFiles [

	withFiles := true
]

{ #category : #accessing }
GPModelImporter >> beWithoutFiles [

	withFiles := false
]

{ #category : #'as yet unclassified' }
GPModelImporter >> blockEqualityOn: aSymbol [
	^ [ :existing :new |
	  (existing perform: aSymbol) = (new perform: aSymbol) ]
]

{ #category : #equality }
GPModelImporter >> blockForDiffEquality [
	^ [ :existing :new |
			existing diffString size = new diffString size and: [
				existing diffString = new diffString ] ]
]

{ #category : #'as yet unclassified' }
GPModelImporter >> blockForDiffRangeEquality [

	^ [ :existing :new |
	  existing diff mooseID = new diff mooseID and: [
		  existing originalLineRange = new originalLineRange and: [
			  existing newLineRange = new newLineRange ] ] ]
]

{ #category : #equality }
GPModelImporter >> blockOnIdEquality [

	^ [ :existing :new |
	  existing id = new id ]
]

{ #category : #equality }
GPModelImporter >> blockOnNameEquality [

	^ self blockEqualityOn: #name
]

{ #category : #commit }
GPModelImporter >> chainsCommitsFrom: commitsCollection [

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

{ #category : #'as yet unclassified' }
GPModelImporter >> filterCommitChanges: aCollection [

	^ aCollection reject: [ :line |
		  | trimmedLine |
		  trimmedLine := line trimLeft.
		  (trimmedLine beginsWith: '---') or: [
			  (trimmedLine beginsWith: '+++') or: [
				  trimmedLine beginsWith: '\ No newline at end of file' ] ] ]
]

{ #category : #accessing }
GPModelImporter >> glhModel [

	^ glhModel
]

{ #category : #accessing }
GPModelImporter >> glhModel: anObject [

	glhModel := anObject
]

{ #category : #import }
GPModelImporter >> importDiffRangesForDiff: aGLHDiff [

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

{ #category : #initialization }
GPModelImporter >> initialize [

	super initialize.
	self withCommitsSince: (Date today - 1 week) asDateAndTime
]

{ #category : #'as yet unclassified' }
GPModelImporter >> makeGlobal [
	^ self makeGlobal: DateAndTime now printString.
]

{ #category : #'as yet unclassified' }
GPModelImporter >> makeGlobal: aLabel [ 

	currentImporter := GHModelImporter importers ifNil: [ OrderedDictionary new ].
	currentImporter at: aLabel put: self. 
	^ currentImporter 
]

{ #category : #parsing }
GPModelImporter >> parseDiffString: aDiff [
	"parse diff string to create entities for each lines"

	| lines range index firstChangeRange |
	lines := aDiff diffString lines.
	index := 0.
	range := nil.

	lines ifEmpty: [ ^ aDiff diffRanges ].
	lines := self filterCommitChanges: lines.
	(lines first beginsWith: '@@') ifFalse: [ ^ aDiff diffRanges ].

	lines do: [ :line |
		| aChange |
		firstChangeRange := false.
		(line trim beginsWith: #'@@') ifTrue: [
			range := GLPHEDiffRange newFrom: line.
			firstChangeRange := true.
			range := aDiff diffRanges add: range unless: [ :existing :new |
				         existing originalLineRange = new originalLineRange and: [
					         existing newLineRange = new newLineRange ] ] ].

		self withCommitDiffs ifTrue: [
			firstChangeRange ifFalse: [
				aChange := GLPHEChange newFrom: line.
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
GPModelImporter >> withCommitsSince [

	^ withCommitsSince
]

{ #category : #accessing }
GPModelImporter >> withCommitsSince: anObject [

	withCommitsSince := anObject
]

{ #category : #accessing }
GPModelImporter >> withFiles [

	^ withFiles
]

{ #category : #accessing }
GPModelImporter >> withFiles: anObject [

	withFiles := anObject
]
