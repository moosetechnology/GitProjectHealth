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
GLHApiMock >> users [
	^GitlabUsersMock new
]
