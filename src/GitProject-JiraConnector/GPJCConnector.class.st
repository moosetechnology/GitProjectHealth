"
I connect a `JPModel` with a `GLHModel` using the relation define in the `GPJCModel` metamodel.

You can use me with

```st
GPJCConnector new
	gpModel: aGpModel; ""or glh model""
	jiraModel: aJiraModel;
	connect
```

I also ensure to not repeat relations (you can execute me multiple times safely)
"
Class {
	#name : #GPJCConnector,
	#superclass : #Object,
	#instVars : [
		'jiraModel',
		'gpModel'
	],
	#category : #'GitProject-JiraConnector'
}

{ #category : #accessing }
GPJCConnector >> connect [
	(self gpModel allWithType: GLHCommit) do: [ :commit |
		self connectCommit: commit ].
	(self gpModel allWithType: GLHMergeRequest) do: [ :mergeRequest |
		self connectMergeRequest: mergeRequest ]
]

{ #category : #accessing }
GPJCConnector >> connectCommit: commit [

	(jiraModel allWithType: JPIssue)
		detect: [ :issue | commit message includesSubstring: issue key ]
		ifFound: [ :issue | commit jiraIssue: issue ]
]

{ #category : #accessing }
GPJCConnector >> connectMergeRequest: mergeRequest [

	(jiraModel allWithType: JPIssue)
		detect: [ :issue | mergeRequest title includesSubstring: issue key ]
		ifFound: [ :issue | mergeRequest jiraIssue: issue ]
]

{ #category : #accessing }
GPJCConnector >> gpModel [

	^ gpModel
]

{ #category : #accessing }
GPJCConnector >> gpModel: anObject [

	gpModel := anObject
]

{ #category : #accessing }
GPJCConnector >> jiraKeyFromCommitMessage: aString [

	| result |
	result := aString allRegexMatches: '\b[A-Z1-9]+-\d+\b'.
	result isEmpty ifTrue: [ ^ nil ].
	^ result anyOne
]

{ #category : #accessing }
GPJCConnector >> jiraModel [

	^ jiraModel
]

{ #category : #accessing }
GPJCConnector >> jiraModel: anObject [

	jiraModel := anObject
]
