Class {
	#name : #GithubModelImporter,
	#superclass : #GitModelImporter,
	#category : #'GitHubHealth-Model-Importer'
}

{ #category : #accessing }
GithubModelImporter >> api [

	self
		deprecated: 'Use #repoApi instead'
		on: '7 October 2024'
		in:
		'Pharo-11.0.0+build.726.sha.aece1b5473acf3830a0e082c1bc3a15d4ff3522b (64 Bit)'.

	^ repoApi
]

{ #category : #accessing }
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
GithubModelImporter >> configureReaderForBranches: reader [

	reader mapInstVarsFor: GLHBranch.


	reader for: GLHBranch do: [ :mapping |
		mapping
			mapProperty: #sha
			getter: [ :branch | #ignore ]
			setter: [ :branch :value |
							 branch sha: (value at: #sha).
							]].


	reader
		for: #ArrayOfBranches
		customDo: [ :customMappting |
		customMappting listOfElementSchema: GLHBranch ]
]

{ #category : #'private - configure reader' }
GithubModelImporter >> configureReaderForCommit: reader [

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
						glhCommit commitCreator: (self importUser: authorId) ] ] ].

		mapping
			mapProperty: #committer
			getter: [ :object | #ignore ]
			setter: [ :glhCommit :value |
				value ifNotNil: [ glhCommit committer_name: (value at: #login) ] ].

		(mapping mapInstVar: #parent_ids to: #parents) valueSchema:
			#ArrayOfIds ].

	reader for: DateAndTime customDo: [ :mapping |
		mapping decoder: [ :string | DateAndTime fromString: string ] ].

	reader for: #ArrayOfIds customDo: [ :mapping |
		mapping decoder: [ :parents |
			parents collect: [ :parent | parent at: #sha ] ] ].

	reader
		for: #ArrayOfCommits
		customDo: [ :customMappting |
		customMappting listOfElementSchema: GLHCommit ]
]

{ #category : #'private - configure reader' }
GithubModelImporter >> configureReaderForMergeRequest: reader [
	"	reader mapInstVarsFor: GLHProject. "

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
					object cacheAt: #mergeUserID put: (value at: #id) ] ]
		
		].
	

	reader for: #ArrayOfMergeRequest customDo: [ :customMappting |
		customMappting listOfElementSchema: GLHMergeRequest ].

]

{ #category : #'private - configure reader' }
GithubModelImporter >> configureReaderForProject: reader [

"	reader mapInstVarsFor: GLHProject. "

	reader for: GLHProject do: [ :mapping | 
		mapping mapInstVar: #name to: #name.
		mapping mapInstVar: #description to: #description.
		mapping mapInstVar: #id to: #id.
		mapping mapInstVar: #archived to: #archived.
		mapping mapInstVar: #web_url to: #html_url.
		mapping mapInstVar: #topics to: #topics ].

	reader
		for: #ArrayOfProjects 
		customDo: [ :customMappting |
		customMappting listOfElementSchema: GLHProject ].
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

{ #category : #api }
GithubModelImporter >> ensureGroupNamed: aGroupName [

	^ self glhModel
		  detect: [ :a |
		  (a isKindOf: GLHGroup) and: [ a name = aGroupName ] ]
		  ifNone: [ self glhModel newGroupNamed: aGroupName ]
]

{ #category : #'import - repositories' }
GithubModelImporter >> importBranchesOf: aGLHProject [
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
		branches do: [ :branch | self importFilesOfBranch: branch ] ]
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

{ #category : #'import - commits' }
GithubModelImporter >> importDiffOfCommit: aGLHCommit [

	| result diffsResult |
	aGLHCommit diffs ifNotEmpty: [
		'Diff already importer: '
		, aGLHCommit short_id printString recordInfo.
		^ aGLHCommit diffs ].
	('Import diff of commit: ' , aGLHCommit short_id printString)
		recordInfo.
	result := self repoApi
		          commit: aGLHCommit id
		          ofOrganisation: aGLHCommit repository project group name
		          ofProject: aGLHCommit repository project name.
	diffsResult := self parseDiffresult: result.

	^ aGLHCommit diffs
		  addAll: diffsResult
		  unless: self blockForDiffEquality
]

{ #category : #api }
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

{ #category : #api }
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

{ #category : #'import - merge request' }
GithubModelImporter >> importMergeRequestsOfProject: aProject [ 
	|response mergeRequests|
	response := self repoApi 
			mergeRequestsOfRepo: aProject group name 
			ofProject: aProject name.
	mergeRequests := self parseMergeRequestsResult: response. 
	
	mergeRequests := aProject mergeRequests addAll:mergeRequests unless: self blockOnIdEquality.
	^ mergeRequests
	
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
	result := self repoApi organization: aGroupName repo: aProjectName.
	projectResult := self parseProjectResult: result.
	projectResult group: group.
	self glhModel add: projectResult.
	self completeImportedProject: projectResult.
	^ projectResult
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

{ #category : #initialization }
GithubModelImporter >> initReader [

	generalReader := NeoJSONReader new.
	
	"will be reuse for all reader next"
	generalReader for: DateAndTime customDo: [ :mapping |
		mapping decoder: [ :string |
			string ifNil: [ nil ] ifNotNil: [ DateAndTime fromString: string ] ] ].
	
	
	self configureReaderForProject: generalReader.
	self configureReaderForCommit: generalReader.
	self configureReaderForBranches: generalReader
]

{ #category : #initialization }
GithubModelImporter >> initialize [

	super initialize.
	self repoApi: GithubApi new.
	self repoApi output: 'json'.
	self withCommitDiffs: false.
	withFiles := false.
	
	self initReader
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
	
	^ reader nextAs: #ArrayOfProjects
]

{ #category : #parsing }
GithubModelImporter >> parseBranchesResult: arrayOfBranch [

	| reader |
	reader := generalReader on: arrayOfBranch readStream.
	
	^ reader nextAs: #ArrayOfBranches
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

	^ reader nextAs: #ArrayOfCommits
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
	reader := NeoJSONReader on: aResult readStream.
	reader for: GLHGroup do: [ :mapping | 
		mapping mapInstVar: #name to: #login.
		mapping mapInstVar: #description to: #description.
		mapping mapInstVar: #id to: #id.
		mapping mapInstVar: #web_url to: #html_url ].
	^ reader nextAs: GLHGroup
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
GithubModelImporter >> parsePipelinesResult: pipelineOverview [

	| reader |
	reader := NeoJSONReader on: pipelineOverview readStream.
	
	reader for: GHAPIPipelineOverview do: [ :mapping |
		mapping mapInstVar: #total_count to: #total_count.
		(mapping mapInstVar: #workflow_runs) valueSchema: #ArrayOfPipelines ].
	
	reader
		for: #ArrayOfPipelines
		customDo: [ :customMappting |
		customMappting listOfElementSchema: GLHPipeline ].
	
	reader for: GLHPipeline do: [ :mapping |
		mapping
			mapInstVar: #status to: #conclusion;
			mapProperty: #run_started_at
			getter: [ :object | #ignore ]
			setter: [ :object :value |
				object runDate: (DateAndTime fromString: value) ] ].
	
	^ reader nextAs: GHAPIPipelineOverview
]

{ #category : #parsing }
GithubModelImporter >> parseProjectResult: aResult [

	| reader |
"	reader := NeoJSONReader on: aResult readStream.
	reader for: GLHProject do: [ :mapping |
		mapping mapInstVar: #name to: #name.
		mapping mapInstVar: #description to: #description.
		mapping mapInstVar: #id to: #id.
		mapping mapInstVar: #archived to: #archived.
		mapping mapInstVar: #web_url to: #html_url.
		mapping mapInstVar: #topics to: #topics ].
	^ reader nextAs: GLHProject"
	
	reader := generalReader on: aResult readStream.
	
	^ reader nextAs: GLHProject
]

{ #category : #parsing }
GithubModelImporter >> parseUserResult: result [

	| reader |
	reader := NeoJSONReader on: result readStream.
	reader for: GLHUser do: [ :mapping |
		mapping mapInstVar: #id to: #id.
		mapping mapInstVar: #public_email to: #email.
		mapping mapInstVar: #username to: #login.
		mapping mapInstVar: #bio to: #bio.
		mapping mapInstVar: #organization to: #company.
		mapping mapInstVar: #followers to: #followers.
		mapping mapInstVar: #following to: #following.
		mapping mapInstVar: #web_url to: #html_url.
		mapping mapInstVar: #name to: #name.
		mapping mapInstVar: #avatar_url to: #avatar_url ].
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
