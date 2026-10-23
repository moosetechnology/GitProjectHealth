"
Recording double for GithubCommits (see my superclass).
"
Class {
	#name : #GithubCommitsRecordingMock,
	#superclass : #GithubRecordingResourceMock,
	#category : #'GitHubHealth-Model-Importer-Tests'
}

{ #category : #api }
GithubCommitsRecordingMock >> getAllForRepo: aRepoName ofOwner: anOwnerName [

	^ self record: #getAllForRepo:ofOwner: withArguments: {
			  aRepoName.
			  anOwnerName }
]

{ #category : #api }
GithubCommitsRecordingMock >> getCommit: aCommitRef ForRepo: aRepoName ofOwner: anOwnerName [

	^ self record: #getCommit:ForRepo:ofOwner: withArguments: {
			  aCommitRef.
			  aRepoName.
			  anOwnerName }
]

{ #category : #api }
GithubCommitsRecordingMock >> getForRepo: aRepoName ofOwner: anOwnerName withParms: aDictionary [

	^ self record: #getForRepo:ofOwner:withParms: withArguments: {
			  aRepoName.
			  anOwnerName.
			  aDictionary copy }
]

{ #category : #api }
GithubCommitsRecordingMock >> getLatestForRepo: aRepoName ofOwner: anOwnerName [

	^ self record: #getLatestForRepo:ofOwner: withArguments: {
			  aRepoName.
			  anOwnerName }
]
