"
I am a GithubApiMock whose commits, pullRequests and users resources are PERSISTENT recording doubles (unlike my superclass that creates a new resource on each send). Tests configure each resource responder and inspect its calls. Other resources (branches, actions, organizations) fall back on the stateless mocks of my superclass.
"
Class {
	#name : #GithubApiRecordingMock,
	#superclass : #GithubApiMock,
	#instVars : [
		'commits',
		'pullRequests',
		'users'
	],
	#category : #'GitHubHealth-Model-Importer-Tests'
}

{ #category : #accessing }
GithubApiRecordingMock >> commits [

	^ commits
]

{ #category : #initialization }
GithubApiRecordingMock >> initialize [

	super initialize.
	commits := GithubCommitsRecordingMock new.
	pullRequests := GithubPullRequestsRecordingMock new.
	users := GithubUsersRecordingMock new
]

{ #category : #accessing }
GithubApiRecordingMock >> pullRequests [

	^ pullRequests
]

{ #category : #accessing }
GithubApiRecordingMock >> users [

	^ users
]
