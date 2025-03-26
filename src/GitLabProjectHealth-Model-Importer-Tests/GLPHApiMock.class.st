Class {
	#name : #GLPHApiMock,
	#superclass : #Object,
	#category : #'GitLabProjectHealth-Model-Importer-Tests'
}

{ #category : #accessing }
GLPHApiMock >> mergeRequests [
	^GitlabMergeRequestsMock new
]

{ #category : #accessing }
GLPHApiMock >> output: aString [ 
	^ self.
]
