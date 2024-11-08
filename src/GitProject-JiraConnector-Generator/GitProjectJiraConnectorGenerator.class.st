Class {
	#name : 'GitProjectJiraConnectorGenerator',
	#superclass : 'FamixMetamodelGenerator',
	#instVars : [
		'glhMergeRequest',
		'glhCommit',
		'jiraIssue'
	],
	#category : 'GitProject-JiraConnector-Generator',
	#package : 'GitProject-JiraConnector-Generator'
}

{ #category : 'accessing' }
GitProjectJiraConnectorGenerator class >> packageName [

	^ #'GitProject-JiraConnector-Model'
]

{ #category : 'accessing' }
GitProjectJiraConnectorGenerator class >> prefix [

	^ #GPJC
]

{ #category : 'accessing' }
GitProjectJiraConnectorGenerator class >> submetamodels [

	^ {
		  GLHMetamodelGenerator.
		  JPMetamodelGenerator }
]

{ #category : 'definition' }
GitProjectJiraConnectorGenerator >> defineClasses [

	super defineClasses.
	glhMergeRequest := self
		                   remoteEntity: #MergeRequest
		                   withPrefix: #GLH.
	glhCommit := self remoteEntity: #Commit withPrefix: #GLH.
	jiraIssue := self remoteEntity: #Issue withPrefix: #JP
]

{ #category : 'definition' }
GitProjectJiraConnectorGenerator >> defineRelations [

	super defineRelations.
	((glhMergeRequest property: #jiraIssue) comment:
		 'the jira issue associated to this merge request')
	-<> ((jiraIssue property: #mergeRequest) comment:
			 'A merge request in Git associated to this issue').
	((glhCommit property: #jiraIssue) comment:
		 'The jira issue associated with this commit')
	*-<> ((jiraIssue property: #commits) comment:
			 'The commits associated with this jira issue')
]
