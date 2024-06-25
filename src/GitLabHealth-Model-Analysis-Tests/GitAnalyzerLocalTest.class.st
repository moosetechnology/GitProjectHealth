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

	glphModel := GLPHEModel new.
	gitAnalyzer := GitAnalyzer new onModel: glphModel.
	fromCommit := GLHCommit new.
	fromCommit short_id: 'testFromCommit'.
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

	self assert: gitAnalyzer analyseCommentContributions equals: 1
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

	self assert: gitAnalyzer analyseCommentContributions equals: 1
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

	self assert: gitAnalyzer analyseCommentContributions equals: 1
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

	self assert: gitAnalyzer analyseCommentContributions equals: 2
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

	self assert: gitAnalyzer analyseCommentContributions equals: 3
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

	self assert: gitAnalyzer analyseCommentContributions equals: 1
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

	self assert: gitAnalyzer analyseCommentContributions equals: 0
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

	self assert: gitAnalyzer analyseCommentContributions equals: 0
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

	self assert: gitAnalyzer analyseCommentContributions equals: 0
]
