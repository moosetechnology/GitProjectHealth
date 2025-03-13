Class {
	#name : #GitlabWithMergeRequestModelImporter,
	#superclass : #GitlabModelImporter,
	#category : #'GitLabProjectHealth-Model-Importer'
}

{ #category : #'import - commits' }
GitlabWithMergeRequestModelImporter >> commitsOfProject: aGLHProject forRefName: refName until: toDate [

	| params results allCommits |
	
	params := { 
		#ref_name -> refName.
		#until -> (toDate ifNotNil: [ toDate asDateAndTime asString ] ifNil: [ '' ]) 
	} asDictionary.
	results := self repoApi commits getAllInProject: aGLHProject id withParams: params.
	allCommits := (results collect: [ :commitsJson | self parseCommitsResult: commitsJson ]) flattened.
	
	self glhModel addAll: allCommits unless: self blockOnIdEquality.
	aGLHProject repository commits addAll: allCommits unless: self blockOnIdEquality.

	self withCommitDiffs ifTrue: [
		aGLHProject repository commits do: [ :commit |
			self importDiffOfCommit: commit ] ].
	
	^allCommits
]

{ #category : #'private - api' }
GitlabWithMergeRequestModelImporter >> completeImportProject: aGLHProject [

	| completedProject |
	completedProject := super completeImportProject: aGLHProject.
	"for this initial import, with only look at some but not all MR"
	withInitialMergeRequest ifTrue: [
		self
			importMergeRequests: completedProject
			since: DateAndTime today
			until: DateAndTime now ].

	^ completedProject
]

{ #category : #'private - configure reader' }
GitlabWithMergeRequestModelImporter >> configureReaderForMergeRequest: reader [
	"declare quil y a un array a mapper"

	reader for: #ArrayOfMergeRequest customDo: [ :customMappting |
		customMappting listOfElementSchema: GLHMergeRequest ].

	"declare la liste des properties"
	reader for: GLHMergeRequest do: [ :mapping |
		mapping mapInstVars:
			#( blocking_discussions_resolved changes_count description
			   detailed_merge_status discussion_locked downvotes draft first_deployed_to_production_at
			   force_remove_source_branch has_conflicts id iid labels latest_build_finished_at
			   latest_build_started_at merge_commit_sha merge_status
			   merge_when_pipeline_succeeds merged_at milestone project_id
			   reference references_full references_relative
			   references_short sha should_remove_source_branch
			   source_branch source_project_id squash squash_commit_sha
			   squash_on_merge state subscribed target_branch target_project_id
			   task_completion_status_completed_count
			   task_completion_status_count time_stats_human_time_estimate
			   time_stats_human_total_time_spent
			   time_stats_time_estimate time_stats_total_time_spent
			   title updated_at upvotes user_notes_count web_url work_in_progress ).
		(mapping mapInstVar: #created_at) valueSchema: DateAndTime.
		(mapping mapInstVar: #updated_at) valueSchema: DateAndTime.
		(mapping mapInstVar: #merged_at) valueSchema: DateAndTime.
		(mapping mapInstVar: #closed_at) valueSchema: DateAndTime.
		"(mapping mapInstVar: #assignee) valueSchema: GLHUser."
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

	"(mapping mapInstVar: #closed_by) valueSchema: GLHUser.
	(mapping mapInstVar: #mergeCommit) valueSchema: GLHCommit."
	"indique ce que doit faire le reader lorsqu'il parse une DateAndTime object"
	reader for: DateAndTime customDo: [ :mapping |
		mapping decoder: [ :string |
			string ifNil: [ nil ] ifNotNil: [ DateAndTime fromString: string ] ] ]
]

{ #category : #'import - commits' }
GitlabWithMergeRequestModelImporter >> importCommitsOfBranch: aGLHBranch [

	| commits |
	"	result := self glhApi
		          commitsOfProject: aGLHBranch repository project id
		          forRefName: aGLHBranch name."
	commits := self
		           importCommitsOfBranch: aGLHBranch
		           forRefName: aGLHBranch name
		           since: withCommitsSince.

	self chainsCommitsFrom: commits.

	commits do: [ :aCommit |
		aCommit repository: aGLHBranch repository.
		self completeImportedCommit: aCommit. 
		 ]
]

{ #category : #'import - commits' }
GitlabWithMergeRequestModelImporter >> importDiffOfCommit: aCommit [

	super importDiffOfCommit: aCommit.
	
	"changes are added into the model during the import"
	aCommit diffs do: [ :diff | self importDiffRangesForDiff: diff ].

	^ aCommit diffs
]

{ #category : #'import - merge request' }
GitlabWithMergeRequestModelImporter >> importDiffOfMergeRequest: aMergeRequest [

	| result diffsResult |
	aMergeRequest diffs ifNotEmpty: [
		'Diff of already importer: '
		, aMergeRequest iid printString recordInfo.
		^ aMergeRequest diffs ].
	('Import diff commits of MR ' , aMergeRequest iid printString)
		recordInfo.
	result := self repoApi mergeRequests diffsOf: aMergeRequest iid inProject: aMergeRequest project_id.

	diffsResult := self newParseDiffResult: result.


	aMergeRequest diffs
		addAll: diffsResult
		unless: self blockForDiffEquality.
	self glhModel
		addAll: aMergeRequest diffs
		unless: self blockForDiffEquality.

	aMergeRequest diffs do: [ :diff | self importDiffRangesForDiff: diff ].

	^ aMergeRequest diffs
]

{ #category : #'import - merge request' }
GitlabWithMergeRequestModelImporter >> importMergeRequestCommits: aGLPHEMergeRequest [

	| commits result |
	aGLPHEMergeRequest commits ifNotNil: [ ^ aGLPHEMergeRequest commits ].
	
	result := self repoApi mergeRequests commitsOf: aGLPHEMergeRequest iid inProject: aGLPHEMergeRequest project id.
	
	commits := (result collect: [ :commitsJson | self parseCommitsResult: commitsJson ]) flattened.
	commits := commits collect: [ :commit | self importCommit: commit id ofProject: aGLPHEMergeRequest project ].
	aGLPHEMergeRequest commits: commits.


	^ commits
]

{ #category : #'import - merge request' }
GitlabWithMergeRequestModelImporter >> importMergeRequestMergeCommits: aGLPHEMergeRequest [

	| foundCommits |
	foundCommits := OrderedCollection new.

	('Import commit sha of MR:  ' , aGLPHEMergeRequest iid printString)
		recordInfo.
	"the founds commits are added to the model during their respective import"
	aGLPHEMergeRequest mergeRequestCommit: ((self
			  importCommitOfProject: aGLPHEMergeRequest project
			  withId: aGLPHEMergeRequest sha) ifNotNil: [ :commit |
			 foundCommits add: commit ]).

	('Import commit merge_commit_sha of MR:  '
	 , aGLPHEMergeRequest iid printString) recordInfo.
	aGLPHEMergeRequest mergedCommit: ((self
			  importCommitOfProject: aGLPHEMergeRequest project
			  withId: aGLPHEMergeRequest merge_commit_sha) ifNotNil: [ :commit |
			 foundCommits add: commit ]).

	('Import commit squash_commit_sha of MR:  '
	 , aGLPHEMergeRequest iid printString) recordInfo.
	aGLPHEMergeRequest squashCommit: ((self
			  importCommitOfProject: aGLPHEMergeRequest project
			  withId: aGLPHEMergeRequest squash_commit_sha) ifNotNil: [ :commit |
			 foundCommits add: commit ]).


	self chainsCommitsFrom: foundCommits.
	^ foundCommits
]

{ #category : #'import - merge request' }
GitlabWithMergeRequestModelImporter >> importMergeRequests: aGLHProject [

	| results parsedResults mrs |
	('Import merge request of Project: ' , aGLHProject id printString)
		recordInfo.

	results := self repoApi mergeRequests allOfProject: aGLHProject id.
	parsedResults := (results collect: [ :projectsJson | self parseMergeRequestResult: projectsJson ]) flattened. 

	aGLHProject mergeRequests
		addAll: parsedResults
		unless: self blockOnIdEquality.

	mrs := self glhModel
		       addAll: aGLHProject mergeRequests
		       unless: self blockOnIdEquality.


	"gets it related commits"
	aGLHProject mergeRequests do: [ :mr |
		self importMergeRequestMergeCommits: mr ].


	self withCommitDiffs ifTrue: [
		aGLHProject mergeRequests do: [ :mr |
			self importDiffOfMergeRequest: mr ] ].

	^ mrs
]

{ #category : #'import - merge request' }
GitlabWithMergeRequestModelImporter >> importMergeRequests: aGLHProject since: fromDate until: toDate [

	| params result mergeRequests |
	('import MR of Project ' , aGLHProject name) recordInfo.
	params := {
		          (#created_after
		           ->
		           (fromDate
			            ifNotNil: [ fromDate asDateAndTime asString ]
			            ifNil: [ '' ])).
		          (#created_before
		           ->
		           (toDate
			            ifNotNil: [ toDate asDateAndTime asString ]
			            ifNil: [ '' ])).
		          (#scope -> 'all') } asDictionary.

	result := self repoApi mergeRequests
		          allOfProject: aGLHProject id
		          withParams: params.
	mergeRequests := (result collect: [ :mergeRequestsJson |
		                  self parseMergeRequestResult: mergeRequestsJson ])
		                 flattened.

	aGLHProject mergeRequests
		addAll: mergeRequests
		unless: self blockOnIdEquality.

	"gets it related commits"
	aGLHProject mergeRequests do: [ :mr |
		self importMergeRequestMergeCommits: mr ].

	self withCommitDiffs ifTrue: [
		aGLHProject mergeRequests do: [ :mr |
			self importDiffOfMergeRequest: mr ] ].

	self glhModel
		addAll: mergeRequests
		unless: (self blockEqualityOn: #iid).

	^ mergeRequests
]

{ #category : #'import - merge request' }
GitlabWithMergeRequestModelImporter >> importMergeResquestApprovals: aGLPHEMergeRequest [

	| results parsedResult |
	(String streamContents: [ :str |
		 str << 'Check approvals of '.
		 aGLPHEMergeRequest printOn: str ]) recordInfo.
	results := self repoApi mergeRequests approvalsOf: aGLPHEMergeRequest iid inProject: aGLPHEMergeRequest project id.

	parsedResult := generalReader
		                on: results readStream;
		                next.

	(parsedResult at: #approved_by) do: [ :approvedUser |
		aGLPHEMergeRequest addApproved_by:
			(self importUser: ((approvedUser at: #user) at: #id)) ].
	aGLPHEMergeRequest approved: (parsedResult at: #approved).
	^ aGLPHEMergeRequest
]

{ #category : #'import - merge request' }
GitlabWithMergeRequestModelImporter >> importMergeResquestAuthor: aGLPHEMergeRequest [

	| authorID |
	aGLPHEMergeRequest author ifNotNil: [ ^ aGLPHEMergeRequest author ].
	authorID := aGLPHEMergeRequest cacheAt: #authorID ifAbsent: [
		            | result |
		            result := self repoApi mergeRequests
			                      get: aGLPHEMergeRequest iid
			                      inProject: aGLPHEMergeRequest project_id.

		            (generalReader
			             on: result readStream;
			             next) at: #author at: #id ].
	^aGLPHEMergeRequest author: (self importUser: authorID)
]

{ #category : #'import - merge request' }
GitlabWithMergeRequestModelImporter >> importMergeResquestMerger: aGLPHEMergeRequest [

	| authorID |
	aGLPHEMergeRequest merge_user ifNotNil: [
		^ aGLPHEMergeRequest merge_user ].
	authorID := aGLPHEMergeRequest cacheAt: #mergeUserID ifAbsent: [
		            | result |
		            result := self repoApi mergeRequests
			                      get: aGLPHEMergeRequest iid
			                      inProject: aGLPHEMergeRequest project_id.
		            (generalReader
			             on: result readStream;
			             next)
			            at: #merge_user
			            ifPresent: [ :mergeUser |
			            mergeUser ifNotNil: [ :mruser | mruser at: #id ] ] ].
	^aGLPHEMergeRequest merge_user: (self importUser: authorID)
]

{ #category : #'import - projects' }
GitlabWithMergeRequestModelImporter >> importProject: aProjectID [

	| result projectResult |
	('Import project with id:  ' , aProjectID printString) recordInfo.

	(glhModel allWithType: GLHProject)
		detect: [ :project | project id = aProjectID ]
		ifFound: [ :project | ^ project ].

	result := self repoApi projects get: aProjectID.
	projectResult := self parseProjectResult: result.

	^ self completeImportProject: projectResult
]

{ #category : #'private - api' }
GitlabWithMergeRequestModelImporter >> importRepository: aGLHRepository [

	super importRepository: aGLHRepository.

	withInitialCommits ifTrue: [
		aGLHRepository branches do: [ :branch |
			self importCommitsOfBranch: branch ] ]
]

{ #category : #initialization }
GitlabWithMergeRequestModelImporter >> initReader [

	super initReader.
	self configureReaderForMergeRequest: generalReader
]

{ #category : #initialization }
GitlabWithMergeRequestModelImporter >> initialize [

	super initialize.
	withCommitDiffs := true
]

{ #category : #'private - parsing' }
GitlabWithMergeRequestModelImporter >> parseMergeRequestResult: result [

	generalReader on: result readStream.
	^ generalReader nextAs: #ArrayOfMergeRequest
]

{ #category : #'private - parsing' }
GitlabWithMergeRequestModelImporter >> parseProjectResult: aResult [ 
		| reader |
	reader := NeoJSONReader on: aResult readStream.
	reader for: GLHProject do: [ :mapping |
		mapping mapInstVars. ].
"	reader mapInstVarsFor: GLHProject."

	^ reader nextAs: GLHProject
]

{ #category : #accessing }
GitlabWithMergeRequestModelImporter >> withCommitsSince: someDays [
	"substract the current date with a given number of days. Use to retrieve the commits submit in the last giving days"

	"(GLPHModelImporter new withCommitsSince: 1 week ) >>> (Date today - 1 week) asDateAndTime"

	"(GLPHModelImporter new withCommitsSince: 30 day ) >>> (Date today - 30 day) asDateAndTime"

	(someDays isKindOf: DateAndTime)
		ifTrue: [ withCommitsSince := someDays ]
		ifFalse: [
		withCommitsSince := (Date today - someDays) asDate asDateAndTime ]
]
