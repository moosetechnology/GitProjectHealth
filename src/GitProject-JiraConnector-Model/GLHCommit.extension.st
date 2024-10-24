Extension { #name : 'GLHCommit' }

{ #category : '*GitProject-JiraConnector-Model-accessing' }
GLHCommit >> jiraIssue [
	"Relation named: #jiraIssue type: #JPIssue opposite: #commits"

	<generated>
	<FMComment: 'The jira issue associated with this commit'>
	<container>
	<FMProperty: #jiraIssue type: #JPIssue opposite: #commits>
	<package: #'GitProject-JiraConnector-Model'>
	^ self attributeAt: #jiraIssue ifAbsent: [ nil ]
]

{ #category : '*GitProject-JiraConnector-Model-accessing' }
GLHCommit >> jiraIssue: anObject [

	<generated>
	self attributeAt: #jiraIssue put: (FMMultivalueLink on: self update: #commits from: self jiraIssue to: anObject).
]
