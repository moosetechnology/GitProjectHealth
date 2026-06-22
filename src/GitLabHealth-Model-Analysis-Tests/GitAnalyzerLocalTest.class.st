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
	#category : #'GitLabHealth-Model-Analysis-Tests'
}

{ #category : #running }
GitAnalyzerLocalTest >> setUp [

	super setUp.

	glphModel := GLHModel new.
	gitAnalyzer := GitAnalyzer new onModel: glphModel.
	fromCommit := GLHCommit new.
	fromCommit short_id: 'testFromCommit'.
	"3 august 2021"
	fromCommit created_at: (Date newDay: 3 month: 8 year: 2021).
	glphModel add: fromCommit.

	gitAnalyzer fromCommit: fromCommit
]

{ #category : #tests }
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

{ #category : #tests }
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

{ #category : #tests }
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

{ #category : #tests }
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

{ #category : #tests }
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

{ #category : #tests }
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

{ #category : #tests }
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

{ #category : #tests }
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

{ #category : #tests }
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

{ #category : #tests }
GitAnalyzerLocalTest >> testArrangeCommitsByDate [

	| commitA2 commitA3 commitB result threeAugust fourAugust |
	threeAugust := Date newDay: 3 month: 8 year: 2021.
	fourAugust := Date newDay: 4 month: 8 year: 2021.

	commitA2 := GLHCommit new.
	commitA2 short_id: 'testFromCommit2'.
	commitA2 created_at: threeAugust.
	glphModel add: commitA2.

	commitA3 := GLHCommit new.
	commitA3 short_id: 'testFromCommit3'.
	commitA3 created_at: threeAugust.
	glphModel add: commitA3.

	commitB := GLHCommit new.
	commitB short_id: 'testFromCommitB'.
	commitB created_at: fourAugust.
	glphModel add: commitB.

	result := gitAnalyzer arrangeCommitsByDate: {
			          fromCommit.
			          commitA2.
			          commitA3.
			          commitB }.

	self assert: result size equals: 2.
	self assert: (result at: threeAugust) size equals: 3.
	self assert: (result at: fourAugust) size equals: 1
]
