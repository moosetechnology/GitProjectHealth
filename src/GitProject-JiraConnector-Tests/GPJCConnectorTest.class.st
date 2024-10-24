"
A GPJCConnectorTest is a test class for testing the behavior of GPJCConnector
"
Class {
	#name : 'GPJCConnectorTest',
	#superclass : 'TestCase',
	#instVars : [
		'connector',
		'gitProject',
		'jiraModel'
	],
	#category : 'GitProject-JiraConnector-Tests',
	#package : 'GitProject-JiraConnector-Tests'
}

{ #category : 'running' }
GPJCConnectorTest >> setUp [

	super setUp.
	connector := GPJCConnector new.
	gitProject := GLHModel new.
	jiraModel := JPModel new.
	connector jiraModel: jiraModel.
	connector gpModel: gitProject
]

{ #category : 'test' }
GPJCConnectorTest >> testConnectCommit [

	| issue commit |
	issue := jiraModel newIssue.
	issue key: 'HELLO-WORLD'.

	commit := gitProject newCommit.
	commit message: 'I am a commit for [HELLO-WORLD]'.

	connector connect.
	self assert: issue commits anyOne equals: commit.
	self assert: commit jiraIssue equals: issue
]

{ #category : 'test' }
GPJCConnectorTest >> testConnectCommitDoesNotExist [

	| issue commit |
	issue := jiraModel newIssue.
	issue key: 'HELLO-WORLD-'.

	commit := gitProject newCommit.
	commit message: 'I am a commit for [HELLO-WORLD]'.

	connector connect.
	self assert: issue commits isEmpty.
	self assert: commit jiraIssue equals: nil
]

{ #category : 'test' }
GPJCConnectorTest >> testConnectMergeRequest [

	| issue mergeRequest |
	issue := jiraModel newIssue.
	issue key: 'HELLO-WORLD'.

	mergeRequest := gitProject newMergeRequest.
	mergeRequest title: 'I am a merge request for [HELLO-WORLD]'.

	connector connect.
	self assert: issue mergeRequest equals: mergeRequest.
	self assert: mergeRequest jiraIssue equals: issue
]

{ #category : 'test' }
GPJCConnectorTest >> testConnectMergeRequestDoesNotExist [

	| issue mergeRequest |
	issue := jiraModel newIssue.
	issue key: 'HELLO-WORLD-'.

	mergeRequest := gitProject newMergeRequest.
	mergeRequest title: 'I am a merge request for [HELLO-WORLD]'.

	connector connect.
	self assert: issue mergeRequest equals: nil.
	self assert: mergeRequest jiraIssue equals: nil
]

{ #category : 'test' }
GPJCConnectorTest >> testConnectSeveralCommit [

	| issue commit commit2 commit3 |
	issue := jiraModel newIssue.
	issue key: 'HELLO-WORLD'.

	commit := gitProject newCommit.
	commit message: 'I am a commit for [HELLO-WORLD]'.
	commit2 := gitProject newCommit.
	commit2 message: 'I am a HELLO-WORLD commit for'.
	commit3 := gitProject newCommit.
	commit3 message: '[HELLO-WORLD] I am a commit for'.

	connector connect.
	self assert: issue commits size equals: 3.
	self assert: (issue commits includesAll: {
				 commit.
				 commit2.
				 commit3 }).
	self assert: commit jiraIssue equals: issue.
	self assert: commit2 jiraIssue equals: issue.
	self assert: commit3 jiraIssue equals: issue
]
