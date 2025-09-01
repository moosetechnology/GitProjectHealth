"
A GPJCConnectorTest is a test class for testing the behavior of GPJCConnector
"
Class {
	#name : #GPJCConnectorTest,
	#superclass : #TestCase,
	#instVars : [
		'connector',
		'gitProject',
		'jiraModel'
	],
	#category : #'GitProject-JiraConnector-Tests'
}

{ #category : #running }
GPJCConnectorTest >> setUp [

	super setUp.
	connector := GPJCConnector new.
	gitProject := GLHModel new.
	jiraModel := JPModel new.
	connector jiraModel: jiraModel.
	connector gpModel: gitProject
]

{ #category : #test }
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

{ #category : #test }
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

{ #category : #tests }
GPJCConnectorTest >> testConnectCommits [

	| issue commit issue2 commit2 |
	issue := jiraModel newIssue.
	issue key: 'HELLO-WORLD'.

	commit := gitProject newCommit.
	commit message: 'I am a commit for [HELLO-WORLD]'.

	issue2 := jiraModel newIssue.
	issue2 key: 'HELLO-WORLD2'.

	commit2 := gitProject newCommit.
	commit2 message: 'I am a commit for [HELLO-WORLD2]'.

	connector connectCommits: { commit }.
	self assert: issue commits anyOne equals: commit.
	self assert: commit jiraIssue equals: issue.

	self assert: issue2 commits isEmpty.
	self assert: commit2 jiraIssue equals: nil
]

{ #category : #test }
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

{ #category : #test }
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

{ #category : #tests }
GPJCConnectorTest >> testConnectMergeRequests [

	| issue mergeRequest issue2 mergeRequest2 |
	issue := jiraModel newIssue.
	issue key: 'HELLO-WORLD'.

	mergeRequest := gitProject newMergeRequest.
	mergeRequest title: 'I am a merge request for [HELLO-WORLD]'.
	
	issue2 := jiraModel newIssue.
	issue2 key: 'HELLO-WORLD2'.

	mergeRequest2 := gitProject newMergeRequest.
	mergeRequest2 title: 'I am a merge request for [HELLO-WORLD2]'.

	connector connectMergeRequests: { mergeRequest }.
	self assert: issue mergeRequest equals: mergeRequest.
	self assert: mergeRequest jiraIssue equals: issue.
	
	self assert: issue2 mergeRequest equals: nil.
	self assert: mergeRequest2 jiraIssue equals: nil
]

{ #category : #test }
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

{ #category : #tests }
GPJCConnectorTest >> testJiraKeyFromCommitMessage [

	self assert: (connector jiraKeyFromCommitMessage: 'AV1-4974 hello') equals: 'AV1-4974'
]

{ #category : #tests }
GPJCConnectorTest >> testJiraKeyFromCommitMessageWithBrackets [

	self assert: (connector jiraKeyFromCommitMessage: '[AV1-4974] hello') equals: 'AV1-4974'
]

{ #category : #tests }
GPJCConnectorTest >> testJiraKeyFromCommitMessageWithBracketsAtTheEnd [

	self assert: (connector jiraKeyFromCommitMessage: 'hello [AV1-4974]') equals: 'AV1-4974'
]

{ #category : #tests }
GPJCConnectorTest >> testJiraKeyFromCommitMessageWithBracketsInTheMiddle [

	self assert: (connector jiraKeyFromCommitMessage: 'hello [AV1-4974] middle') equals: 'AV1-4974'
]

{ #category : #tests }
GPJCConnectorTest >> testJiraKeyFromCommitMessageWithBranchName [

	self assert: (connector jiraKeyFromCommitMessage: 'Merge branch ''feature/AV1-4897-3'' into ''develop''') equals: 'AV1-4897'
]

{ #category : #tests }
GPJCConnectorTest >> testJiraKeyFromWrongCommitMessage [

	self assert: (connector jiraKeyFromCommitMessage: 'hello') equals: nil
]
