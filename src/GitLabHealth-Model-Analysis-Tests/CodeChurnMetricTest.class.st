"
A CodeChurnMetricTest is a test class for testing the behavior of CodeChurnMetric
"
Class {
	#name : #CodeChurnMetricTest,
	#superclass : #UserMetricTest,
	#instVars : [
		'commit1',
		'commits2',
		'commit2',
		'commit3'
	],
	#category : #'GitLabHealth-Model-Analysis-Tests'
}

{ #category : #running }
CodeChurnMetricTest >> setUp [

	super setUp .  
	commit1 := GLHCommit new
		           id: 1;
		           repository: project1 repository;
		           created_at: createdAt + 2 minutes;
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
		           id: 2;
		           created_at: createdAt;
		           repository: project1 repository;
		           parentCommits: { commit1 };
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
		           id: 3;
		           created_at: createdAt;
		           repository: project1 repository;
		           parentCommits: { commit2 };
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
CodeChurnMetricTest >> testCalculate [

	| glhImporter codeChurn result |
	glhImporter := GLPHImporterMock new.
	glhImporter commits: {
			commit1.
			commit2.
			commit3 }.


	codeChurn := CodeChurnMetric new
		             user: user;
		             glhImporter: glhImporter;
		             setPeriodSince: since until: since;
		             over: Week.

	"When"
	result := codeChurn calculate.

	"Then"
	self assert: result equals: 25.0
]
