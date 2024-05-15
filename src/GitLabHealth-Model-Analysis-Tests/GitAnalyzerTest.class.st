"
A CodeChurnAnalyzerTest is a test class for testing the behavior of CodeChurnAnalyzer
"
Class {
	#name : #GitAnalyzerTest,
	#superclass : #TestCase,
	#instVars : [
		'glphModel',
		'glphApi',
		'glhImporter',
		'projects',
		'res'
	],
	#category : #'GitLabHealth-Model-Analysis-Tests'
}

{ #category : #running }
GitAnalyzerTest >> setUp [

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

{ #category : #test }
GitAnalyzerTest >> testAnalyseAmandment [

	| myCommits mondayCommit tuesdayCommit wednesdayCommit |
	glhImporter withCommitDiffs: true.

	"commit chain 
	mondayCommit -> tuesdayCommit -> wednesdayCommit
	"

	wednesdayCommit := glhImporter
		                   importCommitOfProject: projects first id
		                   withId:
		                   'f298ec312f81032b611a890f993d98096ab3bbc1'.
		
	mondayCommit := glhImporter
		                   importCommitOfProject: projects first id
		                   withId:
		                   '8a6f665118e6fcfa468d7cce1a7e944ba65812ab'.
		
	tuesdayCommit  := glhImporter
		                   importCommitOfProject: projects first id
		                   withId:
		                   '2c7308c727560dd425ef78f9a95ca7650d164bed'.

	myCommits := { mondayCommit . tuesdayCommit . wednesdayCommit } asSet .

	glhImporter chainsCommitsFrom: myCommits.

	myCommits do: [ :c | glhImporter completeImportedCommit: c ].

	mondayCommit := myCommits detect: [ :c |
		                c id = '8a6f665118e6fcfa468d7cce1a7e944ba65812ab' ].

	res := GitAnalyzer new
		                 fromCommit: mondayCommit;
		                 glhImporter: glhImporter;
		                 onModel: glphModel;
		                 analyseAmandment.



	self assert: res = tuesdayCommit equals: true. 
]

{ #category : #tests }
GitAnalyzerTest >> testChurnMetric [

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

	res := GitAnalyzer new
		fromCommit: mondayCommit;
		glhImporter: glhImporter;
		onModel: glphModel;
		analyseChurn.

	self assert:  (res at:#churns) first value  equals: 5/7
]
