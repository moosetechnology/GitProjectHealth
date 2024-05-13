Class {
	#name : #CodeChurnAnalyzer,
	#superclass : #Object,
	#instVars : [
		'glModel',
		'fromCommit',
		'glhImporter'
	],
	#category : #'GitLabHealth-Model-Analysis'
}

{ #category : #'as yet unclassified' }
CodeChurnAnalyzer >> analyseChurn [

	| commitFiles churn |
	commitFiles := self impactedFilesInFollowUpCommitsOf: fromCommit.

	churn := self computeChurnOnFiles: commitFiles.
	^ churn. 
]

{ #category : #churn }
CodeChurnAnalyzer >> computeChurnOnFiles: aCollection [ 
	
	|changesDic perFileChanges  churns |
	
	"1 -> (a GLPHEChange -> NumberOfChurnDetected)"
	changesDic := Dictionary new. 
	
	
	perFileChanges := aCollection associations collect: [ :assoc |
		
		(assoc key -> (self computeSpecificChurnOf: assoc value )). 
		 ] .
	
	 churns := perFileChanges collect: [ :assoc |
		|churn file results|
		
		file := assoc key.
		results := assoc value. 
		churn := ((results values select: [ :a | a value > 1 ] )size)/(results values sum: [ :a | a value ]).
		(file -> churn)
		 ].
	
	^ {(#churns -> churns).
			(#details -> perFileChanges)} asDictionary 
]

{ #category : #churn }
CodeChurnAnalyzer >> computeSpecificChurnOf: commit2Changes [ 
	|changesDic|
	"1 -> (a GLPHEChange -> NumberOfChurnDetected)"
	changesDic := OrderedDictionary new. 
	
	commit2Changes do: [ :entry |
		|commit diffRanges|
		commit := entry key.
		diffRanges := entry value. 
		
		diffRanges do: [ :diff |
			|from upTo|
			
			from := (diff originalLineRange copyFrom: (diff originalLineRange indexOf: $-)+1 to: (diff originalLineRange indexOf: $,)-1 ) asString asNumber    .
			self insertDiff: diff into: changesDic startingFrom: from. 
			
			 ].
		
		 ].
	
	
	
	^ self sortChangeDic: changesDic.
]

{ #category : #accessing }
CodeChurnAnalyzer >> fromCommit: aCommit [
	fromCommit := aCommit. 
]

{ #category : #accessing }
CodeChurnAnalyzer >> glhImporter: anImporter [
	glhImporter := anImporter .
]

{ #category : #'as yet unclassified' }
CodeChurnAnalyzer >> impactedFilesInFollowUpCommitsOf: aGLHCommit [

	| commitFiles |
	commitFiles := (fromCommit diffs collect: [ :diff |
		                diff new_path -> Set new ])
		               asDictionary.

	self
		visitChildCommits: fromCommit childCommits
		lookingForFiles: commitFiles.

	^ commitFiles
]

{ #category : #initialization }
CodeChurnAnalyzer >> initialize [

	glModel := GLPHEModel new.
	fromCommit := GLHCommit new.
	glhImporter := GLPHModelImporter new. 
	
]

{ #category : #insertion }
CodeChurnAnalyzer >> insertDiff: aGLPHEDiffRange into: fileChangesDic startingFrom: from [ 
	|index|
	index := from. 
	aGLPHEDiffRange changes do: [ :aChange |
	
		aChange isAddition ifTrue: [ 
			fileChangesDic at: index ifPresent: [ :current | 
			 
			current key add: aChange.
			current value: current value + 1.  ] ifAbsentPut: [((OrderedCollection new add: aChange; yourself) -> 1 ) ].
			 ].
		
		aChange isDeletion ifFalse: [ index := index + 1 ]. 
		
		 ]
]

{ #category : #'as yet unclassified' }
CodeChurnAnalyzer >> onModel: agitHealthModel [
	glModel := agitHealthModel
]

{ #category : #sorting }
CodeChurnAnalyzer >> sortChangeDic: aCollection [ 
	^ (aCollection associations sortAscending: [ :e | e key ] ) asOrderedDictionary 
]

{ #category : #visiting }
CodeChurnAnalyzer >> visitChildCommits: commits lookingForFiles: commitFiles [

	commits ifEmpty: [ ^ commitFiles ].

	commits do: [ :commit |
		| files |
		files := commit diffs collect: [ :diff | diff ].

		files do: [ :diff |
			commitFiles
				at: diff new_path
				ifPresent: [ :v | v add: commit -> diff diffRanges ]
				ifAbsent: [  ] ].

		self
			visitChildCommits: commit childCommits
			lookingForFiles: commitFiles ].

	^ commitFiles
]
