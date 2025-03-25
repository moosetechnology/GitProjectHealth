"
A GPCGitToFamixConnectorTest is a test class for testing the behavior of GPCGitToFamixConnector
"
Class {
	#name : #GPCGitToFamixConnectorTest,
	#superclass : #TestCase,
	#instVars : [
		'famixModel',
		'gitModel',
		'diff',
		'javaClass',
		'javaIndexedFileAnchor',
		'connector',
		'gitProject',
		'gitRepository'
	],
	#category : #'GitProject-FamixConnector-Tests'
}

{ #category : #running }
GPCGitToFamixConnectorTest >> setUp [

	super setUp.
	connector := GPCGitToFamixConnector new.
	famixModel := FamixJavaModel new.
	gitModel := GLHModel new.
	gitProject := gitModel newProject.
	gitRepository := gitModel newRepository.
	gitProject repository: gitRepository.
	connector famixModel: famixModel.
	connector glhProject: gitProject
]

{ #category : #tests }
GPCGitToFamixConnectorTest >> testConnectDiffToAnonymousJavaClass [

	| pathUnderTests commit javaMethod javaAnonymousClass javaAnonymousClassIndexedFileAnchor |
	"Have to be ignore"
	pathUnderTests := 'a/b/c.java'.

	commit := gitModel newCommit.
	commit repository: gitRepository.
	diff := gitModel newDiff.
	diff new_path: pathUnderTests.
	commit diffs add: diff.

	javaClass := famixModel newClass.
	javaIndexedFileAnchor := famixModel newIndexedFileAnchor.
	javaIndexedFileAnchor fileName: '../../dede/../' , pathUnderTests.
	javaClass sourceAnchor: javaIndexedFileAnchor.
	javaMethod := famixModel newMethod.
	javaClass addMethod: javaMethod.
	javaAnonymousClass := famixModel newClass.
	javaAnonymousClassIndexedFileAnchor := famixModel
		                                       newIndexedFileAnchor.
	javaAnonymousClassIndexedFileAnchor fileName:
		'../../dede/../' , pathUnderTests.
	javaAnonymousClass sourceAnchor: javaAnonymousClassIndexedFileAnchor.

	javaMethod addType: javaAnonymousClass.
	connector connect.
	self assert: diff onSourceEntity equals: javaClass.
	self assert: javaClass appliedDiffs anyOne equals: diff.
	self assert: javaAnonymousClass appliedDiffs size equals: 0
]

{ #category : #tests }
GPCGitToFamixConnectorTest >> testConnectDiffToJavaClass [

	| pathUnderTests commit |
	pathUnderTests := 'a/b/c.java'.

	commit := gitModel newCommit.
	commit repository: gitRepository.
	diff := gitModel newDiff.
	diff new_path: pathUnderTests.
	commit diffs add: diff.

	javaClass := famixModel newClass.
	javaIndexedFileAnchor := famixModel newIndexedFileAnchor.
	javaIndexedFileAnchor fileName: '../../dede/../' , pathUnderTests.
	javaClass sourceAnchor: javaIndexedFileAnchor.
	connector connect.
	self assert: diff onSourceEntity  equals: javaClass.
	self assert: javaClass appliedDiffs anyOne equals: diff
]

{ #category : #tests }
GPCGitToFamixConnectorTest >> testConnectDiffToJavaEnum [

	| pathUnderTests commit |
	pathUnderTests := 'a/b/c.java'.

	commit := gitModel newCommit.
	commit repository: gitRepository.
	diff := gitModel newDiff.
	diff new_path: pathUnderTests.
	commit diffs add: diff.

	javaClass := famixModel newEnum name: 'EnumJava'; yourself.
	javaIndexedFileAnchor := famixModel newIndexedFileAnchor.
	javaIndexedFileAnchor fileName: '../../dede/../' , pathUnderTests.
	javaClass sourceAnchor: javaIndexedFileAnchor.
	connector connect.
	self assert: diff onSourceEntity equals: javaClass.
	self assert: javaClass appliedDiffs anyOne equals: diff
]

{ #category : #tests }
GPCGitToFamixConnectorTest >> testConnectDiffToJavaInterface [

	| pathUnderTests commit |
	pathUnderTests := 'a/b/c.java'.

	commit := gitModel newCommit.
	commit repository: gitRepository.
	diff := gitModel newDiff.
	diff new_path: pathUnderTests.
	commit diffs add: diff.

	javaClass := famixModel newInterface.
	javaIndexedFileAnchor := famixModel newIndexedFileAnchor.
	javaIndexedFileAnchor fileName: '../../dede/../' , pathUnderTests.
	javaClass sourceAnchor: javaIndexedFileAnchor.
	connector connect.
	self assert: diff onSourceEntity  equals: javaClass.
	self assert: javaClass appliedDiffs anyOne equals: diff
]
