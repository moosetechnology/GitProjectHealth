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
	
	|maxProjects itsProjects|
	maxProjects := 5. 

	GLHModelImporter current withCommitDiffs: false. 
	itsProjects := aGLHUser contributedProjects ifEmpty: [(GLHModelImporter current importContributedProjectsOfUser: aGLHUser)].
	
	itsProjects collect:  [ :project |
		GLHModelImporter current importAndLoadLatestsCommitsOfProject: project. 
		 ] from: 1 to: (itsProjects size > maxProjects ifTrue: [ maxProjects ] ifFalse: [ itsProjects size ] ) . 
	
	^ (aGLHUser commits collect: [ :commit | commit author_name ]) asSet.
	
	

]

{ #category : #adding }
GLHUserCatalogue >> addUser: aGLHUser [

	self add: (User2CommitAuthor new user: aGLHUser)
]

{ #category : #completion }
GLHUserCatalogue >> completeAuthorNameOfUser: aGLHUser with: authorNames [

	| assoc |
	assoc := self associationAt: aGLHUser.
	assoc value addAll:
		authorNames
]

{ #category : #initialization }
GLHUserCatalogue >> initialize [

	
]

{ #category : #'as yet unclassified' }
GLHUserCatalogue >> scrapeAuthorNameForAllUsers [

	self associations do: [ :assoc |
		|  aGLHUser|
	aGLHUser := assoc key.
	assoc value addAll: (GLHUserCatalogue
			 scrapeContributedProjectsForCommitAuthorsRelatedToUser: aGLHUser)
		 ]
	
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
