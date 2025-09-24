Class {
	#name : #GithubApiMock,
	#superclass : #Object,
	#category : #'GitHubHealth-Model-Importer-Tests'
}

{ #category : #accessing }
GithubApiMock >> output: aString [ 
	^ self
]

{ #category : #accessing }
GithubApiMock >> users [
	^ GithubUsersMock new
]
