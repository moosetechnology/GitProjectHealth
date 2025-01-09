Class {
	#name : #GLPHApiMock,
	#superclass : #GLPHApi,
	#category : #'GitLabProjectHealth-Model-Importer-Tests'
}

{ #category : #accessing }
GLPHApiMock >> mergeRequests [
	^GitlabMergeRequestsMock new
]
