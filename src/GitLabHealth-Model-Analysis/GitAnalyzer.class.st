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

{ #category : #analyze }
GitAnalyzer >> analyseChurn [

	| commitFiles totalContribution childCommits access |
	access := ('' join: {
			           'churn'.
			           maxChildCommits }) asSymbol.

	^ fromCommit cacheAt: access ifAbsentPut: [
		  ('GitAnalyzer, analyse chrun onProject: ' , onProject printString)
			  recordInfo.
		  childCommits := Set new.
		  totalContribution := self
			                       visitChildCommits: fromCommit childCommits
			                       toStoreThemIn: childCommits
			                       upto: self maxChildCommits.
		  totalContribution add: fromCommit. 
		  totalContribution := totalContribution sum: [ :commit | "nil if merge request commit"
			                       commit additions ifNil: [ 0 ] ].
		  commitFiles := self
			                 impactedFilesInFollowUpCommitsOf: fromCommit
			                 withMaxCommits: self maxChildCommits.
			"a churned line is a line added on top of an already added line"
		  (self computeChurnOnFiles: commitFiles)
			  at: #totalContribution ifAbsentPut: totalContribution;
			  yourself ]
]

{ #category : #analyze }
GitAnalyzer >> analyseCommentContribution [

	| numberOfComments |
	('GitAnalyzer, analyse comment contributions onProject: '
	 , onProject printString) recordInfo.
	numberOfComments := 0.
	
	fromCommit diffs do: [ :diff |
		diff diffRanges do: [ :range |
			range changes do: [ :change |
				((change isKindOf: GLHAddition) and: [
					 (change sourceCode withoutPrefix: '+') trimLeft
						 beginsWithAnyOf: { '#'. '//'. '/*'. '*'. '*/' } ]) ifTrue: [
					numberOfComments := numberOfComments + 1 ] ] ] ].
	^ numberOfComments
]

{ #category : #commit }
GitAnalyzer >> analyseCommitContribution [
	
	
	('GitAnalyzer, analyse commit contribution of: ', fromCommit printString )
		recordInfo.
	
	^ { (#addition -> fromCommit additions).
	  (#deletion -> fromCommit deletions). } asDictionary 
]

{ #category : #analyze }
GitAnalyzer >> analyseCommitFrequencyFromCommits: initialCommits [

	| commits response |
	('GitAnalyzer, analyse commit Frequency on: ' , onProject printString)
		recordInfo.

	response := {
		            (#numberOfCommit -> nil).
		            (#frequency -> nil) } asDictionary.


	commits := self arrangeCommitsByDate: initialCommits.
	commits := (commits associations sortAscending: [ :entry |
		            entry key asDate ]) asOrderedDictionary.

	^ commits
]

{ #category : #analyze }
GitAnalyzer >> analyseCommitFrequencySince: since until: until [ 

	| commits response |
	
	('GitAnalyzer, analyse commit Frequency on: ', onProject printString )
		recordInfo.
	
	response := {
		            (#numberOfCommit -> nil).
		            (#frequency -> nil) } asDictionary.

	commits := glhImporter
		           importCommitsOfProject: onProject
		           since: since
		           until: until.

	commits := self arrangeCommitsByDate: commits.
	commits := (commits associations sortAscending: [ :entry |
		            entry key asDate ]) asOrderedDictionary.

	^ commits
]

{ #category : #analyze }
GitAnalyzer >> analyseDelayUntilFirstChurn [
	"return the first commit that modify the same lines of code as the fromCommit"

	| churn res access|
	
	access := ('' join: {
			           'amandment'.
			           maxChildCommits }) asSymbol.
	
	^ fromCommit cacheAt: access ifPresent: [ :v | v ] ifAbsentPut: [
	
	('GitAnalyzer, analyse amandment onProject: ', onProject printString )
		recordInfo.
	
	churn := self analyseChurn.

	res := self firstAmandmentFromChrun: churn.
	 res]
]

{ #category : #analyze }
GitAnalyzer >> analyseMergeResquestValidation: aGLHPMergeRequest [

	| creationDate mergedDate closedDate currentDate  response |
	('GitAnalyzer, analyse merge request delay of: '
	 , aGLHPMergeRequest printString) recordInfo.

	^ aGLHPMergeRequest 
		  cacheAt: #mergeRequestValidation
		  ifPresent: [ :v | v ]
		  ifAbsentPut: [
			  response := {
				              (#id_merge_resquest -> aGLHPMergeRequest iid).
				              (#id_merge_commit -> nil).
				              (#created_at -> aGLHPMergeRequest created_at).
				              (#open_duration -> nil).
				
				              (#merged_at -> nil).
				              (#duration -> nil).
				
				              (#closed_at -> nil).
				              (#close_duration -> nil).
				              
				              (#status -> aGLHPMergeRequest merge_status) }
				              asDictionary.

			  creationDate := aGLHPMergeRequest created_at asDateAndTime.
            currentDate := DateAndTime now.  "Get the current timestamp"
            "Handle merged case"
            mergedDate := aGLHPMergeRequest merged_at ifNil: [ nil ].
            mergedDate ifNotNil: [
                response  
                    at: #duration put: mergedDate - creationDate;  
                    at: #id_merge_commit put: aGLHPMergeRequest merge_commit_sha;  
                    at: #merged_at put: aGLHPMergeRequest merged_at.  
            ].

           "Handle closed case"
            closedDate := aGLHPMergeRequest closed_at ifNil: [ nil ].
            closedDate ifNotNil: [
                response  
                    at: #close_duration put: closedDate - creationDate;  
                    at: #closed_at put: aGLHPMergeRequest closed_at.
            ].

            "Handle open case (niether merged nor closed)"
            (mergedDate isNil and: closedDate isNil) ifTrue: [
                response at: #open_duration put: currentDate - creationDate.
            ].

            response
        ].
]

{ #category : #filter }
GitAnalyzer >> arrangeCommitsByDate: commits [

	| date2commits |
	date2commits := Dictionary new.

	commits do: [ :commit |
		| date |
		date := commit created_at asDate.
		date2commits
			at: date printString
			ifPresent: [ :v | v add: commit ]
			ifAbsentPut: [
				OrderedCollection new
					add: commit;
					yourself ] ].
	^ date2commits
]

{ #category : #churn }
GitAnalyzer >> computeChurnOnFiles: aCollection [

	| changesDic perFileChanges churns initialAuthor followingAuthors|
	"1 -> (a GLPHEChange -> NumberOfChurnDetected)"
	changesDic := Dictionary new.
	initialAuthor := fromCommit commitCreator. 
	

	perFileChanges := aCollection associations collect: [ :assoc |
		                  assoc key
		                  -> (self computeSpecificChurnOf: assoc value) ].


	churns := perFileChanges collect: [ :assoc |
		          | churnData file aLineOfChanges |
		          file := assoc key.
		          aLineOfChanges := assoc value.
		          churnData := aLineOfChanges values ifEmpty: [  nil ] ifNotEmpty: [
			          | churnedContribution churnSpecificFromCommit churnOfAuthorOnly |
			        
			          "the total churn on any LoC affected"
			          churnedContribution := aLineOfChanges select: [ :a |
				                                 a value  > 1 ].

			          "the churn that coccurs specifically on the loc introduced by the initial commit"
			          churnSpecificFromCommit := churnedContribution select: [ :a |
				                                     (a key collect: [ :loc |
					                                      loc diffRange diff commit ])
					                                     includes: fromCommit ].

						"the churn made the author of the initial commits "
			          churnOfAuthorOnly := churnSpecificFromCommit select: [ :a |
				                                     (((a key collect: [ :loc |
					                                      loc diffRange diff commit commitCreator ]) asSet) difference: {initialAuthor} asSet ) isEmpty
					                                     ].
						

			          {
				                   (#churnFromInitialCommitLines
				                    ->
					                    ((churnSpecificFromCommit sum: #value) - churnSpecificFromCommit size)).
										(#churnFromCommitCreatorOnly
				                    ->
					                    ((churnOfAuthorOnly sum: #value) - churnOfAuthorOnly size)).
				                   (#churnLoC
				                    ->
					                    ((churnedContribution sum: #value)
					                     - churnedContribution size)) 
					} asDictionary ].

		          file -> churnData ].
	churns := churns reject: [ :file2churn | file2churn value isNil ].

	^ {
		  (#churns -> churns).
		  (#details -> perFileChanges) } asDictionary
]

{ #category : #churn }
GitAnalyzer >> computeSpecificChurnOf: commit2Changes [

	| changesDic |
	"1 -> (a GLPHEChange -> NumberOfChurnDetected)"
	changesDic := OrderedDictionary new.


	(commit2Changes sortAscending: [ :assoc | assoc key created_at ])
		do: [ :entry |
			| commit diffRanges |
			commit := entry key.
			diffRanges := entry value.

			diffRanges do: [ :diff |
				| from |
				from := (diff originalLineRange
					         copyFrom: (diff originalLineRange indexOf: $-) + 1
					         to: (diff originalLineRange
							          indexOf: $,
							          ifAbsent: [ diff originalLineRange size + 1 ]) - 1)
					        asString asNumber.
				from = 0 ifTrue: [ from := 1 ].
				self insertDiff: diff into: changesDic startingFrom: from ] ].



	^ self sortChangeDic: changesDic
]

{ #category : #accessing }
GitAnalyzer >> firstAmandmentFromChrun: aChurnAnalysis [ 
	|details whereChangesOccurs firstCommitsPerFile|
	
	whereChangesOccurs := (aChurnAnalysis at: #churns ) select: [ :file | (file value at: #churnLoC) > 0 ].
	
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
	

	^ (firstCommitsPerFile sortAscending: [:c | c created_at ]) ifEmpty: nil ifNotEmpty: [ :v | v first ]  . 

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

	^ self
		  impactedFilesInFollowUpCommitsOf: aGLHCommit
		  withMaxCommits: self maxChildCommits. 
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

	glModel := GLHModel new.
	fromCommit := GLHCommit new.
	glhImporter := GitlabWithMergeRequestModelImporter new.
	onProject := GLHProject new.
	maxChildCommits := -1
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

{ #category : #visiting }
GitAnalyzer >> visitChildCommits: commits toStoreThemIn: commitsFound upto: nCommits [

	commits ifEmpty: [ ^ commitsFound ].
	nCommits = 0 ifTrue: [ ^ commitsFound ].

	commits do: [ :commit |
		commitsFound add: commit.

		self
			visitChildCommits: commit childCommits
			toStoreThemIn: commitsFound
			upto: nCommits - 1 ].

	^ commitsFound
]
