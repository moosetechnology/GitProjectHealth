Extension { #name : #GLHMergeRequest }

{ #category : #'*GitProject-JiraConnector-Model-accessing' }
GLHMergeRequest >> jiraIssue [
	"Relation named: #jiraIssue type: #JPIssue opposite: #mergeRequest"

	<generated>
	<FMComment: 'the jira issue associated to this merge request'>
	<container>
	<FMProperty: #jiraIssue type: #JPIssue opposite: #mergeRequest>
	<package: #'GitProject-JiraConnector-Model'>
	^ self attributeAt: #jiraIssue ifAbsent: [ nil ]
]

{ #category : #'*GitProject-JiraConnector-Model-accessing' }
GLHMergeRequest >> jiraIssue: anObject [

	<generated>
	(self attributeAt: #jiraIssue ifAbsentPut: [nil]) == anObject ifTrue: [ ^ anObject ].
	anObject ifNil: [ | otherSide |
		otherSide :=  self jiraIssue.
		self attributeAt: #jiraIssue put: anObject.
		otherSide mergeRequest: nil ]
	ifNotNil: [ 
		self attributeAt: #jiraIssue put: anObject.
		anObject mergeRequest: self ]
]
