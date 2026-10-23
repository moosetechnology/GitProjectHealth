"
Recording double for GithubPullRequests (see my superclass).
"
Class {
	#name : #GithubPullRequestsRecordingMock,
	#superclass : #GithubRecordingResourceMock,
	#category : #'GitHubHealth-Model-Importer-Tests'
}

{ #category : #api }
GithubPullRequestsRecordingMock >> getAllForRepo: aRepoName ofOwner: anOwnerName [

	^ self record: #getAllForRepo:ofOwner: withArguments: {
			  aRepoName.
			  anOwnerName }
]

{ #category : #api }
GithubPullRequestsRecordingMock >> getCommitsOfPull: aPullNumber ForRepo: aRepoName ofOwner: anOwnerName [

	^ self record: #getCommitsOfPull:ForRepo:ofOwner: withArguments: {
			  aPullNumber.
			  aRepoName.
			  anOwnerName }
]

{ #category : #api }
GithubPullRequestsRecordingMock >> getForRepo: aRepoName ofOwner: anOwnerName withParms: aDictionary [

	^ self record: #getForRepo:ofOwner:withParms: withArguments: {
			  aRepoName.
			  anOwnerName.
			  aDictionary copy }
]

{ #category : #api }
GithubPullRequestsRecordingMock >> getLatestForRepo: aRepoName ofOwner: anOwnerName [

	^ self record: #getLatestForRepo:ofOwner: withArguments: {
			  aRepoName.
			  anOwnerName }
]

{ #category : #api }
GithubPullRequestsRecordingMock >> getPull: aPullNumber ForRepo: aRepoName ofOwner: anOwnerName [

	^ self record: #getPull:ForRepo:ofOwner: withArguments: {
			  aPullNumber.
			  aRepoName.
			  anOwnerName }
]
