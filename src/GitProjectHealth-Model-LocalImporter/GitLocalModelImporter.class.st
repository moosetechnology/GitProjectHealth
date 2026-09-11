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
		        f directoryOwner isNil and: [ f name = aDiskDirectoryEntry filename ] ]
		        ifFound: [ :f | f ]
		        ifNone: [
			        file := (aDiskDirectoryEntry isBlob 
				                 ifFalse: [ GLHFileDirectory ]
				                 ifTrue: [ GLHFileBlob ]) new.
			        self glhModel add: file.
			        file name: aDiskDirectoryEntry filename ].
	(root isKindOf: GLHFileDirectory) ifTrue: [
		root files: (aDiskDirectoryEntry entries collect: [ :child |
				 self buildGPHFileFor: child in: root ]) ].
	^ root
]

{ #category : #'import - files' }
GitLocalModelImporter >> buildGPHFileFor: aFileEntry in: parent [

	| modelFile |
	modelFile := parent files
		             detect: [ :childFile |
		             childFile name = aFileEntry filename ]
		             ifFound: [ :glhFile | glhFile ]
		             ifNone: [
			             | file |
			             file := (aFileEntry isBlob
				                      ifFalse: [ GLHFileDirectory ]
				                      ifTrue: [ GLHFileBlob ]) new.
			             self glhModel add: file.
			             file name: aFileEntry filename ].

	(modelFile isKindOf: GLHFileDirectory) ifTrue: [
		modelFile files
			addAll: (aFileEntry entries collect: [ :child |
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
	"reverse order to have a smart rename history"
	(diffs asOrderedCollection sort: [ :diffA :diffB |
		 diffA commit committed_date > diffB commit committed_date ]) do: [
		:diff |
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
	[ glhDiff diffString: (patch patchString allButFirstLines: 2) ]
		on: Error
		do: [
			self flag:
				#'some illegal continuation byte for utf-8 encoding can appears here' ].
	^ glhDiff
]

{ #category : #operation }
GitLocalModelImporter >> fetchMRRemotes: repo [

	| refspecMR remote |
	"But will miss old ones https://stackoverflow.com/a/75139038/5257140"
	remote := repo allRemotes detect: [ :remote |
		          remote remoteName = 'origin' ].
	refspecMR := LGitRefSpec fromString:
		             '+refs/merge-requests/*/head:refs/remotes/origin/mr/*'.
	remote fetchSpec: refspecMR.
	remote
		fetchWithCredentials:
		(IceCredentialsProvider defaultForRemoteUrl: remote url)
		refSpec: refspecMR
]

{ #category : #accessing }
GitLocalModelImporter >> gitCommitOf: aGLHCommit [

	^ aGLHCommit cacheAt: #importerOrigin ifAbsentPut: [
		  LGitCommit
			  of: (self gitRepositoryOf: aGLHCommit repository)
			  fromHexString: aGLHCommit id ]
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
		  | val |
		  val := aGLHRepository
			  cacheAt: #localImporterReference
			  ifAbsentPut: [ self tryClone: aGLHRepository project ].
		  val ifNil: [
			  Error signal: 'Local GLHRepository without importer reference' ].

		  (LGitRepository on:
				   (aGLHRepository cacheAt: #localImporterReference ifAbsent: [Error signal: 'Local GLHRepository without importer reference']))
			  init;
			  yourself ]
]

{ #category : #'import - branches' }
GitLocalModelImporter >> importBranchesOfRepository: aGLHRepository [

	| branches headCommit addedBranches |
	headCommit := (self gitRepositoryOf: aGLHRepository) head object.
	branches := (self gitRepositoryOf: aGLHRepository) allBranches
		            collect: [ :branch |
			            GLHBranch new
				            name: branch gitName;
				            sha: branch annotatedCommit id hexString;
				            yourself ].
	addedBranches := aGLHRepository branches
		                 addAll: branches
		                 keyedBy: [ :el | el name ].
	self glhModel addAll: branches keyedBy: [ :el |
		{
			el name.
			el repository } ].

	self withFiles ifTrue: [
		addedBranches do: [ :branch | self importFilesOfBranch: branch ] ].
	(self gitRepositoryOf: aGLHRepository) resetHardTo: headCommit.

	^ addedBranches
]

{ #category : #'import - commits' }
GitLocalModelImporter >> importCommit: aLGitCommit [

	| commit gitDiff stats parentTree |
	(self glhModel allWithType: GLHCommit) asOrderedCollection
		detect: [ :comm | comm id = aLGitCommit name ]
		ifFound: [ :comm | ^ comm ].
	commit := self glhModel newCommit
		          id: aLGitCommit name;
		          title:
			          (aLGitCommit message lines ifEmpty: [ { '' } ]) first;
		          message: aLGitCommit message;
		          created_at: aLGitCommit time asDateAndTime;
		          committed_date: aLGitCommit time asDateAndTime;
		          committer_email: aLGitCommit author email;
		          committer_name: aLGitCommit author name;
		          authored_date: aLGitCommit time asDateAndTime;
		          author_email: aLGitCommit author email;
		          author_name: aLGitCommit author name;
		          parent_ids:
			          (aLGitCommit parents collect: [ :parent | parent name ]);
		          yourself.
	gitDiff := LGitDiff of: aLGitCommit repository.
	parentTree := commit parent_ids
		              ifNotEmpty: [ :parentIds |
			              (LGitCommit
				               of: aLGitCommit repository
				               fromHexString: parentIds anyOne) tree ]
		              ifEmpty: [ FFIExternalObject null ].
	gitDiff diffTree: parentTree toTree: aLGitCommit tree.
	stats := LGitDiffStats of: aLGitCommit repository.
	gitDiff diff_get_stats: stats diff: gitDiff.
	commit additions: (stats diff_stats_insertions: stats).
	commit deletions: (stats diff_stats_deletions: stats).
	self resolveCreatorOfCommit: commit.
	^ commit
]

{ #category : #'import - commits' }
GitLocalModelImporter >> importCommit: aCommitID ofProject: aGLHProject [

	| gitCommit commit |
	gitCommit := LGitCommit
		             of: (self gitRepositoryOf: aGLHProject repository)
		             fromHexString: aCommitID.

	commit := self importCommit: gitCommit.
	^ aGLHProject repository commits add: commit keyedBy: [ :el | el id ]
]

{ #category : #'import - commits' }
GitLocalModelImporter >> importCommitsOfProject: aProject since: sinceDate until: untilDate [

	^ self
		  importCommitsOfRepository: aProject repository
		  since: sinceDate
		  until: untilDate
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

	| revwalk commits alreadyExploredCommit toReturn |
	commits := Set new.
	"to stop when already explored"
	alreadyExploredCommit := aGPHRepository commits
		                         collect: [ :commit | commit id ]
		                         as: Set.
	(self gitRepositoryOf: aGPHRepository) allBranches
		select: #isLocal
		thenDo: [ :branch |
			| gphBranch shouldContinue currentBranchCommit |
			gphBranch := (glhModel allWithType: GLHBranch)
				             detect: [ :gBranch | branch gitName = gBranch name ]
				             ifNone: [ nil ].

			revwalk := LGitRevwalk of: (self gitRepositoryOf: aGPHRepository).
			revwalk pushReference: branch.
			currentBranchCommit := nil.
			shouldContinue := true.
			[
			| glhCommit gitCommit |
			gitCommit := revwalk next.
			glhCommit := self importCommit: gitCommit.

			currentBranchCommit := glhCommit.
			commits add: glhCommit.
			alreadyExploredCommit add: glhCommit id.
			glhCommit cacheAt: #importerOrigin put: gitCommit.

			gphBranch commits ifEmpty: [ gphBranch addCommit: glhCommit ] ]
				doWhileTrue: [
					revwalk hasNext and: [
						currentBranchCommit committed_date > sinceDate and: [
							(currentBranchCommit parent_ids anySatisfy: [ :id |
								 alreadyExploredCommit includes: id ]) not ] ] ].

			self chainsCommitsFrom: commits ].

	self withCommitDiffs ifTrue: [
		| diffs |
		diffs := commits flatCollect: [ :commit |
			         self importDiffOfCommit: commit ].
		self withFiles ifTrue: [
			self connectDiffs: diffs inside: aGPHRepository ] ].
	aGPHRepository commits addAll: commits keyedBy: [ :el | el id ].
	toReturn := self glhModel allWithType: GLHCommit.
	sinceDate ifNotNil: [
		toReturn := toReturn select: [ :c | c committed_date > sinceDate ] ].
	untilDate ifNotNil: [
		toReturn := toReturn select: [ :c | c committed_date < untilDate ] ].
	^ toReturn
]

{ #category : #'import - diffs' }
GitLocalModelImporter >> importDiffOfCommit: commit [

	| sourceCommit parentCommit gitDiff |
	sourceCommit := self gitCommitOf: commit.
	gitDiff := LGitDiff of: sourceCommit repository.

	commit parentCommits
		ifNotEmpty: [
			parentCommit := self gitCommitOf: commit parentCommits anyOne.
			gitDiff := gitDiff
				           diffTree: parentCommit tree
				           toTree: sourceCommit tree ]
		ifEmpty: [
			gitDiff := gitDiff
				           diffTree: FFIExternalObject null
				           toTree: sourceCommit tree ].

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
		             branch gitName = aGLHBranch name ].


	gitRepository resetHardTo: gitBranch object.
	aGLHBranch files: (gitBranch object tree entries collect: [ :entry |
			 self buildGPHFileFor: entry ])
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

	^ self importLatestCommitsOfProject 
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

{ #category : #operation }
GitLocalModelImporter >> tryClone: aGLHProject [

	| url clonePath gitUrl repo cloneOptions |
	aGLHProject ifNil: [ ^ nil ].
	url := aGLHProject web_url ifNil: [ ^ nil ].
	clonePath := FileSystem workingDirectory / 'msr' / aGLHProject name.
	clonePath exists ifTrue: [ ^ clonePath ].
	clonePath ensureCreateDirectory.
	gitUrl := url , '.git'.
	repo := LGitRepository on: clonePath.
	cloneOptions := repo cloneOptionsStructureClass
		                withCredentialsProvider:
		                (IceCredentialsProvider defaultForRemoteUrl: url).
	repo clone: gitUrl options: cloneOptions.
	self fetchMRRemotes: repo.
	^ clonePath
]
