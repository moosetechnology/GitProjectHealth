"
A CodeChurnAnalyzerTest is a test class for testing the behavior of CodeChurnAnalyzer
"
Class {
	#name : #CodeChurnAnalyzerTest,
	#superclass : #TestCase,
	#instVars : [
		'glphModel',
		'glphApi',
		'glhImporter',
		'projects'
	],
	#category : #'GitLabHealth-Model-Analysis-Tests'
}

{ #category : #running }
CodeChurnAnalyzerTest >> setUp [

	| since |
	super setUp.

	"Put here a common initialization logic for tests"
	glphModel := GLPHEModel new.

	glphApi := GLPHApi new
		           privateToken: '';
		           baseAPIUrl: 'https://gitlab.com/api/v4';
		           yourself.

	since := Date today - 2 day.

	glhImporter := GLPHModelImporter new
		               glhApi: glphApi;
		               glhModel: glphModel;
		               withFiles: false;
		               withCommitsSince: 0 day;
		               withCommitDiffs: true.
		
		glhImporter importProject:  57841283.
		projects := (glhImporter glhModel allWithType: GLHProject).


glhImporter importCommitsOProject: projects first since: (since asDate ) until: nil.
		
	
]

{ #category : #tests }
CodeChurnAnalyzerTest >> testChurnMetric [

	| myCommits res wednesdayCommit mondayCommit|
	glhImporter withCommitDiffs: true.
	
	wednesdayCommit := glhImporter importCommitOfProject: projects first id withId:  'f298ec312f81032b611a890f993d98096ab3bbc1'.
	
	myCommits := (glhImporter
		             importParentCommitsOfCommit:
		             wednesdayCommit
		             forOnly: 2) asSet.
	myCommits add: wednesdayCommit.	
		
	glhImporter chainsCommitsFrom: myCommits asSet.

	myCommits do: [ :c | glhImporter completeImportedCommit: c ].

	mondayCommit := myCommits detect: [ :c | c id = '8a6f665118e6fcfa468d7cce1a7e944ba65812ab' ].

	res := CodeChurnAnalyzer new
		fromCommit: mondayCommit;
		glhImporter: glhImporter;
		onModel: glphModel;
		analyseChurn.

	self assert:  (res at:#churns) first value  equals: 5/7
]
