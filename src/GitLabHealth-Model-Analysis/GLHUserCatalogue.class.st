Class {
	#name : #GLHUserCatalogue,
	#superclass : #Dictionary,
	#instVars : [
		'users'
	],
	#category : #'GitLabHealth-Model-Analysis'
}

{ #category : #'as yet unclassified' }
GLHUserCatalogue class >> scrapeContributedProjectsForCommitAuthorsRelatedToUser: aGLHUser [
	"get all "

	| maxProjects itsProjects |
	maxProjects := 10.

	GLHModelImporter current withCommitDiffs: false.
	itsProjects := aGLHUser contributedProjects ifEmpty: [
		               GLHModelImporter current
			               importContributedProjectsOfUser: aGLHUser ].

	itsProjects
		collect: [ :project |
			GLHModelImporter current importAndLoadLatestsCommitsOfProject:
				project ]
		from: 1
		to: (itsProjects size min: maxProjects).

	^ (aGLHUser commits collect: [ :commit | commit author_name ]) asSet
]

{ #category : #adding }
GLHUserCatalogue >> addUser: aGLHUser [

	self add: (User2CommitAuthor new user: aGLHUser)
]

{ #category : #adding }
GLHUserCatalogue >> addUser: aGLHUser withName: name [

	self at: aGLHUser ifPresent: [ :names | names add: name  ] ifAbsentPut: [
		Set new
			add: name;
			yourself ]
]

{ #category : #'as yet unclassified' }
GLHUserCatalogue >> collectUsernames [
	|username2User|
	self ifEmpty: [ ^ {  } ]. 
	
	username2User := OrderedCollection new.
	
	self associationsDo: [ :assoc |
			|user|
			user := assoc key.
			assoc value do: [ :username |
				username2User add: (username -> user).
				 ].
		 ]. 
	
	^ username2User. 

]

{ #category : #completion }
GLHUserCatalogue >> completeAuthorNameOfUser: aGLHUser with: authorName [

	| assoc |
	assoc := self associationAt: aGLHUser.
	assoc value add: authorName
]

{ #category : #completion }
GLHUserCatalogue >> completeAuthorNameOfUser: aGLHUser withAll: authorNames [

	| assoc |
	assoc := self associationAt: aGLHUser.
	assoc value addAll: authorNames
]

{ #category : #initialization }
GLHUserCatalogue >> initialize [

	
]

{ #category : #'as yet unclassified' }
GLHUserCatalogue >> scrapeAuthorNameForAllUsers [
	|currentUsers|
	currentUsers := self keys.
	currentUsers do: [ :key |
		(self at: key) addAll: (GLHUserCatalogue
				 scrapeContributedProjectsForCommitAuthorsRelatedToUser: key) ]
]

{ #category : #'as yet unclassified' }
GLHUserCatalogue >> scrapeAuthorNameForUser: aGLHUser [ 
	| assoc |
	assoc := self associationAt: aGLHUser.
	assoc value addAll: (GLHUserCatalogue scrapeContributedProjectsForCommitAuthorsRelatedToUser: aGLHUser).
]

{ #category : #completion }
GLHUserCatalogue >> searchModelForAuthorNamesOfUser: aGLHUser [ 
	|assoc|
	assoc := self associationAt: aGLHUser.
	assoc value addAll: (aGLHUser commits collect: [:c | c author_name]).
	
]
