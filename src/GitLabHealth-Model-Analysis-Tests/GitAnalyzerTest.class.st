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
		'gitAnalyzer'
	],
	#category : #'GitLabHealth-Model-Analysis-Tests'
}

{ #category : #running }
GitAnalyzerTest >> setUp [

	| since |
	super setUp.

	"Put here a common initialization logic for tests"
	glphModel := GLHModel new.

	glphApi := GitlabApi new
		           privateToken: '';
		           hostUrl: 'https://gitlab.com/api/v4';
		           output: 'json'.

	since := Date today - 2 day.

	glhImporter := GitlabWithMergeRequestModelImporter new
		               repoApi: glphApi;
		               glhModel: glphModel;
		               withFiles: false;
		               withCommitDiffs: true.

	glhImporter importProject: 57841283.
	projects := glhImporter glhModel allWithType: GLHProject.


	glhImporter
		importCommitsOfProject: projects first
		since: since asDate
		until: nil.

	gitAnalyzer := GitAnalyzer new
		               glhImporter: glhImporter;
		               onModel: glphModel
]

{ #category : #tests }
GitAnalyzerTest >> testAnalyseAmandment [

	| myCommits res mondayCommit tuesdayCommit wednesdayCommit |
	glhImporter withCommitDiffs: true.

	"commit chain 
	mondayCommit -> tuesdayCommit -> wednesdayCommit
	"
	wednesdayCommit := glhImporter
		                   importCommitOfProject: projects first
		                   withId:
		                   'f298ec312f81032b611a890f993d98096ab3bbc1'.

	mondayCommit := glhImporter
		                importCommitOfProject: projects first
		                withId: '8a6f665118e6fcfa468d7cce1a7e944ba65812ab'.

	tuesdayCommit := glhImporter
		                 importCommitOfProject: projects first
		                 withId: '2c7308c727560dd425ef78f9a95ca7650d164bed'.

	myCommits := {
		             mondayCommit.
		             tuesdayCommit.
		             wednesdayCommit } asSet.

	glhImporter chainsCommitsFrom: myCommits.

	myCommits do: [ :c | glhImporter completeImportedCommit: c ].

	mondayCommit := myCommits detect: [ :c |
		                c id = '8a6f665118e6fcfa468d7cce1a7e944ba65812ab' ].

	res := GitAnalyzer new
		       fromCommit: mondayCommit;
		       glhImporter: glhImporter;
		       onModel: glphModel;
		       maxChildCommit: 5;
		       analyseDelayUntilFirstChurn.


	self assert: res equals: tuesdayCommit
]

{ #category : #tests }
GitAnalyzerTest >> testAnalyseCommitFrequencySinceUntil [

	| res from since |
	from := '13 May 2024'.
	since := '16 May 2024'.

	res := gitAnalyzer
		       onProject: projects first;
		       analyseCommitFrequencySince: from asDate until: since asDate.

	self assert: (res at: from) size equals: 1.
	self assert: (res at: '14 May 2024') size equals: 4
]

{ #category : #tests }
GitAnalyzerTest >> testAnalyseMergeResquestValidation [

	| mergeResquest res |
	glhImporter importMergeRequests: projects anyOne.
	mergeResquest := (glhImporter glhModel allWithType: GLHMergeRequest)
		                 detect: [ :mr | mr iid = 1 ].


	res := gitAnalyzer analyseMergeResquestValidation: mergeResquest.


	self
		assert: (res at: #merged_at) - (res at: #created_at)
		equals: (res at: #duration)
]

{ #category : #tests }
GitAnalyzerTest >> testChurnMetric [

	| myCommits res wednesdayCommit mondayCommit tuesdayCommit codeJs churn4CodeJs |
	glhImporter withCommitDiffs: true.

	"commit chain: mondayCommit -> tuesdayCommit -> wednesdayCommit "
	wednesdayCommit := glhImporter
		                   importCommitOfProject: projects first
		                   withId:
		                   'f298ec312f81032b611a890f993d98096ab3bbc1'.

	mondayCommit := glhImporter
		                importCommitOfProject: projects first
		                withId: '8a6f665118e6fcfa468d7cce1a7e944ba65812ab'.

	tuesdayCommit := glhImporter
		                 importCommitOfProject: projects first
		                 withId: '2c7308c727560dd425ef78f9a95ca7650d164bed'.

	myCommits := {
		             mondayCommit.
		             tuesdayCommit.
		             wednesdayCommit } asSet.

	glhImporter chainsCommitsFrom: myCommits.

	myCommits do: [ :c | glhImporter completeImportedCommit: c ].


	mondayCommit := myCommits detect: [ :c |
		                c id = '8a6f665118e6fcfa468d7cce1a7e944ba65812ab' ].

	res := GitAnalyzer new
		       fromCommit: mondayCommit;
		       glhImporter: glhImporter;
		       onModel: glphModel;
		       maxChildCommit: 3;
		       analyseChurn.

	codeJs := (res at: #churns) first.
	churn4CodeJs := codeJs value. 

	self assert: (churn4CodeJs at: #churnLoC) equals: 3 .
	self assert: (churn4CodeJs at: #churnFromInitialCommitLines) equals: 2 .
	self assert: (churn4CodeJs at: #churnFromCommitCreatorOnly ) equals: 2. 
	self assert: (res at: #totalContribution) equals: 7. 
	
]
