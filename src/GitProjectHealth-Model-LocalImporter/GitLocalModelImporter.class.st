"
Based on the local path of a git repository, this project fill as possible a model
"
Class {
	#name : #GitLocalModelImporter,
	#superclass : #GitModelImporter,
	#instVars : [
		'localGitRepositoryFileReference',
		'gitRepository'
	],
	#category : #'GitProjectHealth-Model-LocalImporter'
}

{ #category : #'import - commits' }
GitLocalModelImporter >> gitRepository [

	^ (LGitRepository on: localGitRepositoryFileReference)
		  init;
		  yourself
]

{ #category : #importCommit }
GitLocalModelImporter >> importCommit: aLGitCommit [

	self model add: (GLHCommit new
			 id: aLGitCommit name;
			 message: aLGitCommit message;
			 committed_date: aLGitCommit time asDateAndTime;
			 committer_email: aLGitCommit author email;
			 committer_name: aLGitCommit author name yourself)
]

{ #category : #'import - commits' }
GitLocalModelImporter >> importLatestCommitsOfProject [

	| revwalk i |
	i := 0.
	revwalk := (LGitRevwalk of: self gitRepository).
	revwalk pushHead.
	[revwalk hasNext and: [i < 50]] whileTrue: [ 
		self importCommit: revwalk next
	 ]
]

{ #category : #'import - commits' }
GitLocalModelImporter >> importLatestCommitsOfProject: aGLHProject [
	"this importer load based on inner state local git repository"

	self importLatestCommitsOfProject 
]

{ #category : #accessing }
GitLocalModelImporter >> localGitRepository: aFileReference [

	localGitRepositoryFileReference := aFileReference
]
