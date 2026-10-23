"
Recording double for GithubUsers (see my superclass).
"
Class {
	#name : #GithubUsersRecordingMock,
	#superclass : #GithubRecordingResourceMock,
	#category : #'GitHubHealth-Model-Importer-Tests'
}

{ #category : #api }
GithubUsersRecordingMock >> getUserId: aUserId [

	^ self record: #getUserId: withArguments: { aUserId }
]

{ #category : #api }
GithubUsersRecordingMock >> getUsername: aUsername [

	^ self record: #getUsername: withArguments: { aUsername }
]
