Class {
	#name : #GitAnalyzerLocalTest,
	#superclass : #TestCase,
	#instVars : [
		'glphModel',
		'glphApi',
		'glhImporter',
		'projects',
		'gitAnalyzer',
		'fromCommit'
	],
	#category : 'GitLabHealth-Model-Analysis-Tests'
}

{ #category : #running }
GitAnalyzerLocalTest >> setUp [

	super setUp.

	glphModel := GLHModel new.
	gitAnalyzer := GitAnalyzer new onModel: glphModel.
	fromCommit := GLHCommit new.
	fromCommit short_id: 'testFromCommit'.
	fromCommit created_at: ('3 August 2021' asDate).
	glphModel add: fromCommit.
	
	gitAnalyzer fromCommit: fromCommit.
]

{ #category : #test }
GitAnalyzerLocalTest >> testAnalyseCommentContributionsJavaComment [

	| diffA diffARange addition |
	diffA := GLHDiff new.
	diffA new_path: 'new/test/path.txt'.
	fromCommit addDiff: diffA. 
	glphModel add: diffA.
	"Set DiffA ranges"
	diffARange := glphModel newDiffRange.
	diffA diffRanges: { diffARange }.

	addition := glphModel newAddition.
	diffARange addChange: addition.
	addition sourceCode: '+	// hello world'.

	self assert: gitAnalyzer analyseCommentContribution equals: 1
]

{ #category : #test }
GitAnalyzerLocalTest >> testAnalyseCommentContributionsJavaContinueComment [

	| diffA diffARange addition |
	diffA := GLHDiff new.
	diffA new_path: 'new/test/path.txt'.
	fromCommit addDiff: diffA. 
	glphModel add: diffA.
	"Set DiffA ranges"
	diffARange := glphModel newDiffRange.
	diffA diffRanges: { diffARange }.

	addition := glphModel newAddition.
	diffARange addChange: addition.
	addition sourceCode: '+	* hello world'.

	self assert: gitAnalyzer analyseCommentContribution equals: 1
]

{ #category : #test }
GitAnalyzerLocalTest >> testAnalyseCommentContributionsJavaStopComment [

	| diffA diffARange addition |
	diffA := GLHDiff new.
	diffA new_path: 'new/test/path.txt'.
	fromCommit addDiff: diffA. 
	glphModel add: diffA.
	"Set DiffA ranges"
	diffARange := glphModel newDiffRange.
	diffA diffRanges: { diffARange }.

	addition := glphModel newAddition.
	diffARange addChange: addition.
	addition sourceCode: '+	*/ hello world'.

	self assert: gitAnalyzer analyseCommentContribution equals: 1
]

{ #category : #test }
GitAnalyzerLocalTest >> testAnalyseCommentContributionsMixedMultipleComments [

	| diffA diffARange addition additionB additionC |
	diffA := GLHDiff new.
	diffA new_path: 'new/test/path.txt'.
	fromCommit addDiff: diffA.
	glphModel add: diffA.
	"Set DiffA ranges"
	diffARange := glphModel newDiffRange.
	diffA diffRanges: { diffARange }.

	addition := glphModel newAddition.
	diffARange addChange: addition.
	addition sourceCode: '+	// hello world'.

	additionB := glphModel newDeletion.
	diffARange addChange: additionB.
	additionB sourceCode: '-	// hello world'.

	additionC := glphModel newAddition.
	diffARange addChange: additionC.
	additionC sourceCode: '+	// hello world'.

	self assert: gitAnalyzer analyseCommentContribution equals: 2
]

{ #category : #test }
GitAnalyzerLocalTest >> testAnalyseCommentContributionsMultipleComments [

	| diffA diffARange addition additionB additionC |
	diffA := GLHDiff new.
	diffA new_path: 'new/test/path.txt'.
	fromCommit addDiff: diffA.
	glphModel add: diffA.
	"Set DiffA ranges"
	diffARange := glphModel newDiffRange.
	diffA diffRanges: { diffARange }.

	addition := glphModel newAddition.
	diffARange addChange: addition.
	addition sourceCode: '+	// hello world'.

	additionB := glphModel newAddition.
	diffARange addChange: additionB.
	additionB sourceCode: '+	// hello world'.

	additionC := glphModel newAddition.
	diffARange addChange: additionC.
	additionC sourceCode: '+	// hello world'.

	self assert: gitAnalyzer analyseCommentContribution equals: 3
]

{ #category : #test }
GitAnalyzerLocalTest >> testAnalyseCommentContributionsPythonComment [

	| diffA diffARange addition |
	diffA := GLHDiff new.
	diffA new_path: 'new/test/path.txt'.
	fromCommit addDiff: diffA. 
	glphModel add: diffA.
	"Set DiffA ranges"
	diffARange := glphModel newDiffRange.
	diffA diffRanges: { diffARange }.

	addition := glphModel newAddition.
	diffARange addChange: addition.
	addition sourceCode: '+	*/ hello world'.

	self assert: gitAnalyzer analyseCommentContribution equals: 1
]

{ #category : #test }
GitAnalyzerLocalTest >> testAnalyseCommentContributionsShouldBe0 [

	| diffA diffARange addition |
	diffA := GLHDiff new.
	diffA new_path: 'new/test/path.txt'.
	fromCommit addDiff: diffA.
	glphModel add: diffA.
	"Set DiffA ranges"
	diffARange := glphModel newDiffRange.
	diffA diffRanges: { diffARange }.

	addition := glphModel newAddition.
	diffARange addChange: addition.
	addition sourceCode: '+	hello world'.

	self assert: gitAnalyzer analyseCommentContribution equals: 0
]

{ #category : #test }
GitAnalyzerLocalTest >> testAnalyseCommentInSomeAroundCode [

	| diffA diffARange addition |
	diffA := GLHDiff new.
	diffA new_path: 'new/test/path.txt'.
	fromCommit addDiff: diffA. 
	glphModel add: diffA.
	"Set DiffA ranges"
	diffARange := glphModel newDiffRange.
	diffA diffRanges: { diffARange }.

	addition := glphModel newLineOfCode.
	diffARange addChange: addition.
	addition sourceCode: '// hello world'.

	self assert: gitAnalyzer analyseCommentContribution equals: 0
]

{ #category : #test }
GitAnalyzerLocalTest >> testAnalyseCommentNotAnAddition [

	| diffA diffARange addition |
	diffA := GLHDiff new.
	diffA new_path: 'new/test/path.txt'.
	fromCommit addDiff: diffA. 
	glphModel add: diffA.
	"Set DiffA ranges"
	diffARange := glphModel newDiffRange.
	diffA diffRanges: { diffARange }.

	addition := glphModel newDeletion.
	diffARange addChange: addition.
	addition sourceCode: '-	// hello world'.

	self assert: gitAnalyzer analyseCommentContribution equals: 0
]

{ #category : #test }
GitAnalyzerLocalTest >> testArrangeCommitsByDate [

	| commitA2 commitA3 commitB result |
	commitA2 := GLHCommit new.
	commitA2 short_id: 'testFromCommit2'.
	commitA2 created_at: ('3 August 2021' asDate).
	glphModel add: commitA2.

	commitA3 := GLHCommit new.
	commitA3 short_id: 'testFromCommit3'.
	commitA3 created_at: ('3 August 2021' asDate).
	glphModel add: commitA3.

	commitB := GLHCommit new.
	commitB short_id: 'testFromCommitB'.
	commitB created_at: ('4 August 2021' asDate).	
	glphModel add: commitB.

	result := gitAnalyzer arrangeCommitsByDate: {
			          fromCommit.
			          commitA2.
			          commitA3.
			          commitB }.
	
	self assert: result size equals: 2.
	self assert: (result at: '3 August 2021') size equals: 3.
	self assert: (result at: '4 August 2021') size equals: 1.
]
