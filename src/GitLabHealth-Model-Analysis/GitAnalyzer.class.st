Class {
	#name : #GitAnalyzer,
	#superclass : #Object,
	#instVars : [
		'glModel',
		'fromCommit',
		'glhImporter',
		'onProject',
		'maxChildCommits'
	],
	#category : #'GitLabHealth-Model-Analysis'
}

{ #category : #'as yet unclassified' }
GitAnalyzer >> analyseAmandment [
	"return the first commit that modify the same lines of code as the fromCommit"

	| churn res |
	churn := self analyseChurn.

	res := self firstAmandmentFromChrun: churn.

	^ res
]

{ #category : #'as yet unclassified' }
GitAnalyzer >> analyseChurn [

	| commitFiles |
	commitFiles := self
		               impactedFilesInFollowUpCommitsOf: fromCommit
		               withMaxCommits: self maxChildCommits.

	^ self computeChurnOnFiles: commitFiles
]

{ #category : #'as yet unclassified' }
GitAnalyzer >> analyseCommitFrequencySince: since until: until [ 

	| commits response |
	response := {
		            (#numberOfCommit -> nil).
		            (#frequency -> nil) } asDictionary.

	commits := glhImporter
		           importCommitsOProject: onProject
		           since: since
		           until: until.

	commits := self arrangeCommitsByDate: commits.
	commits := (commits associations sortAscending: [ :entry |
		            entry key asDate ]) asOrderedDictionary.

	^ commits
]

{ #category : #'as yet unclassified' }
GitAnalyzer >> analyseMergeResquestValidation: aGLHPMergeRequest [

	|creationDate mergedDate response|
	
	response := { 
		 #id_merge_resquest -> aGLHPMergeRequest iid. 
		 #id_merge_commit -> nil.
		 #created_at ->  aGLHPMergeRequest created_at.
		 #merged_at -> nil .
		 #duration ->  nil.
		 #status -> (aGLHPMergeRequest merge_status)} asDictionary .  
	 
	
	creationDate := aGLHPMergeRequest created_at asDateAndTime.

	mergedDate := aGLHPMergeRequest merged_at ifNil: [ 
		
		^ response 
		
		 ].
	
	^ response at: #duration put: (mergedDate - creationDate); 
					at: #id_merge_commit put: aGLHPMergeRequest merge_commit_sha  ; 
					at: #merged_at put: aGLHPMergeRequest merged_at;
					yourself. 

]

{ #category : #filter }
GitAnalyzer >> arrangeCommitsByDate: commits [ 
	|date2commits|
	date2commits := Dictionary new. 
	
	commits do: [ :commit |
		|date|
		date := commit created_at asDate. 
		date2commits at: date printString ifPresent: [ :v | v add: commit ] ifAbsentPut: [ OrderedCollection new add: commit; yourself. ].
		 ].
	^ date2commits. 
]

{ #category : #churn }
GitAnalyzer >> computeChurnOnFiles: aCollection [ 
	
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
		results values ifEmpty: [ churn := nil. ] ifNotEmpty: [ churn := ((results values select: [ :a | a value > 1 ] )sum: [ :a | a value ]) / (results values sum: [ :a | a value ]) . ].
		
		(file -> churn)
		 ].
	
	^ {(#churns -> churns).
			(#details -> perFileChanges)} asDictionary 
]

{ #category : #churn }
GitAnalyzer >> computeSpecificChurnOf: commit2Changes [ 
	|changesDic|
	"1 -> (a GLPHEChange -> NumberOfChurnDetected)"
	changesDic := OrderedDictionary new. 
	
	
	(commit2Changes sortAscending: [ :assoc | assoc key created_at ]) do: [ :entry |
		|commit diffRanges|
		commit := entry key.
		diffRanges := entry value. 
		
		diffRanges do: [ :diff |
			|from upTo|
			
			from := (diff originalLineRange copyFrom: (diff originalLineRange indexOf: $-)+1 to: (diff originalLineRange indexOf: $,)-1 ) asString asNumber.
			(from = 0) ifTrue:[from := 1].
			self insertDiff: diff into: changesDic startingFrom: from. 
			
			 ].
		
		 ].
	
	
	
	^ self sortChangeDic: changesDic.
]

{ #category : #accessing }
GitAnalyzer >> firstAmandmentFromChrun: aChurnAnalysis [ 
	|details whereChangesOccurs firstCommitsPerFile|
	
	whereChangesOccurs := (aChurnAnalysis at: #churns ) select: [ :file | file value > 0 ].
	
	details := whereChangesOccurs collect: [ :file |
		((aChurnAnalysis at: #details) detect: [ :entry | entry key = file key] )
		 ].
	
	firstCommitsPerFile := details collect: [ :perFile |
		|changes firstCommits first|
		changes := perFile value.
		changes := changes select: [ :line2changes | line2changes value value > 1  ].
		firstCommits := (changes collect: [ :line2changes |  line2changes key second diffRange diff commit ]) values. 
		first := (firstCommits sortAscending: [:c | c created_at ]) first.
		 ].
	

	^ (firstCommitsPerFile sortAscending: [:c | c created_at ]) first. 

]

{ #category : #accessing }
GitAnalyzer >> fromCommit: aCommit [
	fromCommit := aCommit. 
]

{ #category : #accessing }
GitAnalyzer >> glhImporter: anImporter [
	glhImporter := anImporter .
]

{ #category : #'as yet unclassified' }
GitAnalyzer >> impactedFilesInFollowUpCommitsOf: aGLHCommit [

	^ self impactedFilesInFollowUpCommitsOf:  aGLHCommit withMaxCommits: -1 
]

{ #category : #churn }
GitAnalyzer >> impactedFilesInFollowUpCommitsOf: aGLHCommit withMaxCommits: max [

	| commitFiles |
	commitFiles := (fromCommit diffs collect: [ :diff |
		                diff new_path -> (Set new
			                 add: aGLHCommit -> diff diffRanges;
			                 yourself) ]) asDictionary.

	self
		visitChildCommits: fromCommit childCommits
		lookingForFiles: commitFiles upto: max.

	^ commitFiles
]

{ #category : #initialization }
GitAnalyzer >> initialize [

	glModel := GLPHEModel new.
	fromCommit := GLHCommit new.
	glhImporter := GLPHModelImporter new.
	onProject:= GLHProject new. 
]

{ #category : #insertion }
GitAnalyzer >> insertDiff: aGLPHEDiffRange into: fileChangesDic startingFrom: from [ 
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

{ #category : #accessing }
GitAnalyzer >> maxChildCommit: max [ 
	maxChildCommits := max
]

{ #category : #accessing }
GitAnalyzer >> maxChildCommits [
	^ maxChildCommits
]

{ #category : #'as yet unclassified' }
GitAnalyzer >> onModel: agitHealthModel [
	glModel := agitHealthModel
]

{ #category : #accessing }
GitAnalyzer >> onProject: aGLHProject [ 
	onProject := aGLHProject
]

{ #category : #sorting }
GitAnalyzer >> sortChangeDic: aCollection [ 
	^ (aCollection associations sortAscending: [ :e | e key ] ) asOrderedDictionary 
]

{ #category : #visiting }
GitAnalyzer >> visitChildCommits: commits lookingForFiles: commitFiles [

	^ self visitChildCommits:  commits lookingForFiles: commitFiles upto: -1 
]

{ #category : #visiting }
GitAnalyzer >> visitChildCommits: commits lookingForFiles: commitFiles upto: nCommits [

	commits ifEmpty: [ ^ commitFiles ].
	(nCommits = 0) ifTrue: [ ^ commitFiles ].

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
			lookingForFiles: commitFiles
			upto: nCommits - 1 ].

	^ commitFiles
]
