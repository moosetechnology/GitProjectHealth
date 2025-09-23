Class {
	#name : #GLHApiMock,
	#superclass : #Object,
	#category : #'GitLabHealth-Model-Importer-Tests'
}

{ #category : #accessing }
GLHApiMock >> branches [
	^ GitlabBranchesMock new .
]

{ #category : #accessing }
GLHApiMock >> commits [
	^GitlabCommitsMock new.
]

{ #category : #accessing }
GLHApiMock >> groups [
	^ GitlabGroupMock new.
]

{ #category : #accessing }
GLHApiMock >> jobs [ 
	^ GitlabJobsMock new
]

{ #category : #accessing }
GLHApiMock >> mergeRequests [

	^ GitlabMergeRequestsMock new
]

{ #category : #accessing }
GLHApiMock >> notes [
	^ GitlabNotesMock new.
]

{ #category : #accessing }
GLHApiMock >> output: aString [ 
	^ self 
]

{ #category : #accessing }
GLHApiMock >> pipelines [
	^ GitlabPipelinesMock new
]

{ #category : #accessing }
GLHApiMock >> projects [
	^ GitlabProjectsMock new .
]

{ #category : #accessing }
GLHApiMock >> releases [
	^ GitlabReleasesMock new.
]

{ #category : #accessing }
GLHApiMock >> repositories [

	^ GitlabRepositoryMock new
]

{ #category : #accessing }
GLHApiMock >> tags [
	^GitlabTagMock new 
]

{ #category : #accessing }
GLHApiMock >> users [
	^GitlabUsersMock new
]
