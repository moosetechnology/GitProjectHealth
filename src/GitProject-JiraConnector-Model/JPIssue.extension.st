Extension { #name : #JPIssue }

{ #category : #'*GitProject-JiraConnector-Model-accessing' }
JPIssue >> commits [
	"Relation named: #commits type: #GLHCommit opposite: #jiraIssue"

	<generated>
	<FMComment: 'The commits associated with this jira issue'>
	<derived>
	<FMProperty: #commits type: #GLHCommit opposite: #jiraIssue>
	<package: #'GitProject-JiraConnector-Model'>
	^ self attributeAt: #commits ifAbsentPut: [ FMMultivalueLink on: self opposite: #jiraIssue: ]
]

{ #category : #'*GitProject-JiraConnector-Model-accessing' }
JPIssue >> commits: anObject [

	<generated>
	self commits value: anObject
]

{ #category : #'*GitProject-JiraConnector-Model-accessing' }
JPIssue >> mergeRequest [
	"Relation named: #mergeRequest type: #GLPHEMergeRequest opposite: #jiraIssue"

	<generated>
	<FMComment: 'A merge request in Git associated to this issue'>
	<derived>
	<FMProperty: #mergeRequest type: #GLPHEMergeRequest opposite: #jiraIssue>
	<package: #'GitProject-JiraConnector-Model'>
	^ self attributeAt: #mergeRequest ifAbsent: [ nil ]
]

{ #category : #'*GitProject-JiraConnector-Model-accessing' }
JPIssue >> mergeRequest: anObject [

	<generated>
	(self attributeAt: #mergeRequest ifAbsentPut: [nil]) == anObject ifTrue: [ ^ anObject ].
	anObject ifNil: [ | otherSide |
		otherSide :=  self mergeRequest.
		self attributeAt: #mergeRequest put: anObject.
		otherSide jiraIssue: nil ]
	ifNotNil: [ 
		self attributeAt: #mergeRequest put: anObject.
		anObject jiraIssue: self ]
]
