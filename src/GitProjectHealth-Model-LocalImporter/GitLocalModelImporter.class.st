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

{ #category : #'private - diffs' }
GitLocalModelImporter >> createDiffFrom: patch and: delta [

	| glhDiff |
	glhDiff := self glhModel newDiff.
	glhDiff new_path: delta newFile path.
	glhDiff old_path: delta oldFile path.
	delta status = LGitDeltaTypeEnum git_delta_renamed ifTrue: [
		glhDiff renamed_file: true ].
	delta status = LGitDeltaTypeEnum git_delta_added ifTrue: [
		glhDiff new_file: true ].
	delta status = LGitDeltaTypeEnum git_delta_deleted ifTrue: [
		glhDiff deleted_file: true ].
	glhDiff diffString: (patch patchString allButFirstLines: 2).
	^ glhDiff
]

{ #category : #'import - commits' }
GitLocalModelImporter >> gitRepository [

	^ (LGitRepository on: localGitRepositoryFileReference)
		  init;
		  yourself
]

{ #category : #accessing }
GitLocalModelImporter >> gitRepositoryOf: aGLHRepository [

	^ aGLHRepository cacheAt: #localImporterGitReference ifAbsentPut: [
		(LGitRepository on: (aGLHRepository
					  cacheAt: #localImporterReference
					  ifAbsent: [
						  Error signal: 'Local GLHRepository without importer reference' ]))
			init;
			yourself ]
]

{ #category : #'import - branches' }
GitLocalModelImporter >> importBranchesOfRepository: aGLHRepository [

	| branches |
	branches := (self gitRepositoryOf: aGLHRepository) allBranches
		            select: [ :branch | branch isBranch ]
		            thenCollect: [ :branch |
			            GLHBranch new
				            name: branch shortName;
				            sha: branch targetId hexString;
				            yourself ].
	aGLHRepository branches addAll: branches.
	self glhModel addAll: branches keyedBy: [ :el |
		{
			el name.
			el repository } ].

	self withFiles ifTrue: [
		branches do: [ :branch | self importFilesOfBranch: branch ] ].


	^ branches
]

{ #category : #'import - commits' }
GitLocalModelImporter >> importCommit: aLGitCommit [

	^ self glhModel newCommit
		  id: aLGitCommit name;
		  message: aLGitCommit message;
		  committed_date: aLGitCommit time asDateAndTime;
		  committer_email: aLGitCommit author email;
		  committer_name: aLGitCommit author name;
		  parent_ids:
			  (aLGitCommit parents collect: [ :parent | parent name ]);
		  yourself
]

{ #category : #'import - commits' }
GitLocalModelImporter >> importCommitsOfProject: aProject since: sinceDate until: untilDate [

	| i revwalk commits |
	i := 0.
	revwalk := LGitRevwalk of: self gitRepository.
	commits := OrderedCollection new.
	revwalk pushHead.
	[
	revwalk hasNext and: [
		commits isEmpty or: [
			commits last committed_date > sinceDate ] ] ] whileTrue: [
		| gitCommit glhCommit |
		i := i + 1.
		gitCommit := revwalk next.
		glhCommit := self importCommit: gitCommit.
		commits add: glhCommit.
		glhCommit cacheAt: #importerOrigin put: gitCommit ].

	self chainsCommitsFrom: commits.

	self withCommitDiffs ifTrue: [
		commits do: [ :commit | self importDiffOfCommit: commit ] ].


	^ commits
]

{ #category : #'import - diffs' }
GitLocalModelImporter >> importDiffOfCommit: commit [

	| sourceCommit targetCommit gitDiff |
	commit parentCommits ifNotEmpty: [
		sourceCommit := commit
			                cacheAt: #importerOrigin
			                ifAbsent: [
			                Error signal: 'missing importer origin' ].
		targetCommit := commit parentCommits anyOne
			                cacheAt: #importerOrigin
			                ifAbsent: [
			                Error signal: 'missing importer origin' ].
		gitDiff := sourceCommit tree diffTo: targetCommit tree.
		commit diffs: ((1 to: gitDiff numberOfDeltas) collect: [ :idx |
				 | delta patch |
				 delta := gitDiff deltas at: idx.
				 patch := gitDiff patchAt: idx.
				 self createDiffFrom: patch and: delta ]) ].

	"changes are added into the model during the import"
	commit diffs do: [ :diff | self importDiffRangesForDiff: diff ].
	^ commit diffs
]

{ #category : #'import - files' }
GitLocalModelImporter >> importFilesOfBranch: aGLHBranch [
	
	^ self halt
]

{ #category : #'import - commits' }
GitLocalModelImporter >> importLatestCommitsOfProject [

	| revwalk i commits |
	i := 0.
	revwalk := LGitRevwalk of: self gitRepository.
	commits := OrderedCollection new.
	revwalk pushHead.
	[ revwalk hasNext and: [ i < 50 ] ] whileTrue: [
		| gitCommit glhCommit |
		i := i + 1.
		gitCommit := revwalk next.
		glhCommit := self importCommit: gitCommit.
		commits add: glhCommit.
		glhCommit cacheAt: #importerOrigin put: gitCommit ].

	self chainsCommitsFrom: commits.

	self withCommitDiffs ifTrue: [
		commits do: [ :commit | self importDiffOfCommit: commit ] ]
]

{ #category : #'import - commits' }
GitLocalModelImporter >> importLatestCommitsOfProject: aGLHProject [
	"this importer load based on inner state local git repository"

	self importLatestCommitsOfProject 
]

{ #category : #'import - repositories' }
GitLocalModelImporter >> importRepository: aGLHRepository [

	self importBranchesOfRepository: aGLHRepository.
]

{ #category : #initialization }
GitLocalModelImporter >> initialize [

	super initialize.
	withCommitDiffs := true
]

{ #category : #accessing }
GitLocalModelImporter >> localGitRepository: aFileReference [

	localGitRepositoryFileReference := aFileReference
]
