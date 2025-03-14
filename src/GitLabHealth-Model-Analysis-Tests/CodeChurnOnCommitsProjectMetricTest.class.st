"
A CodeChurnOnCommitsProjectMetricTest is a test class for testing the behavior of CodeChurnOnCommitsProjectMetric
"
Class {
	#name : #CodeChurnOnCommitsProjectMetricTest,
	#superclass : #ProjectMetricTest,
	#instVars : [
		'commit1',
		'user',
		'commit2',
		'commit3'
	],
	#category : #'GitLabHealth-Model-Analysis-Tests'
}

{ #category : #running }
CodeChurnOnCommitsProjectMetricTest >> setUp [

	super setUp.

	user := GLHUser new
		        username: 'user1';
		        contributedProjects: { project1 }.

	commit1 := GLHCommit new
		           id: '1111111111111';
		           message: 'commit1';
		           repository: project1 repository;
		           created_at: createdAt;
		           parentCommits: {  };
		           commitCreator: user;
		           additions: 2;
		           deletions: 0;
		           diffs: { (GLHDiff new
				            new_path: 'file.txt';
				            old_path: 'file.txt';
				            diffRanges: { (GLHDiffRange new
						             originalLineRange: '-0,0';
						             newLineRange: '+1,2';
						             changes: {
								             (GLHAddition new
									              relativeIndex: 0;
									              sourceCode: '+//Welcome text').
								             (GLHAddition new
									              relativeIndex: 1;
									              sourceCode:
										              '+$("#welcome").text("Hello Customer");') }) }) }.


	commit2 := GLHCommit new
		           id: '22222222222222';
		           short_id: '22222';
		           message: 'commit2';
		           created_at: createdAt + 2 minutes;
		           repository: project1 repository;
		           parentCommits: {  };
		           commitCreator: user;
		           additions: 2;
		           deletions: 1;
		           diffs: { (GLHDiff new
				            new_path: 'file.txt';
				            old_path: 'file.txt';
				            diffRanges: { (GLHDiffRange new
						             originalLineRange: '-1,2';
						             newLineRange: '+1,3';
						             changes: {
								             (GLHLineOfCode new
									              relativeIndex: 0;
									              sourceCode: '+//Populate the welcome text').
								             (GLHDeletion new
									              relativeIndex: 1;
									              sourceCode:
										              '-$("#welcome").text("Hello Customer");').
								             (GLHAddition new
									              relativeIndex: 2;
									              sourceCode: '+var name = "Hello Customer";').
								             (GLHAddition new
									              relativeIndex: 3;
									              sourceCode: '+$("#welcome").text') }) }) }.

	commit3 := GLHCommit new
		           id: '33333333333333';
		           short_id: '3';
		           message: 'commit3';
		           created_at: createdAt + 5 minutes;
		           repository: project1 repository;
		           parentCommits: {  };
		           commitCreator: user;
		           additions: 3;
		           deletions: 2;
		           diffs: { (GLHDiff new
				            new_path: 'file.txt';
				            old_path: 'file.txt';
				            diffRanges: { (GLHDiffRange new
						             originalLineRange: '-1,3';
						             newLineRange: '+1,4';
						             changes: {
								             (GLHLineOfCode new
									              relativeIndex: 0;
									              sourceCode: '+//Populate the welcome text').
								             (GLHDeletion new
									              relativeIndex: 1;
									              sourceCode: '-var name = "Hello Customer;').
								             (GLHDeletion new
									              relativeIndex: 2;
									              sourceCode: '-$("#welcome").text').
								             (GLHAddition new
									              relativeIndex: 3;
									              sourceCode: '+var is_new = false;').
								             (GLHAddition new
									              relativeIndex: 4;
									              sourceCode:
										              '+var name = (is_new ? "Hello New Customer" : "Hello Customer")').
								             (GLHAddition new
									              relativeIndex: 5;
									              sourceCode: '+$("#welcome").text(name);') }) }) }
]

{ #category : #tests }
CodeChurnOnCommitsProjectMetricTest >> testCalculate [

	| glhImporter codeChurn result |
	glhImporter := GLPHImporterMock new.
	glhImporter commits: {
			(commit1 addChildCommit: commit2 ; yourself).
			(commit2 
			    addChildCommit: commit3;
				 addParentCommit: commit1 ;
				 yourself).
			(commit3
				 parentCommits: { commit2 };
				 yourself) }.


	codeChurn := CodeChurnOnCommitsProjectMetric new
		             project: project1;
		             glhImporter: glhImporter;
		             maxCommitWindow: 3;
		             setPeriodSince: since until: since;
		             over: Week.

	"When"
	result := codeChurn calculate.

	"Then"
	self assert: result rounded equals: 33
]

{ #category : #tests }
CodeChurnOnCommitsProjectMetricTest >> testCalculate1Commit [

	| glhImporter codeChurn result |
	glhImporter := GLPHImporterMock new.




	glhImporter commits: {
			commit1.
	}.





	codeChurn := CodeChurnOnCommitsProjectMetric new
		             project: project1 ;
		             glhImporter: glhImporter;
						 maxCommitWindow: 3;
		             setPeriodSince: since until: since;
		             over: Week.

	"When"
	result := codeChurn calculate.

	"Then"
	self assert: result equals: 0
]

{ #category : #tests }
CodeChurnOnCommitsProjectMetricTest >> testCalculate2Commits [

	| glhImporter codeChurn result |
	glhImporter := GLPHImporterMock new.




	glhImporter commits: {
			commit1.
			(commit2
				 parentCommits: { commit1 };
				 yourself) }.



	codeChurn := CodeChurnOnCommitsProjectMetric new
		             project: project1;
		             glhImporter: glhImporter;
		             setPeriodSince: since until: since;
		             over: Week.

	"When"
	result := codeChurn calculate.

	"Then"
	self assert: result rounded equals: 17
]

{ #category : #tests }
CodeChurnOnCommitsProjectMetricTest >> testCalculateCommit2And3Only [

	| glhImporter codeChurn result |
	glhImporter := GLPHImporterMock new.
	glhImporter commits: {
			(commit2
				 addChildCommit:  commit3 ;
				 yourself).
			(commit3
				 addParentCommit:  commit2 ;
				 yourself) }.
		


	codeChurn := CodeChurnOnCommitsProjectMetric new
		             project: project1;
		             glhImporter: glhImporter;
		             maxCommitWindow: 3;
		             setPeriodSince: since until: since;
		             over: Week.

	"When"
	result := codeChurn calculate.

	"Then"
	self assert: result equals: 25.0
]

{ #category : #tests }
CodeChurnOnCommitsProjectMetricTest >> testCalculateMaxCommitWindowEquals0 [

	| glhImporter codeChurn result |
	glhImporter := GLPHImporterMock new.
	glhImporter commits: {
			commit1.
			(commit2
				 parentCommits: { commit1 };
				 yourself).
			(commit3
				 parentCommits: { commit2 };
				 yourself) }.


	codeChurn := CodeChurnOnCommitsProjectMetric new
		             project: project1;
		             glhImporter: glhImporter;
						 maxCommitWindow: 0;
		             setPeriodSince: since until: since;
		             over: Week.

	"When"
	result := codeChurn calculate.

	"Then"
	self assert: result equals: 0
]

{ #category : #tests }
CodeChurnOnCommitsProjectMetricTest >> testCalculateMaxCommitWindowEquals1 [

	| glhImporter codeChurn result |
	glhImporter := GLPHImporterMock new.
	glhImporter commits: {
			commit1.
			(commit2
				 parentCommits: { commit1 };
				 yourself).
			(commit3
				 parentCommits: { commit2 };
				 yourself) }.


	codeChurn := CodeChurnOnCommitsProjectMetric new
		             project: project1;
		             glhImporter: glhImporter;
						 maxCommitWindow: 0;
		             setPeriodSince: since until: since;
		             over: Week.

	"When"
	result := codeChurn calculate.

	"Then"
	self assert: result equals: 0
]

{ #category : #tests }
CodeChurnOnCommitsProjectMetricTest >> testCalculateNoCommits [

	| glhImporter codeChurn result |
	glhImporter := GLPHImporterMock new.
	glhImporter commits: {
	}.


	codeChurn := CodeChurnOnCommitsProjectMetric new
		             project: project1 ;
		             glhImporter: glhImporter;
		             setPeriodSince: since until: since;
		             over: Week.

	"When"
	result := codeChurn calculate.

	"Then"
	self assert: result equals: 0
]
