"
This tests uses the test repository under GPHBridge (the files of the repository)
"
Class {
	#name : #GitLocalModelImporterTest,
	#superclass : #TestCase,
	#instVars : [
		'localImporter',
		'model',
		'repository'
	],
	#category : #'GitProjectHealth-Model-LocalImporter-Tests'
}

{ #category : #accessing }
GitLocalModelImporterTest class >> resources [

	^ Array with: GitLocalModelImporterWithTestResource
]

{ #category : #helpers }
GitLocalModelImporterTest >> assertModelHasCommits: commitTuples branches: branchTuples userIds: userIds [
	"commitTuples: #( #( id #( parent ids ) #( sorted child ids ) creatorUsername ) ... ).
	branchTuples: #( #( name #( sorted commit ids ) ) ... )."

	self
		assert: self modelCommitIds
		equals: (commitTuples collect: [ :tuple | tuple first ]) sorted.
	commitTuples do: [ :tuple |
			| commit |
			commit := (model allWithType: GLHCommit) detect: [ :each |
				          each id = tuple first ].
			self assert: commit parent_ids asArray equals: tuple second.
			self
				assert:
				(commit childCommits collect: [ :child | child id ]) asArray
					sorted
				equals: tuple third.
			self assert: commit commitCreator username equals: tuple fourth ].
	self
		assert:
			((model allWithType: GLHBranch) collect: [ :branch | branch name ])
				asArray sorted
		equals: (branchTuples collect: [ :tuple | tuple first ]) sorted.
	branchTuples do: [ :tuple |
			| branch |
			branch := (model allWithType: GLHBranch) detect: [ :each |
				          each name = tuple first ].
			self
				assert:
				(branch commits collect: [ :commit | commit id ]) asArray sorted
				equals: tuple second ].
	self
		assert:
		((model allWithType: GLHUser) collect: [ :user | user id ] as: Set)
		equals: userIds asSet
]

{ #category : #helpers }
GitLocalModelImporterTest >> childIdsByCommitId [

	^ (model allWithType: GLHCommit)
		  inject: Dictionary new
		  into: [ :dictionary :commit |
				  dictionary
					  at: commit id
					  put:
						  (commit childCommits collect: [ :child | child id ] as: Set);
					  yourself ]
]

{ #category : #helpers }
GitLocalModelImporterTest >> expectedBranches [

	^ #( #( 'another-branch-a' #( '4de84ee217a9e6fe1561233db282e5bc661e5e98' ) )
	     #( 'brancha' #( '4de84ee217a9e6fe1561233db282e5bc661e5e98' ) )
	     #( 'branchb' #( 'da8ce23a62daec1c558614e2a66aac7f05b9a589' ) )
	     #( 'main' #( 'ec21d44278f5e7853c4c8bb2006500ca04bad61a' ) ) )
]

{ #category : #helpers }
GitLocalModelImporterTest >> expectedCommitsOfFullWalk [
	"Baseline of the pre-F10 walk when every commit of the test repository is in the window."

	^ #( #( '02766af59f0b1bbf85861c67aa2128ed5315c8df'
	        #( '4de84ee217a9e6fe1561233db282e5bc661e5e98' )
	        #( 'da8ce23a62daec1c558614e2a66aac7f05b9a589' )
	        'Benoit Verhaeghe' )
	     #( '0b19529aa0166ad849ade03eeae1eb4c24126a3f'
	        #( '505cd202d27777c018af5590a44689928ea55430' )
	        #( 'ec21d44278f5e7853c4c8bb2006500ca04bad61a' )
	        'Benoit Verhaeghe' )
	     #( '4de84ee217a9e6fe1561233db282e5bc661e5e98'
	        #( '6578dcad66d5dd00fe62386e0c5cbd186185cd82' )
	        #( '02766af59f0b1bbf85861c67aa2128ed5315c8df' )
	        'Benoit Verhaeghe' )
	     #( '505cd202d27777c018af5590a44689928ea55430'
	        #( 'cb1a602f45d51686d9a9694f84469c341bee4421' )
	        #( '0b19529aa0166ad849ade03eeae1eb4c24126a3f'
	           '6578dcad66d5dd00fe62386e0c5cbd186185cd82' )
	        'Benoit Verhaeghe' )
	     #( '6578dcad66d5dd00fe62386e0c5cbd186185cd82'
	        #( '505cd202d27777c018af5590a44689928ea55430' )
	        #( '4de84ee217a9e6fe1561233db282e5bc661e5e98' )
	        'Benoit Verhaeghe' )
	     #( 'cb1a602f45d51686d9a9694f84469c341bee4421'
	        #(  ) #( '505cd202d27777c018af5590a44689928ea55430' )
	        'Benoit Verhaeghe' )
	     #( 'da8ce23a62daec1c558614e2a66aac7f05b9a589'
	        #( '02766af59f0b1bbf85861c67aa2128ed5315c8df' )
	        #(  ) 'Benoit Verhaeghe' )
	     #( 'ec21d44278f5e7853c4c8bb2006500ca04bad61a'
	        #( '0b19529aa0166ad849ade03eeae1eb4c24126a3f' )
	        #(  ) 'Benoit Verhaeghe' ) )
]

{ #category : #helpers }
GitLocalModelImporterTest >> modelCommitIds [

	^ ((model allWithType: GLHCommit) collect: [ :commit | commit id ])
		  asArray sorted
]

{ #category : #running }
GitLocalModelImporterTest >> setUp [

	super setUp.
	localImporter := GitLocalModelImporter new.
	model := GLHModel new.
	localImporter glhModel: model.
	localImporter withFiles: true.
	localImporter withCommitDiffs: true.
	localImporter withDiffRanges: true.
	localImporter withCommitsSince: (DateAndTime year: 2026 day: 1).

	repository := GLHRepository new
		              cacheAt: #localImporterReference
		              put: (GPHBridge testResources / 'testResource') asFileReference;
		              yourself.

	model add: repository.
]

{ #category : #tests }
GitLocalModelImporterTest >> testConnectionBetweenDivergingBranches [

	| lastCommitBranchB |
	localImporter importRepository: repository.
	lastCommitBranchB := (model allWithType: GLHCommit) detect: [ :commit |
		                     commit id
		                     = '505cd202d27777c018af5590a44689928ea55430' ].
	self assert: lastCommitBranchB childCommits size equals: 2
]

{ #category : #tests }
GitLocalModelImporterTest >> testConnectionBetweenSuccessiveBranches [

	| lastCommitBranchB |
	localImporter importRepository: repository.
	lastCommitBranchB := (model allWithType: GLHCommit) detect: [ :commit |
		                     commit id
		                     = '02766af59f0b1bbf85861c67aa2128ed5315c8df' ].
	self
		assert: lastCommitBranchB parentCommits anyOne id
		equals: '4de84ee217a9e6fe1561233db282e5bc661e5e98'.
	self
		assert: lastCommitBranchB childCommits anyOne id
		equals: 'da8ce23a62daec1c558614e2a66aac7f05b9a589'
]

{ #category : #tests }
GitLocalModelImporterTest >> testFirstCommitHasADiff [

	| commit |
	localImporter importRepository: repository.
	commit := (model allWithType: GLHCommit) detect: [ :commi |
		          commi parentCommits isEmpty ].
	self assert: commit diffs isNotEmpty
]

{ #category : #tests }
GitLocalModelImporterTest >> testHasRenamedField [

	| file renameCommit |
	localImporter importRepository: repository.
	file := (model allWithType: GLHFileBlob) detect: [ :fileBlob |
		        fileBlob path endsWith: 'renamed-hello.st' ].
	self assert: file diffs size equals: 3.
	renameCommit := (model allWithType: GLHCommit) detect: [ :commit |
		                commit id
		                = '505cd202d27777c018af5590a44689928ea55430' ].
	self assert: renameCommit diffs anyOne renamed_file
]

{ #category : #tests }
GitLocalModelImporterTest >> testImportCommitsOfRepositorySinceUntil [

	| commits originalSize |
	localImporter importBranchesOfRepository: repository.
	commits := localImporter
		           importCommitsOfRepository: repository
		           since: (DateAndTime year: 2026 month: 9 day: 3)
		           until: (DateAndTime year: 2026 month: 9 day: 5).
	originalSize := commits size.
	commits := localImporter
		           importCommitsOfRepository: repository
		           since: (DateAndTime year: 2026 month: 8 day: 3)
		           until: (DateAndTime year: 2026 month: 9 day: 5).
	self assert: originalSize < commits size
]

{ #category : #tests }
GitLocalModelImporterTest >> testImportFilesOfBranch [

	| file |
	localImporter importRepository: repository.
	file := (model allWithType: GLHFileBlob) detect: [ :fi |
		        fi name = 'renamed-hello.st' ].
	self assert: file isNotNil
]

{ #category : #tests }
GitLocalModelImporterTest >> testImportFilesOfBranchDoNotImportNotCommitedFile [

	| file |
	(GPHBridge testResources / 'testResource' / 'wrong-file.st')
		ensureCreateFile.
	localImporter importRepository: repository.
	file := (model allWithType: GLHFileBlob)
		        detect: [ :fi | fi name = 'wrong-file.st' ]
		        ifNone: [ nil ].
	self assert: file isNil
]

{ #category : #tests }
GitLocalModelImporterTest >> testSameHeadCommitForTwoBranches [

	| branchA anotherBranchA |
	localImporter importRepository: repository.
	branchA := (model allWithType: GLHBranch) detect: [ :branch |
		           branch name = 'brancha' ].
	anotherBranchA := (model allWithType: GLHBranch) detect: [ :branch |
		                  branch name = 'another-branch-a' ].
	self
		assert: branchA commits anyOne
		identicalTo: anotherBranchA commits anyOne
]

{ #category : #tests }
GitLocalModelImporterTest >> testWalkFingerprintIsUnchangedSince20260101 [

	self walkSince: (self
			 utcYear: 2026
			 month: 1
			 day: 1
			 hour: 0).
	self
		assertModelHasCommits: self expectedCommitsOfFullWalk
		branches: self expectedBranches
		userIds: #( 'Benoit Verhaeghe' )
]

{ #category : #tests }
GitLocalModelImporterTest >> testWalkFingerprintIsUnchangedSince20260803 [

	self walkSince: (self
			 utcYear: 2026
			 month: 8
			 day: 3
			 hour: 0).
	self
		assertModelHasCommits: self expectedCommitsOfFullWalk
		branches: self expectedBranches
		userIds: #( 'Benoit Verhaeghe' )
]

{ #category : #tests }
GitLocalModelImporterTest >> testWalkFingerprintIsUnchangedSince20260903 [

	self walkSince: (self
			 utcYear: 2026
			 month: 9
			 day: 3
			 hour: 0).
	self
		assertModelHasCommits:
			#( #( '02766af59f0b1bbf85861c67aa2128ed5315c8df'
			      #( '4de84ee217a9e6fe1561233db282e5bc661e5e98' )
			      #( 'da8ce23a62daec1c558614e2a66aac7f05b9a589' )
			      'Benoit Verhaeghe' )
			   #( '4de84ee217a9e6fe1561233db282e5bc661e5e98'
			      #( '6578dcad66d5dd00fe62386e0c5cbd186185cd82' )
			      #( '02766af59f0b1bbf85861c67aa2128ed5315c8df' )
			      'Benoit Verhaeghe' )
			   #( '505cd202d27777c018af5590a44689928ea55430'
			      #( 'cb1a602f45d51686d9a9694f84469c341bee4421' )
			      #( '6578dcad66d5dd00fe62386e0c5cbd186185cd82' )
			      'Benoit Verhaeghe' )
			   #( '6578dcad66d5dd00fe62386e0c5cbd186185cd82'
			      #( '505cd202d27777c018af5590a44689928ea55430' )
			      #( '4de84ee217a9e6fe1561233db282e5bc661e5e98' )
			      'Benoit Verhaeghe' )
			   #( 'da8ce23a62daec1c558614e2a66aac7f05b9a589'
			      #( '02766af59f0b1bbf85861c67aa2128ed5315c8df' )
			      #(  ) 'Benoit Verhaeghe' )
			   #( 'ec21d44278f5e7853c4c8bb2006500ca04bad61a'
			      #( '0b19529aa0166ad849ade03eeae1eb4c24126a3f' )
			      #(  ) 'Benoit Verhaeghe' ) )
		branches: self expectedBranches
		userIds: #( 'Benoit Verhaeghe' )
]

{ #category : #tests }
GitLocalModelImporterTest >> testWalkFingerprintIsUnchangedSinceAfterLastCommit [
	"The last commit of the test repository is 2026-09-04T13:38:49+02:00: only branch heads are visited."

	self walkSince: (self
			 utcYear: 2026
			 month: 9
			 day: 4
			 hour: 23).
	self
		assertModelHasCommits:
			#( #( '4de84ee217a9e6fe1561233db282e5bc661e5e98'
			      #( '6578dcad66d5dd00fe62386e0c5cbd186185cd82' )
			      #(  ) 'Benoit Verhaeghe' )
			   #( 'da8ce23a62daec1c558614e2a66aac7f05b9a589'
			      #( '02766af59f0b1bbf85861c67aa2128ed5315c8df' )
			      #(  ) 'Benoit Verhaeghe' )
			   #( 'ec21d44278f5e7853c4c8bb2006500ca04bad61a'
			      #( '0b19529aa0166ad849ade03eeae1eb4c24126a3f' )
			      #(  ) 'Benoit Verhaeghe' ) )
		branches: self expectedBranches
		userIds: #( 'Benoit Verhaeghe' )
]

{ #category : #tests }
GitLocalModelImporterTest >> testWalkTwiceIsIdempotent [

	| commitIdsAfterFirstWalk childIdsAfterFirstWalk |
	self walkSince: (self
			 utcYear: 2026
			 month: 1
			 day: 1
			 hour: 0).
	commitIdsAfterFirstWalk := self modelCommitIds.
	childIdsAfterFirstWalk := self childIdsByCommitId.
	self walkSince: (self
			 utcYear: 2026
			 month: 1
			 day: 1
			 hour: 0).
	self assert: self modelCommitIds equals: commitIdsAfterFirstWalk.
	self assert: self childIdsByCommitId equals: childIdsAfterFirstWalk
]

{ #category : #helpers }
GitLocalModelImporterTest >> utcYear: aYear month: aMonth day: aDay hour: anHour [

	^ DateAndTime
		  year: aYear
		  month: aMonth
		  day: aDay
		  hour: anHour
		  minute: 0
		  second: 0
		  offset: Duration zero
]

{ #category : #helpers }
GitLocalModelImporterTest >> walkSince: aSinceDate [
	"Import branches then commits (no diffs, no files) until 2026-09-05 UTC, as the F10 baseline did."

	localImporter
		withCommitDiffs: false;
		withFiles: false.
	localImporter importBranchesOfRepository: repository.
	^ localImporter
		  importCommitsOfRepository: repository
		  since: aSinceDate
		  until: (self
				   utcYear: 2026
				   month: 9
				   day: 5
				   hour: 0)
]
