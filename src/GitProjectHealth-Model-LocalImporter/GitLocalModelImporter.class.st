"
Based on the local path of a git repository, this project fill as possible a model
"
Class {
	#name : #GitLocalModelImporter,
	#superclass : #GitModelImporter,
	#instVars : [
		'localGitRepositoryFileReference',
		'gitRepository',
		'indexedFiles'
	],
	#category : #'GitProjectHealth-Model-LocalImporter'
}

{ #category : #'import - files' }
GitLocalModelImporter >> buildGPHFileFor: aDiskDirectoryEntry [

	| file root |
	root := (self glhModel allWithSubTypesOf: GLHFile)
		        detect: [ :f |
		        f directoryOwner isNil and: [ f name = aDiskDirectoryEntry basename ] ]
		        ifFound: [ :f | f ]
		        ifNone: [
			        file := (aDiskDirectoryEntry isDirectory
				                 ifTrue: [ GLHFileDirectory ]
				                 ifFalse: [ GLHFileBlob ]) new.
			        self glhModel add: file.
			        file name: aDiskDirectoryEntry basename ].
	(root isKindOf: GLHFileDirectory) ifTrue: [
		root files: (aDiskDirectoryEntry children collect: [ :child |
				 self buildGPHFileFor: child in: root ]) ].
	^ root
]

{ #category : #'import - files' }
GitLocalModelImporter >> buildGPHFileFor: aFileEntry in: parent [

	| modelFile |
	modelFile := parent files
		             detect: [ :childFile |
		             childFile name = aFileEntry basename ]
		             ifFound: [ :glhFile | glhFile ]
		             ifNone: [
			             | file |
			             file := (aFileEntry isDirectory
				                      ifTrue: [ GLHFileDirectory ]
				                      ifFalse: [ GLHFileBlob ]) new.
			             self glhModel add: file.
			             file name: aFileEntry basename ].

	(modelFile isKindOf: GLHFileDirectory) ifTrue: [
		modelFile files
			addAll: (aFileEntry children collect: [ :child |
					 self buildGPHFileFor: child in: modelFile ])
			keyedBy: [ :futurChild | { futurChild name } ] ].
	^ modelFile
]

{ #category : #'import - commits' }
GitLocalModelImporter >> connectDiffs: diffs inside: aGPHRepository [
	"could be refactor for a classic lazy accessor. But maybe this project can also be use for several repository. So to think about later"

	indexedFiles ifNil: [
		indexedFiles := (aGPHRepository allToScope: GLHFile)
			                collect: [ :el | el path -> el ]
			                as: Dictionary ].
	diffs do: [ :diff |
		indexedFiles
			at: diff new_path
			ifPresent: [ :gphFile |
				diff addFile: gphFile.
				"support for file renaming"
				indexedFiles at: diff old_path put: gphFile ]
			ifAbsent: [ "not supported yet" ] ]
]

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
	[glhDiff diffString: (patch patchString allButFirstLines: 2).] on: Error do: [ self flag: #'some illegal continuation byte for utf-8 encoding can appears here' ].
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

	| branches headCommit |
	headCommit := (self gitRepositoryOf: aGLHRepository) head object.
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
	(self gitRepositoryOf: aGLHRepository) resetHardTo: headCommit.

	^ branches
]

{ #category : #'import - commits' }
GitLocalModelImporter >> importCommit: aLGitCommit [

	| commit |
	commit := self glhModel newCommit
		          id: aLGitCommit name;
		          message: aLGitCommit message;
		          committed_date: aLGitCommit time asDateAndTime;
		          committer_email: aLGitCommit author email;
		          committer_name: aLGitCommit author name;
		          authored_date: aLGitCommit time asDateAndTime;
		          author_email: aLGitCommit author email;
		          author_name: aLGitCommit author name;
		          parent_ids:
			          (aLGitCommit parents collect: [ :parent | parent name ]);
		          yourself.
	self resolveCreatorOfCommit: commit.
	^ commit
]

{ #category : #'import - commits' }
GitLocalModelImporter >> importCommitsOfProject: aProject since: sinceDate until: untilDate [

	self importCommitsOfRepository: aProject repository since: sinceDate until: untilDate
]

{ #category : #'import - repositories' }
GitLocalModelImporter >> importCommitsOfRepository: aGLHRepository [

	^ self
		  importCommitsOfRepository: aGLHRepository
		  since: withCommitsSince
		  until: nil
]

{ #category : #'import - commits' }
GitLocalModelImporter >> importCommitsOfRepository: aGPHRepository since: sinceDate until: untilDate [

	| i revwalk commits |
	i := 0.
	revwalk := LGitRevwalk of: (self gitRepositoryOf: aGPHRepository).
	commits := OrderedCollection new.
	revwalk pushHead.
	[
	revwalk hasNext and: [
		commits isEmpty or: [ commits last committed_date > sinceDate ] ] ]
		whileTrue: [
			| gitCommit glhCommit |
			i := i + 1.
			gitCommit := revwalk next.
			glhCommit := self importCommit: gitCommit.
			commits add: glhCommit.
			glhCommit cacheAt: #importerOrigin put: gitCommit ].

	self chainsCommitsFrom: commits.

	self withCommitDiffs ifTrue: [
		| diffs |
		diffs := commits flatCollect: [ :commit |
			         self importDiffOfCommit: commit ].
		self withFiles ifTrue: [
			self connectDiffs: diffs inside: aGPHRepository ] ].

	^ commits
]

{ #category : #'import - diffs' }
GitLocalModelImporter >> importDiffOfCommit: commit [

	| sourceCommit parentCommit gitDiff |
	sourceCommit := commit
		                cacheAt: #importerOrigin
		                ifAbsent: [ Error signal: 'missing importer origin' ].
	gitDiff := LGitDiff of: sourceCommit repository.

	commit parentCommits
		ifNotEmpty: [
			parentCommit := commit parentCommits anyOne
				                cacheAt: #importerOrigin
				                ifAbsent: [
				                Error signal: 'missing importer origin' ].
			gitDiff := gitDiff
				           diffTree: parentCommit tree
				           toTree: sourceCommit tree ]
		ifEmpty: [
		gitDiff := gitDiff diffTree: FFIExternalObject null toTree: sourceCommit tree ].

	gitDiff diffFindSimilar.
	commit diffs: ((1 to: gitDiff numberOfDeltas) collect: [ :idx |
			 | delta patch |
			 delta := gitDiff deltas at: idx.
			 patch := gitDiff patchAt: idx.
			 self createDiffFrom: patch and: delta ]).
	"changes are added into the model during the import"
	self withDiffRanges ifTrue: [
		commit diffs do: [ :diff |
			| ranges |
			ranges := self importDiffRangesForDiff: diff ] ].

	^ commit diffs
]

{ #category : #'import - files' }
GitLocalModelImporter >> importFilesOfBranch: aGLHBranch [

	| gitBranch |
	gitRepository := self gitRepositoryOf: aGLHBranch repository.
	gitBranch := gitRepository allBranches detect: [ :branch |
		             branch shortName = aGLHBranch name ].
	gitRepository resetHardTo: gitBranch object.
	aGLHBranch files: (gitRepository workingDirectory children
	reject: [ :child | child basename = '.git' ]
	thenCollect: [ :child | self buildGPHFileFor: child ]) 
	
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

	| commits |
	self importBranchesOfRepository: aGLHRepository.
	commits := self importCommitsOfRepository: aGLHRepository.
	aGLHRepository commits addAll: commits keyedBy: [ :el | el id ]
]

{ #category : #'import - commits' }
GitLocalModelImporter >> importUserByCommit: aGLHCommit [

	| user |
	user := self userCatalogue collectUsernames
		        at: aGLHCommit author_name
		        ifAbsentPut: [
			        | glhUser |
			        glhUser := GLHUser new
				                   id: aGLHCommit author_name;
				                   username: aGLHCommit author_name;
				                   name: aGLHCommit author_name;
				                   email: aGLHCommit author_email;
				                   yourself.

			        glhUser ].
	self glhModel add: user unless: self blockOnIdEquality.
	self userCatalogue addUser: user withName: user username.
	^ user
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

{ #category : #'import - commits' }
GitLocalModelImporter >> resolveCreatorOfCommit: aGLHCommit [
	aGLHCommit commitCreator ifNil: [
		aGLHCommit commitCreator:
			(self importUserByCommit: aGLHCommit) ].

	^ aGLHCommit commitCreator
]
