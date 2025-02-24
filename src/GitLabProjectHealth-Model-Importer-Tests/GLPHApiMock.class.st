Class {
	#name : #GLPHApiMock,
	#superclass : #Object,
	#category : #'GitLabProjectHealth-Model-Importer-Tests'
}

{ #category : #accessing }
GLPHApiMock >> mergeRequests [
	^GitlabMergeRequestsMock new
]
