Class {
	#name : #User2CommitAuthor,
	#superclass : #Association,
	#instVars : [
		'user',
		'commitAuthors'
	],
	#category : #'GitLabHealth-Model-Analysis'
}

{ #category : #adding }
User2CommitAuthor >> addAllCommitAuthors: commitAuthorsList [ 
	^ self value addAll: commitAuthorsList
]

{ #category : #adding }
User2CommitAuthor >> addCommitAuhtor: aCommitAuthor [
	^ self value add: aCommitAuthor. 
]

{ #category : #accessing }
User2CommitAuthor >> commitAuthors [
	^ value
]

{ #category : #accessing }
User2CommitAuthor >> commitAuthors: values [

	self value: values. 
]

{ #category : #initialization }
User2CommitAuthor >> initialize [
	self value: Set new. 
	
]

{ #category : #accessing }
User2CommitAuthor >> user [
	^ key
]

{ #category : #accessing }
User2CommitAuthor >> user: aGLHUser [
	self key: aGLHUser 
]
