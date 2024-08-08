Class {
	#name : #GLHUserCatalogue,
	#superclass : #Dictionary,
	#instVars : [
		'users'
	],
	#category : #'GitLabHealth-Model-Analysis'
}

{ #category : #adding }
GLHUserCatalogue >> addUser: aGLHUser [

	self add: (User2CommitAuthor new user: aGLHUser)
]

{ #category : #completion }
GLHUserCatalogue >> completeCommitAuthorForUser: aGLHUser [ 
	|assoc|
	assoc := self associationAt: aGLHUser.
	assoc value addAll: (aGLHUser commits collect: [:c | c author_name]).
	
]

{ #category : #initialization }
GLHUserCatalogue >> initialize [

	
]
