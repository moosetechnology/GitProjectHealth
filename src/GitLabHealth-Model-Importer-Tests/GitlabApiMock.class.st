Class {
	#name : #GitlabApiMock,
	#superclass : #Object,
	#category : #'GitLabHealth-Model-Importer-Tests'
}

{ #category : #accessing }
GitlabApiMock >> branches [
	^ GitlabBranchesMock new .
]

{ #category : #accessing }
GitlabApiMock >> commits [
	^GitlabCommitsMock new.
]

{ #category : #accessing }
GitlabApiMock >> groups [
	^ GitlabGroupMock new.
]

{ #category : #accessing }
GitlabApiMock >> jobs [ 
	^ GitlabJobsMock new
]

{ #category : #accessing }
GitlabApiMock >> mergeRequests [

	^ GitlabMergeRequestsMock new
]

{ #category : #accessing }
GitlabApiMock >> notes [
	^ GitlabNotesMock new.
]

{ #category : #accessing }
GitlabApiMock >> output: aString [ 
	^ self 
]

{ #category : #accessing }
GitlabApiMock >> pipelines [
	^ GitlabPipelinesMock new
]

{ #category : #accessing }
GitlabApiMock >> projects [
	^ GitlabProjectsMock new .
]

{ #category : #accessing }
GitlabApiMock >> releases [
	^ GitlabReleasesMock new.
]

{ #category : #accessing }
GitlabApiMock >> repositories [

	^ GitlabRepositoryMock new
]

{ #category : #accessing }
GitlabApiMock >> tags [
	^GitlabTagMock new 
]

{ #category : #accessing }
GitlabApiMock >> users [
	^GitlabUsersMock new
]
