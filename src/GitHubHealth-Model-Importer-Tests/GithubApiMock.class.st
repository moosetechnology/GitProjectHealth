Class {
	#name : #GithubApiMock,
	#superclass : #Object,
	#category : #'GitHubHealth-Model-Importer-Tests'
}

{ #category : #actions }
GithubApiMock >> actions [
	^ GithubActionsMock new 
]

{ #category : #accessing }
GithubApiMock >> branches [
	^ GithubBranchesMock new
]

{ #category : #accessing }
GithubApiMock >> commits [
	^ GithubCommitsMock new. 
]

{ #category : #organizations }
GithubApiMock >> organizations [
	^ GithubOrganizationsMock new
]

{ #category : #accessing }
GithubApiMock >> output: aString [ 
	^ self
]

{ #category : #accessing }
GithubApiMock >> users [
	^ GithubUsersMock new
]
