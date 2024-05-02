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

	|commitFiles|
	
	commitFiles := self impactedFilesInFollowUpCommitsOf: fromCommit.
	
	commitFiles associations do: [ :assoc |
		|file impactedCommits ranges|
		file := assoc key.
		impactedCommits := assoc value. 
		1 halt. 
		ranges := impactedCommits collect: [ :range | 
			ranges
			]
			
		 ].
	
	
	1 halt. 
	
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

{ #category : #'as yet unclassified' }
CodeChurnAnalyzer >> onModel: agitHealthModel [
	glModel := agitHealthModel
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
