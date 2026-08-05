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

	^ self glhModel add: (GLHCommit new
			   id: aLGitCommit name;
			   message: aLGitCommit message;
			   committed_date: aLGitCommit time asDateAndTime;
			   committer_email: aLGitCommit author email;
			   committer_name: aLGitCommit author name;
			   parent_ids:
				   (aLGitCommit parents collect: [ :parent | parent name ]);
			   yourself)
]

{ #category : #'import - commits' }
GitLocalModelImporter >> importDiffOfCommit: commit [
	self halt.
]

{ #category : #'import - commits' }
GitLocalModelImporter >> importLatestCommitsOfProject [

	| revwalk i commits |
	i := 0.
	revwalk := LGitRevwalk of: self gitRepository.
	commits := OrderedCollection new.
	revwalk pushHead.
	[ revwalk hasNext and: [ i < 50 ] ] whileTrue: [
		| gitCommit |
		i := i + 1.
		gitCommit := revwalk next.
		commits add: (self importCommit: gitCommit) ].

	self chainsCommitsFrom: commits

	"self withCommitDiffs ifTrue: [
		commits do: [ :commit |
			revwalk pushCommit: commit id.
			self halt.
			self importDiffOfCommit: commit ] ]"
]

{ #category : #'import - commits' }
GitLocalModelImporter >> importLatestCommitsOfProject: aGLHProject [
	"this importer load based on inner state local git repository"

	self importLatestCommitsOfProject 
]

{ #category : #'import - commits' }
GitLocalModelImporter >> initialize [

	super initialize.
	withCommitDiffs := true
]

{ #category : #accessing }
GitLocalModelImporter >> localGitRepository: aFileReference [

	localGitRepositoryFileReference := aFileReference
]
