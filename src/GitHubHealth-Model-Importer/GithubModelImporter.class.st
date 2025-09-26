Class {
	#name : #GithubModelImporter,
	#superclass : #GitModelImporter,
	#category : #'GitHubHealth-Model-Importer'
}

{ #category : #api }
GithubModelImporter >> api [

	self
		deprecated: 'Use #repoApi instead'
		on: '7 October 2024'
		in:
		'Pharo-11.0.0+build.726.sha.aece1b5473acf3830a0e082c1bc3a15d4ff3522b (64 Bit)'.

	^ repoApi
]

{ #category : #api }
GithubModelImporter >> api: anObject [

	self
		deprecated: 'Use #repoApi: instead'
		on: '7 October 2024'
		in:
		'Pharo-11.0.0+build.726.sha.aece1b5473acf3830a0e082c1bc3a15d4ff3522b (64 Bit)'.

	repoApi := anObject
]

{ #category : #'import - commits' }
GithubModelImporter >> completeImportedCommit: aGLHCommit [

	| result |
	('completing commit: ' , aGLHCommit short_id printString) recordInfo.
	"link commit to user"
	self importCreatorOfCommit: aGLHCommit.

	"import deletion and addition"
	result := self repoApi
		          commit: aGLHCommit id
		          ofOrganisation: aGLHCommit repository project group name
		          ofProject: aGLHCommit repository project name.
	aGLHCommit deletions:
		((result at: #files) collect: [ :file | file at: #deletions ]) sum.
	aGLHCommit additions:
		((result at: #files) collect: [ :file | file at: #additions ]) sum.


	"import diffs of this commits"
	self withCommitDiffs ifTrue: [
		| diffs |
		aGLHCommit diffs ifEmpty: [
			diffs := self parseDiffresult: result.
			diffs := aGLHCommit diffs
				         addAll: diffs
				         unless: self blockForDiffEquality.
			self glhModel addAll: diffs unless: self blockForDiffEquality.
			diffs do: [ :diff | self importDiffRangesForDiff: diff ] ] ].

	^ aGLHCommit 
]

{ #category : #'import - projects' }
GithubModelImporter >> completeImportedProject: aGLHProject [

	('Complete import of project: ' , aGLHProject id printString)
		recordInfo.
	aGLHProject repository ifNotNil: [ ^ aGLHProject ].

	aGLHProject repository: GLHRepository new.
	self glhModel add: aGLHProject repository.

	self importPipelinesOfProject: aGLHProject.
	self importBranchesOf: aGLHProject.
	self withCommitsSince ifNotNil: [ :withCommitSince | "If not nil, it means we have to import commit"
		| commits |
		commits := self importCommitsOfProject: aGLHProject.
		self chainsCommitsFrom: commits ]
]

{ #category : #'private - configure reader' }
GithubModelImporter >> configureReaderForBranch: reader [

	super configureReaderForBranch: reader.

	reader for: GLHBranch do: [ :mapping |
		mapping
			mapProperty: #sha
			getter: [ :branch | #ignore ]
			setter: [ :branch :value | branch sha: (value at: #sha) ] ]
]

{ #category : #'private - configure reader' }
GithubModelImporter >> configureReaderForCommit: reader [

	super configureReaderForCommit: reader.

	reader for: GLHCommit do: [ :mapping |
		mapping mapInstVar: #id to: #sha.
		mapping mapInstVar: #web_url to: #html_url.

		mapping
			mapProperty: #commit
			getter: [ :object | #ignore ]
			setter: [ :glhCommit :value |
				glhCommit message: (value at: #message).
				glhCommit authored_date:
					(DateAndTime fromString: (value at: #author at: #date)).
				glhCommit committed_date:
					(DateAndTime fromString: (value at: #committer at: #date)) ].

		mapping
			mapProperty: #author
			getter: [ :object | #ignore ]
			setter: [ :glhCommit :value |
				value ifNotNil: [
					glhCommit author_name: (value at: #login).
					value
						at: #id
						ifPresent: [ :authorId |
						glhCommit cacheAt: #authorID put: (value at: #id) ] ] ].

		mapping
			mapProperty: #committer
			getter: [ :object | #ignore ]
			setter: [ :glhCommit :value |
				value ifNotNil: [ glhCommit committer_name: (value at: #login) ] ].

		(mapping mapInstVar: #parent_ids to: #parents) valueSchema:
			#ArrayOfId.
			
		(mapping mapInstVar: #diffs to: #files) valueSchema: #ArrayOfDiff. 
			
			 ].

	reader for: DateAndTime customDo: [ :mapping |
		mapping decoder: [ :string | DateAndTime fromString: string ] ].

	reader for: #ArrayOfId customDo: [ :mapping |
		mapping decoder: [ :parents |
			parents collect: [ :parent | parent at: #sha ] ] ]
]

{ #category : #'private - configure reader' }
GithubModelImporter >> configureReaderForDiff: reader [

	super configureReaderForDiff: reader.

	reader for: GLHDiff do: [ :mapping |
		mapping mapInstVar: #new_path to: #filename.
		mapping mapInstVar: #old_path to: #filename.
		mapping mapInstVar: #diffString to: #patch. ]
]

{ #category : #'private - configure reader' }
GithubModelImporter >> configureReaderForGroup: reader [

	super configureReaderForGroup: reader.
	
	reader
		for: GLHGroup
		do: [ :mapping | mapping mapInstVar: #web_url to: #html_url ]
]

{ #category : #'private - configure reader' }
GithubModelImporter >> configureReaderForIssue: reader [

	super configureReaderForIssue: reader.

	reader
		for: GLHIssue
		do: [ :mapping | "mapping mapInstVar: #status to: #conclusion."
			(mapping mapInstVar: #created_at) valueSchema: DateAndTime.
			(mapping mapInstVar: #updated_at) valueSchema: DateAndTime.
			mapping mapInstVar: #name to: #title.
			mapping mapInstVar: #description to: #body.


			mapping
				mapProperty: #assignees
				getter: [ :object | #ignore ]
				setter: [ :issue :values |
					values do: [ :item |
						issue
							cacheAt: #assigneesID
							ifPresent: [ :v | v add: (item at: #id) ]
							ifAbsentPut: [
								Set new
									add: (item at: #id);
									yourself ] ] ].


			mapping
				mapProperty: #user
				getter: [ :object | #ignore ]
				setter: [ :issue :value |
					value ifNotNil: [
						value
							at: #id
							ifPresent: [ :authorId |
							issue cacheAt: #authorID put: (value at: #id) ] ] ] ]
]

{ #category : #'private - configure reader' }
GithubModelImporter >> configureReaderForJob: reader [

	super configureReaderForJob: reader.

	reader for: GLHJob do: [ :mapping |
		
		mapping mapInstVar: #web_url to: #html_url.
		
		mapping
			mapProperty: #pipeline
			getter: [  ]
			setter: [ :job :rawPipeline |
				job cacheAt: #pipelineID put: (rawPipeline at: #head_sha) ].

		mapping
			mapProperty: #commit
			getter: [  ]
			setter: [ :job :rawCommit |
			job cacheAt: #commitID put: (rawCommit at: #id) ].

		mapping
			mapProperty: #completed_at
			getter: [ :object | #ignore ]
			setter: [ :job :value |
				value ifNotNil: [ job cacheAt: #completed_at put: (value asDateAndTime ) ] ].
			
			mapping
			mapProperty: #started_at
			getter: [ :object | #ignore ]
			setter: [ :job :value |
				value ifNotNil: [ job cacheAt: #started_at put: (value asDateAndTime ) ] ] ]
]

{ #category : #'private - configure reader' }
GithubModelImporter >> configureReaderForMergeRequest: reader [
	"	reader mapInstVarsFor: GLHProject. "

	super configureReaderForMergeRequest: reader.
	
	reader for: GLHMergeRequest do: [ :mapping |
		(mapping mapInstVar: #created_at) valueSchema: DateAndTime.
		(mapping mapInstVar: #updated_at) valueSchema: DateAndTime.
		(mapping mapInstVar: #merged_at) valueSchema: DateAndTime.
		(mapping mapInstVar: #closed_at) valueSchema: DateAndTime.

		mapping
			mapProperty: #author
			getter: [  ]
			setter: [ :object :value |
			object cacheAt: #authorID put: (value at: #id) ].
		mapping
			mapProperty: #merge_user
			getter: [  ]
			setter: [ :object :value |
				value ifNotNil: [
					object cacheAt: #mergeUserID put: (value at: #id) ] ] ].



]

{ #category : #'private - configure reader' }
GithubModelImporter >> configureReaderForPipeline: reader [

	super configureReaderForPipeline: reader.

	reader
		for: GLHPipeline
		do: [ :mapping | "mapping mapInstVar: #status to: #conclusion."
			
		(mapping mapInstVar: #created_at) valueSchema: DateAndTime.
		(mapping mapInstVar: #updated_at) valueSchema: DateAndTime.
			
			mapping
				mapProperty: #status
				getter: [ :object | #ignore ]
				setter: [ :object :value |
					(object status isNil and: [ value isNotNil ]) ifTrue: [
						object status: value ] ].

			mapping
				mapProperty: #conclusion
				getter: [ :object | #ignore ]
				setter: [ :object :value |
					(object status isNil and: [ value isNotNil ]) ifTrue: [
						object status: value ] ].

			mapping
				mapProperty: #run_started_at
				getter: [ :object | #ignore ]
				setter: [ :object :value |
				object runDate: (DateAndTime fromString: value) ] ]
]

{ #category : #'private - configure reader' }
GithubModelImporter >> configureReaderForProject: reader [

	super configureReaderForProject: reader.
	
	reader for: GLHProject do: [ :mapping |
		mapping mapInstVar: #web_url to: #html_url.
	 ].

]

{ #category : #'private - configure reader' }
GithubModelImporter >> configureReaderForUser: reader [
	super configureReaderForUser: reader.
	
	
		reader for: GLHUser do: [ :mapping |
		mapping mapInstVar: #public_email to: #email.
		mapping mapInstVar: #username to: #login.
		mapping mapInstVar: #bio to: #bio.
		mapping mapInstVar: #organization to: #company.
		mapping mapInstVar: #web_url to: #html_url.
 ].
]

{ #category : #private }
GithubModelImporter >> convertApiFileAsFile: aAPIFile [

	aAPIFile type = 'dir' ifTrue: [ 
		^ GLHFileDirectory new
			  name: aAPIFile name;
			  yourself ].
	^ GLHFileBlob new
		  name: aAPIFile name;
		  yourself
]

{ #category : #'import - groups' }
GithubModelImporter >> ensureGroupNamed: aGroupName [

	self flag: 'WARNING: group from different platform (github vs gitlab) can share the same name, thus being confused here'. 
	^ self glhModel
		  detect: [ :a |
		  (a isKindOf: GLHGroup) and: [ a name = aGroupName ] ]
		  ifNone: [ self glhModel newGroupNamed: aGroupName ]
]

{ #category : #'import - repositories' }
GithubModelImporter >> importBranchesOf: aGLHProject [
	"add the pipeline (actions runs) in the project"

	| branchesResults foundBranches branches |
	self
		deprecated: 'Use importBranchesOfProject: instead of current one'
		on: '26 September 2025'
		in:
		'Pharo-12.0.0+SNAPSHOT.build.1571.sha.cf5fcd22e66957962c97dffc58b0393b7f368147 (64 Bit)'.
	branchesResults := self repoApi branches
		                   getAllForRepo: aGLHProject name
		                   ofOwner: aGLHProject group name.

	foundBranches := (branchesResults collect: [ :branchesResult |
		                  self parseBranchesResult: branchesResult ])
		                 flattened.


	"WARNING: always add branch first into repository, than into model !"
	branches := aGLHProject repository branches
		            addAll: foundBranches
		            unless: self blockOnNameEquality.

	"branch HEAD commit is not imported by default. use branch ref (sha) to import it specifically"

	branches := self glhModel
		            addAll: branches
		            unless: self blockForBranchEquality.

	self withFiles ifTrue: [
		branches do: [ :branch | self importFilesOfBranch: branch ] ].

	^ branches
]

{ #category : #'import - repositories' }
GithubModelImporter >> importBranchesOfProject: aGLHProject [
	"add the pipeline (actions runs) in the project"

	| branchesResults foundBranches branches |
	branchesResults := self repoApi branches
		                   getAllForRepo: aGLHProject name
		                   ofOwner: aGLHProject group name.

	foundBranches := (branchesResults collect: [ :branchesResult |
		                  self parseBranchesResult: branchesResult ])
		                 flattened.


	"WARNING: always add branch first into repository, than into model !"
	branches := aGLHProject repository branches
		            addAll: foundBranches
		            unless: self blockOnNameEquality.

	"branch HEAD commit is not imported by default. use branch ref (sha) to import it specifically"

	branches := self glhModel
		            addAll: branches
		            unless: self blockForBranchEquality.

	self withFiles ifTrue: [
		branches do: [ :branch | self importFilesOfBranch: branch ] ].

	^ branches
]

{ #category : #'import - commits' }
GithubModelImporter >> importCommit: aCommitID ofProject: aGLHProject [

	| result parsedResult |
	(self glhModel allWithType: GLHCommit) asOrderedCollection
		detect: [ :commit | commit id = aCommitID ]
		ifFound: [ :commit | ^ commit ].

	result := self repoApi commits
		          get: aCommitID
		          inProject: aGLHProject id.

	parsedResult := self parseCommitResult: result.

	parsedResult := self glhModel
		                add: parsedResult
		                unless: self blockOnIdEquality.
	parsedResult := aGLHProject repository commits
		                add: parsedResult
		                unless: self blockOnIdEquality.

	self withCommitDiffs ifTrue: [ self importDiffOfCommit: parsedResult ].

	^ parsedResult
]

{ #category : #'import - commits' }
GithubModelImporter >> importCommitsOfProject: aGLHProject [

	| itemByPage foundCommits tmp pageNumber |
	itemByPage := 100.
	pageNumber := 1.
	('Extract all commits of ' , aGLHProject name) recordInfo.
	foundCommits := OrderedCollection new.
	('Extract commits from ' , foundCommits size printString , ' to '
	 , (foundCommits size + itemByPage) printString) recordInfo.
	"also check that there is at least one commit with the error handling"
	[
	tmp := self parseCommitsResult: (self repoApi commits
			        getForRepo: aGLHProject name
			        ofOwner: aGLHProject group name
			        withParms: {
					        (#since -> self withCommitsSince).
					        (#perPage -> itemByPage).
					        (#page -> pageNumber) } asDictionary) ]
		on: GHRepositoryEmptyError
		do: [ ^ {  } ].

	foundCommits addAll: tmp.
	[ tmp size = itemByPage ] whileTrue: [
		pageNumber := pageNumber + 1.
		('Extract issues from ' , foundCommits size printString , ' to '
		 , (foundCommits size + itemByPage) printString) recordInfo.
		tmp := self parseCommitsResult: (self repoApi commits
				        getForRepo: aGLHProject name
				        ofOwner: aGLHProject group name
				        withParms: {
						        (#sine -> self withCommitsSince).
						        (#perPage -> itemByPage).
						        (#page -> pageNumber) } asDictionary).
		foundCommits addAll: tmp ].

	"add the imported commits (unless they are already added to this repository)"
	aGLHProject repository commits
		addAll: foundCommits
		unless: [ :existing :new | existing id = new id ].
	"add the imported commits to the model unles they are already added to the model"
	^ self glhModel
		  addAll: foundCommits
		  unless: [ :existing :new | existing id = new id ]
]

{ #category : #'import - commits' }
GithubModelImporter >> importCreatorOfCommit: aGLHCommit [

	| creator |
	(self glhModel allWithType: GLHUser)
		detect: [ :user | user username = aGLHCommit author_name ]
		ifFound: [ :user |
			aGLHCommit commitCreator: user.
			^ user ].

	aGLHCommit author_name ifNotNil: [ :author_name |
		creator := self importUserByUsername: author_name.
		aGLHCommit commitCreator: creator ].
	^ creator
]

{ #category : #'import - diffs' }
GithubModelImporter >> importDiffOfCommit: aGLHCommit [

	| result diffs |
	aGLHCommit diffs ifNotEmpty: [
		'Diff already importer: '
		, aGLHCommit short_id printString recordInfo.
		^ aGLHCommit diffs ].
	('Import diff of commit: ' , aGLHCommit short_id printString)
		recordInfo.

	result := self repoApi commits
		          getCommit: aGLHCommit id
		          ForRepo: aGLHCommit repository project name
		          ofOwner: aGLHCommit repository project group name.
		
	diffs := (self parseCommitResult: result) diffs.
	
	diffs do: [ :diff | 
		self parseDiffString: diff.
		].	

	diffs := aGLHCommit diffs
		         addAll: diffs
		         unless: self blockForDiffRangeEquality.
	diffs := glhModel
		         addAll: diffs
		         unless: self blockForDiffRangeEquality.

	^ aGLHCommit diffs
]

{ #category : #'import - merge-requests' }
GithubModelImporter >> importDiffOfMergeRequest: aGLHMergeRequest [ 
	|diffsResult|
	
	diffsResult := self importDiffOfCommit: aGLHMergeRequest mergedCommit.
	
	diffsResult := aGLHMergeRequest diffs
		addAll: diffsResult
		unless: self blockForDiffEquality.
	self glhModel
		addAll: diffsResult
		unless: self blockForDiffEquality.

	aGLHMergeRequest diffs do: [ :diff | self importDiffRangesForDiff: diff ].
	^ aGLHMergeRequest diffs. 
]

{ #category : #'import - files' }
GithubModelImporter >> importDirectoryFiles: aDirectoryFile OfBranch: aBranch [

	| result files apiFiles |
	('Explore ' , aDirectoryFile name) recordInfo.
	result := self api
		          contentsOfRepo: aBranch repository project name
		          ofOrganization: aBranch repository project group name
		          inBranch: aBranch name
		          withPath: aDirectoryFile path.
	apiFiles := self parseFileTreeResult: result.
	files := apiFiles collect: [ :apiFile | 
		         self convertApiFileAsFile: apiFile ].
	files do: [ :file | 
		self glhModel add: file.
		aDirectoryFile addFile: file ].
	files
		select: [ :file | file isKindOf: GLHFileDirectory ]
		thenCollect: [ :file | 
		self importDirectoryFiles: file OfBranch: aBranch ]
]

{ #category : #'import - files' }
GithubModelImporter >> importFilesOfBranch: aBranch [

	| result files apiFiles |
	result := self api
		          contentsOfRepo: aBranch repository project name
		          ofOrganization: aBranch repository project group name
		          inBranch: aBranch name
		          withPath: nil.
	apiFiles := self parseFileTreeResult: result.
	files := apiFiles collect: [ :apiFile | 
		         self convertApiFileAsFile: apiFile ].
	files do: [ :file | 
		self glhModel add: file.
		aBranch addFile: file ].
	files
		select: [ :file | file isKindOf: GLHFileDirectory ]
		thenCollect: [ :file | 
		self importDirectoryFiles: file OfBranch: aBranch ].
	^ files
]

{ #category : #'import - groups' }
GithubModelImporter >> importGroup: aGroupName [

	| result groupResult |
	result := self repoApi organizations get: aGroupName.
	groupResult := self parseGroupResult: result.
	self glhModel add: groupResult.
	self importRepositoriesOfGroup: groupResult.
	^ groupResult
]

{ #category : #'import - issues' }
GithubModelImporter >> importIssuesOfProject: aGLHProject [

	| results issues foundIssues |
	results := self repoApi issues
		           getAllForRepo: aGLHProject name
		           ofOwner: aGLHProject group name
		           withParms: Dictionary new.
	foundIssues := (results collect: [ :result |
		                self parseIssuesResult: result ]) flattened.


	issues := OrderedCollection new.
	issues := foundIssues collect: [ :issue | 
		
		issue author:
			(self importUser: (issue cacheAt: #authorID ifAbsent: [ '' ])).

		issue assignees
			addAll:
				((issue cacheAt: #assigneesID ifAbsent: [ {  } ]) collect: [
					 :assigneeID | self importUser: assigneeID ])
			unless: self blockOnIdEquality. 
			issue. 
			
		].

	
	issues := aGLHProject issues
		          addAll: issues
		          unless: self blockOnIdEquality.
	
	glhModel addAll: issues unless: self blockOnIdEquality.


	^ aGLHProject issues
]

{ #category : #'import - jobs' }
GithubModelImporter >> importJobsOfPipeline: aGLHPipeline [

	| result jobs |
	result := self repoApi actions
		          getAllJobsForRun: aGLHPipeline id
		          forRepo: aGLHPipeline project name
		          ofOwner: aGLHPipeline project group name.

	jobs := (self parsePipelinesResult: result) jobs.

	jobs do: [ :job |
		|stop start|
		stop := job cacheAt: #completed_at ifAbsent: [ nil ].
		start := job cacheAt: #started_at ifAbsent: [ nil ].
		job duration: (stop - start) asDuration . 
	].

	jobs := glhModel addAll: jobs unless: self blockOnIdEquality.
	aGLHPipeline jobs addAll: jobs unless: self blockOnIdEquality.


	^ aGLHPipeline jobs
]

{ #category : #'import - commits' }
GithubModelImporter >> importLatestCommitsOfProject: aGLHProject [
	"limited to the last 50 commits"

	| results parsedResults |
	results := self repoApi commits
		           getLatestForRepo: aGLHProject name
		           ofOwner: aGLHProject group name.
	parsedResults := self parseCommitsResult: results.
	
	
	parsedResults := self glhModel
		                 addAll: parsedResults
		                 unless: self blockOnIdEquality.

	aGLHProject repository commits
		addAll: parsedResults
		unless: self blockOnIdEquality.

	self withCommitDiffs ifTrue: [
		parsedResults do: [ :commit | 
			self importDiffOfCommit: commit. 
			
			 ] ].

	^ parsedResults
]

{ #category : #'import - merge-requests' }
GithubModelImporter >> importLatestMergeRequestsOfProject: aGLHProject [ 
	
	| results parsedResults |
	results := self repoApi pullRequests getLatestForRepo: aGLHProject name ofOwner:  aGLHProject group name.
	parsedResults := self parseMergeRequestsResult: results.

	parsedResults := glhModel
		                 addAll: parsedResults
		                 unless: self blockOnIdEquality.
	parsedResults := aGLHProject mergeRequests
		                 addAll: parsedResults
		                 unless: self blockOnIdEquality.
	^ parsedResults
]

{ #category : #'import - merge-requests' }
GithubModelImporter >> importLatestPullRequestsOfProject: aGLHProject [
	"alias method since PullRequest = MergeRequest in model"
	^ self importLatestMergeRequestsOfProject: aGLHProject 
]

{ #category : #'import - merge-requests' }
GithubModelImporter >> importMergeRequestMergeCommits: aGLHMergeRequest [

	| foundCommits |
	foundCommits := OrderedCollection new.

	('Import commit sha of MR:  ' , aGLHMergeRequest iid printString)
		recordInfo.
	"the founds commits are added to the model during their respective import"
	aGLHMergeRequest mergeRequestCommit: ((self
			  importCommit: aGLHMergeRequest sha
			  ofProject: aGLHMergeRequest project) ifNotNil: [ :commit |
			 foundCommits add: commit ]).

	('Import commit merge_commit_sha of MR:  '
	 , aGLHMergeRequest iid printString) recordInfo.
	aGLHMergeRequest mergedCommit: ((self
			  importCommit: aGLHMergeRequest merge_commit_sha
			  ofProject: aGLHMergeRequest project) ifNotNil: [ :commit |
			 foundCommits add: commit ]).

	('Import commit squash_commit_sha of MR:  '
	 , aGLHMergeRequest iid printString) recordInfo.
	aGLHMergeRequest squashCommit: ((self
			  importCommit: aGLHMergeRequest squash_commit_sha
			  ofProject: aGLHMergeRequest project) ifNotNil: [ :commit |
			 foundCommits add: commit ]).


	self chainsCommitsFrom: foundCommits.
	^ foundCommits
]

{ #category : #'import - merge-requests' }
GithubModelImporter >> importMergeRequestsOfProject: aGLHProject [

	| response mergeRequests |
	response := self repoApi pullRequests
		            getLatestForRepo: aGLHProject name
		            ofOwner: aGLHProject group name.
	mergeRequests := self parseMergeRequestsResult: response.

	mergeRequests := aGLHProject mergeRequests
		                 addAll: mergeRequests
		                 unless: self blockOnIdEquality.
		
	"gets it related commits"
	aGLHProject mergeRequests do: [ :mr |
		self importMergeRequestMergeCommits: mr ].


	self withCommitDiffs ifTrue: [
		aGLHProject mergeRequests do: [ :mr |
			self importDiffOfMergeRequest: mr ] ].
	
	^ mergeRequests
]

{ #category : #'import - pipelines' }
GithubModelImporter >> importPipeline: aPipelineId OfProject: aGLHProject [

	"import specific actions' run "
	| reponse result |
	aGLHProject pipelines
		detect: [ :p | p id = aPipelineId ]
		ifFound: [ :p | ^ p ]
		ifNone: [  ].

	reponse := self repoApi actions
		           getRun: aPipelineId
		           forRepo: aGLHProject name
		           ofOwner: aGLHProject group name.
	result := self parsePipelineResult: reponse.

	result := self glhModel add: result unless: self blockOnIdEquality.
	result := aGLHProject pipelines
		          add: result
		          unless: self blockOnIdEquality.

	^ result
]

{ #category : #'import - pipelines' }
GithubModelImporter >> importPipelinesOfMergeRequest: aGLHMergeRequest [ 
	|result pipelines|
	result := self repoApi actions getAllRunsForRepo: aGLHMergeRequest project name ofOwner: aGLHMergeRequest project group name withParms: { #event->'pull_request' . #head_sha -> aGLHMergeRequest sha } asDictionary .
	
	
	pipelines := (self parsePipelinesResult: result) workflow_runs .
	
	pipelines := aGLHMergeRequest project pipelines addAll: pipelines unless: self blockOnIdEquality.
	
	pipelines := glhModel addAll: pipelines unless:  self blockOnIdEquality. 
	pipelines := aGLHMergeRequest pipelines addAll: pipelines unless: self blockOnIdEquality. 
	
	
	
	^ pipelines 
]

{ #category : #'import - pipelines' }
GithubModelImporter >> importPipelinesOfProject: project [

	"add the pipeline (actions runs) in the project"

	| pipelinesResult ghApiPipelineOverview |
	pipelinesResult := self repoApi actions
		                   getLatestForRepo: project name
		                   ofOwner: project group name.
	ghApiPipelineOverview := self parsePipelinesResult: pipelinesResult.
	ghApiPipelineOverview workflow_runs do: [ :pipeline | 
		project addPipeline: pipeline ]
]

{ #category : #'import - projects' }
GithubModelImporter >> importProject: aProjectName ofGroup: aGroupName [

	| result projectResult group |
	group := self ensureGroupNamed: aGroupName.
	result := self repoApi organizations getRepository: aProjectName ofOrganization: aGroupName .
	projectResult := self parseProjectResult: result.
	projectResult group: group.
	self glhModel add: projectResult.
	self completeImportedProject: projectResult.
	^ projectResult
]

{ #category : #'import - merge-requests' }
GithubModelImporter >> importPullRequestsOfProject: aProject [
	"alias method since PullRequest = MergeRequest in model"

	^ self importMergeRequestsOfProject: aProject
]

{ #category : #'import - groups' }
GithubModelImporter >> importRepositoriesOfGroup: groupResult [
	"Github Repository = GLHProject"

	| reposResult itemByPage pageNumber reposFound tmp |
	itemByPage := 100.
	pageNumber := 1.
	('Extract all repository of ' , groupResult name) recordInfo.
	reposFound := OrderedCollection new.
	('Extract commits from ' , reposFound size printString , ' to '
	 , (reposFound size + itemByPage) printString) recordInfo.
	tmp := self parseArrayOfProject: (self repoApi
			        organizations getRepositoriesOfOrganization: groupResult name
			        perPage: itemByPage
			        page: pageNumber).

	reposFound addAll: tmp.
	[ tmp size = itemByPage ] whileTrue: [
		pageNumber := pageNumber + 1.
		('Extract issues from ' , reposFound size printString , ' to '
		 , (reposFound size + itemByPage) printString) recordInfo.
		tmp := self parseArrayOfProject: (self repoApi
				        reposOfOrganization: groupResult name
				        perPage: itemByPage
				        page: pageNumber).
		reposFound addAll: tmp ].

	reposResult := self repoApi organizations getRepositoriesOfOrganization: groupResult name.
	groupResult projects addAll: reposFound.
	self glhModel addAll: groupResult projects.
	groupResult projects do: [ :project |
		self completeImportedProject: project ].
	^ groupResult
]

{ #category : #'import - users' }
GithubModelImporter >> importUser: userID [

	| result userResult |
	(glhModel allWithType: GLHUser)
		detect: [ :user | user id = userID ]
		ifFound: [ :user | ^ user ].
	('Import user: ' , userID printString) recordInfo.
	result := self repoApi users getUserId: userID.
	userResult := self parseUserResult: result.
	^ glhModel
		  add: userResult
		  unless: [ :current :new | current id = new id ]
]

{ #category : #'import - users' }
GithubModelImporter >> importUserByUsername: anUsername [

	| dicUsername resultUser |
	dicUsername := ((self glhModel allWithType: GLHUser) collect: [ :user |
		                user username -> user ]) asSet asDictionary.

	dicUsername addAll: self userCatalogue collectUsernames.


	resultUser := dicUsername
		              at: anUsername
		              ifAbsent: [ "thus we have to import this new user"
			              | userId searchResult |
			              ('Import user with username: '
			               , anUsername printString) recordInfo.

			              searchResult := self repoApi users getUsername: anUsername.

			              (searchResult class = Dictionary and: [
				               (searchResult at: #status) includesSubstring:
					               '404' ])
				              ifTrue: [ "if the result is an 403 error we fake a new user"
					              self glhModel
						              add: (GLHUser new
								               username: anUsername;
								               name: anUsername;
								               yourself)
						              unless: [ :nu :ou | nu username = ou username ] ]
				              ifFalse: [
					              searchResult
						              ifEmpty: [ "results can be empty thus we force a new user with the info we have "
							              self glhModel
								              add: (GLHUser new
										               username: anUsername;
										               name: anUsername;
										               yourself)
								              unless: [ :nu :ou | nu username = ou username ] ]
						              ifNotEmpty: [ "because we may already have the researched user, we look by ID in the model"
							              userId := searchResult first at: #id.
							              (self glhModel allWithType: GLHUser)
								              detect: [ :user | user id = userId ]
								              ifNone: [ self importUser: userId ] ] ] ].

	self userCatalogue addUser: resultUser withName: anUsername.

	^ resultUser
]

{ #category : #initialization }
GithubModelImporter >> initReader [

	super initReader. 
]

{ #category : #initialization }
GithubModelImporter >> initialize [

	super initialize.
	self repoApi: GithubApi new.
	self repoApi output: 'json'.
	self withCommitDiffs: true.
	withFiles := false
]

{ #category : #parsing }
GithubModelImporter >> parseArrayOfProject: arrayOfProjects [

	| reader |
	" reader := NeoJSONReader on: arrayOfProjects readStream.
	
	reader
		for: #ArrayOfProjects
		customDo: [ :customMappting | 
		customMappting listOfElementSchema: GLHProject ].
	
	reader for: GLHProject do: [ :mapping | 
		mapping mapInstVar: #name to: #name.
		mapping mapInstVar: #description to: #description.
		mapping mapInstVar: #id to: #id.
		mapping mapInstVar: #archived to: #archived.
		mapping mapInstVar: #web_url to: #html_url.
		mapping mapInstVar: #topics to: #topics ].
	^ reader nextAs: #ArrayOfProjects
	"
	reader := generalReader on: arrayOfProjects readStream.

	^ reader nextAs: #ArrayOfProject
]

{ #category : #parsing }
GithubModelImporter >> parseBranchesResult: arrayOfBranch [

	| reader |
	reader := generalReader on: arrayOfBranch readStream.

	^ reader nextAs: #ArrayOfBranch
]

{ #category : #parsing }
GithubModelImporter >> parseCommitResult: result [
	| reader |
	
	reader := generalReader on: result readStream.

	^ reader nextAs: GLHCommit 
]

{ #category : #parsing }
GithubModelImporter >> parseCommitsResult: result [

	| reader |
	(result includesSubstring: '"status":"409"') ifTrue: [
		GHRepositoryEmptyError signal: 'Git Repository is empty' ].

	reader := generalReader on: result readStream.

	^ reader nextAs: #ArrayOfCommit
]

{ #category : #parsing }
GithubModelImporter >> parseDiffresult: response [

	| result |
	result := (response at: #files) collect: [ :file |
		          GLHDiff new
			          diffString: (file at: #patch);
			          old_path: (file at: #filename);
			          new_path: (file at: #filename) ].

	^ result
]

{ #category : #parsing }
GithubModelImporter >> parseFileTreeResult: aResult [

	| reader |
	reader := NeoJSONReader on: aResult readStream.
	reader mapInstVarsFor: GHApiFile.
	reader
		for: #ArrayOfFile
		customDo: [ :customMappting | 
		customMappting listOfElementSchema: GHApiFile ].
	^ reader nextAs: #ArrayOfFile
]

{ #category : #parsing }
GithubModelImporter >> parseGroupResult: aResult [

	| reader |
	reader := generalReader on: aResult readStream.
	
	^ reader nextAs: GLHGroup
]

{ #category : #parsing }
GithubModelImporter >> parseIssuesResult: result [ 
	
	^ (generalReader on: result readStream) nextAs: #ArrayOfIssue 
]

{ #category : #parsing }
GithubModelImporter >> parseMergeRequestsResult: response [

	| result json|
	self flag: 'temp version, must remade using NeoJsonReader'.
	json := NeoJSONReader fromString: response.
	
	result := json collect: [ :aPull |
		          GLHMergeRequest new
			          id: (aPull at: #id);
			          title: (aPull at: #title);
			          state: (aPull at: #state);
			          closed_at:
				          ((aPull at: #closed_at) ifNotNil: #asDateAndTime);
			          merged_at:
				          ((aPull at: #merged_at) ifNotNil: #asDateAndTime);
			          updated_at:
				          ((aPull at: #updated_at) ifNotNil: #asDateAndTime);
			          created_at:
				          ((aPull at: #created_at) ifNotNil: #asDateAndTime);
			          sha: (aPull at: #head at: #sha);
			          merge_commit_sha: (aPull at: #merge_commit_sha) ].
	result := self glhModel addAll: result unless: self blockOnIdEquality.
	^ result
]

{ #category : #parsing }
GithubModelImporter >> parsePipelineResult: result [
	
	| reader |
	reader := generalReader on: result readStream. 
	^ reader nextAs: GLHPipeline .
	
]

{ #category : #parsing }
GithubModelImporter >> parsePipelinesResult: pipelineOverview [

	"in github, Actions runs (pipeline) are returns in an overview objects"

	| reader |
	reader := generalReader on: pipelineOverview readStream.

	reader for: GHAPIPipelineOverview do: [ :mapping |
		mapping mapInstVar: #total_count to: #total_count.
		(mapping mapInstVar: #workflow_runs) valueSchema: #ArrayOfPipeline.
		(mapping mapInstVar: #jobs) valueSchema: #ArrayOfJob ].


	^ reader nextAs: GHAPIPipelineOverview
]

{ #category : #parsing }
GithubModelImporter >> parseProjectResult: aResult [

	| reader |

	reader := generalReader on: aResult readStream.

	^ reader nextAs: GLHProject
]

{ #category : #parsing }
GithubModelImporter >> parseUserResult: result [

	| reader |
	reader := generalReader on: result readStream.

	^ reader nextAs: GLHUser
]

{ #category : #api }
GithubModelImporter >> privateToken [
	^ self api privateToken
]

{ #category : #api }
GithubModelImporter >> privateToken: aTokenString [
	^ self repoApi privateToken: aTokenString
]
