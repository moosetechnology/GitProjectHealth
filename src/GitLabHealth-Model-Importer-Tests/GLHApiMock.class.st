Class {
	#name : #GLHApiMock,
	#superclass : #Object,
	#category : #'GitLabHealth-Model-Importer-Tests'
}

{ #category : #accessing }
GLHApiMock >> commits [
	^GitlabCommitsMock new.
]

{ #category : #accessing }
GLHApiMock >> mergeRequests [

	^ GitlabMergeRequestsMock new
]

{ #category : #accessing }
GLHApiMock >> output: aString [ 
	^ self 
]

{ #category : #accessing }
GLHApiMock >> repositories [

	^ GitlabRepositoryMock new
]

{ #category : #accessing }
GLHApiMock >> users [
	^GitlabUsersMock new
]
