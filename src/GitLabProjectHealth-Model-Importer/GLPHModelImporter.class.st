Class {
	#name : #GLPHModelImporter,
	#superclass : #GLHModelImporter,
	#category : #'GitLabProjectHealth-Model-Importer'
}

{ #category : #'as yet unclassified' }
GLPHModelImporter >> blockForDiffRangeEquality [

	^ [ :existing :new |
	  existing diff mooseID = new diff mooseID and: [
		  existing originalLineRange = new originalLineRange and: [
			  existing newLineRange = new newLineRange ] ] ]
]

{ #category : #commit }
GLPHModelImporter >> chainsCommitsFrom: commitsCollection [

	| dic |
	
	('Chains ', commitsCollection size printString , ' commits') recordInfo.
	
	dic := ((self glhModel allWithType: GLHCommit) collect: [ :commit |
		        commit id -> commit ]) asSet asDictionary.

	commitsCollection do: [ :commit |
		commit parent_ids do: [ :parentId | 
			dic
				at: parentId
				ifPresent: [ :parentCommit |
					parentCommit childCommits
						add: commit
						unless: self blockOnIdEquality ]
				ifAbsent: [  ] ] ].
	^ commitsCollection
]

{ #category : #commit }
GLPHModelImporter >> commitsOfProject: aGLHProject forRefName: refName until: toDate [

	| newlyFoundCommit page |
	page := 0.
	newlyFoundCommit := { true }.
	[ newlyFoundCommit isNotEmpty ] whileTrue: [
		| results parsedResults existingCommits |
		page := page + 1.
		('import commit page ' , page printString) recordInfo.
		results := self glhApi
			           commitsOfProject: aGLHProject id
			           forRefName: refName
			           since: nil
			           until: nil
			           path: nil
			           author: nil
			           all: nil
			           with_stats: nil
			           firstParent: nil
			           order: nil
			           trailers: nil
			           perPage: 100
			           page: page.
		parsedResults := self parseCommitsResult: results.
		existingCommits := aGLHProject mooseModel allWithType: GLHCommit.

		newlyFoundCommit := parsedResults reject: [ :commitParsed |
			                    (toDate isNil or: [
				                     commitParsed committed_date
				                     < toDate asDateAndTime ]) or: [
				                    existingCommits anySatisfy: [ :existingCommit |
					                    existingCommit id = commitParsed id ] ] ].
		self glhModel addAll: newlyFoundCommit unless: self blockOnIdEquality.
		aGLHProject repository commits addAll: newlyFoundCommit unless: self blockOnIdEquality  ].
	self withCommitDiffs ifTrue: [
		aGLHProject repository commits do: [ :commit |
			self importDiffOfCommit: commit ] ]
]

{ #category : #'private - api' }
GLPHModelImporter >> completeImportProject: aGLHProject [

	super completeImportProject: aGLHProject.

	"for this initial import, with only look at some but not all MR"
	withInitialMergeRequest ifTrue: [ self
		importMergeRequests: aGLHProject
		since: DateAndTime today
		until: DateAndTime now. ].

	^ aGLHProject
]

{ #category : #'private - configure reader' }
GLPHModelImporter >> configureReaderForMergeRequest: reader [
	"declare quil y a un array a mapper"

	reader for: #ArrayOfMergeRequest customDo: [ :customMappting |
		customMappting listOfElementSchema: GLPHEMergeRequest ].

	"declare la liste des properties"
	reader for: GLPHEMergeRequest do: [ :mapping |
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

{ #category : #import }
GLPHModelImporter >> importCommitsOfBranch: aGLHBranch [

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

{ #category : #import }
GLPHModelImporter >> importCommitsOfMergeResquest: aGLPHEMergeRequest [

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

{ #category : #api }
GLPHModelImporter >> importDiffOfCommit: aCommit [

	super importDiffOfCommit: aCommit.
	
	"changes are added into the model during the import"
	aCommit diffs do: [ :diff | self importDiffRangesForDiff: diff ].

	^ aCommit diffs
]

{ #category : #'as yet unclassified' }
GLPHModelImporter >> importDiffOfMergeRequest: aMergeRequest [

	| result diffsResult |
	aMergeRequest diffs ifNotEmpty: [
		'Diff of already importer: '
		, aMergeRequest iid printString recordInfo.
		^ aMergeRequest diffs ].
	('Import diff commits of MR ' , aMergeRequest iid printString)
		recordInfo.
	result := self glhApi
		          diffsMergeRequestOfProject: aMergeRequest project_id
		          withId: aMergeRequest iid.

	diffsResult := self parseDiffResult: result.


	aMergeRequest diffs
		addAll: diffsResult
		unless: self blockForDiffEquality.
	self glhModel
		addAll: aMergeRequest diffs
		unless: self blockForDiffEquality.

	aMergeRequest diffs do: [ :diff | self importDiffRangesForDiff: diff ].

	^ aMergeRequest diffs
]

{ #category : #import }
GLPHModelImporter >> importDiffRangesForDiff: aGLHDiff [

	| diffRanges |
	aGLHDiff diffRanges ifNotEmpty: [
		('Diffs already imported for ' , aGLHDiff printString) recordInfo.
		^ aGLHDiff diffRanges ].

	('Import changes of diff ' , aGLHDiff printString) recordInfo.
	"the import of 'diffRanges' entites is technically done inside the parseDiffString"

	diffRanges := self glhModel
		              addAll: (self parseDiffString: aGLHDiff)
		              unless: self blockForDiffRangeEquality.
	^ aGLHDiff diffRanges
		  addAll: diffRanges
		  unless: self blockForDiffRangeEquality
]

{ #category : #'import - merge request' }
GLPHModelImporter >> importMergeRequests: aGLHProject [

	| results parsedResults |
	('Import merge request of Project: ' , aGLHProject id printString)
		recordInfo.

	results := self glhApi mergeRequestOfProject: aGLHProject id.
	parsedResults := self parseMergeRequestResult: results.

	aGLHProject mergeRequests
		addAll: parsedResults
		unless: self blockOnIdEquality.

	self glhModel
		addAll: aGLHProject mergeRequests
		unless: self blockOnIdEquality.


	"gets it related commits"
	aGLHProject mergeRequests do: [ :mr |
		self importCommitsOfMergeResquest: mr ].


	self withCommitDiffs ifTrue: [
		aGLHProject mergeRequests do: [ :mr |
			self importDiffOfMergeRequest: mr ] ]
]

{ #category : #'import - merge request' }
GLPHModelImporter >> importMergeRequests: aGLHProject since: fromDate until: toDate [

	| newlyFoundMR page foundMR |
	('import MR of Project ' , aGLHProject name) recordInfo.

	page := 0.
	foundMR := OrderedCollection new.
	newlyFoundMR := { true }.
	[ newlyFoundMR isNotEmpty ] whileTrue: [
		| results |
		page := page + 1.
		('import MR page ' , page printString) recordInfo.
		results := self glhApi
			           mergeRequestsOfProject: aGLHProject id
			           createdAfter:
			           (fromDate ifNotNil: [ fromDate asDateAndTime asString ])
			           createdBefore:
			           (toDate ifNotNil: [ toDate asDateAndTime asString ])
			           authorId: nil
			           authorUsername: nil
			           scope: 'all'
			           orderBy: 'created_at'
			           page: page.


		newlyFoundMR := aGLHProject mergeRequests
			                addAll: (self parseMergeRequestResult: results)
			                unless: self blockOnIdEquality.
		foundMR addAll: newlyFoundMR ].


	"gets it related commits"
	aGLHProject mergeRequests do: [ :mr |
		self importCommitsOfMergeResquest: mr ].

	self withCommitDiffs ifTrue: [
		aGLHProject mergeRequests do: [ :mr |
			self importDiffOfMergeRequest: mr ] ].
	
	self glhModel addAll: foundMR unless: (self blockEqualityOn: #iid).

	^ foundMR
]

{ #category : #'import - merge request' }
GLPHModelImporter >> importMergeResquestApprovals: aGLPHEMergeRequest [

	| results parsedResult |
	(String streamContents: [ :str |
		 str << 'Check approvals of '.
		 aGLPHEMergeRequest printOn: str ]) recordInfo.
	results := self glhApi
		           approvalsOfMergeQuest: aGLPHEMergeRequest iid
		           ofProject: aGLPHEMergeRequest project id.

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
GLPHModelImporter >> importMergeResquestAuthor: aGLPHEMergeRequest [

	| authorID |
	aGLPHEMergeRequest author ifNotNil: [ ^ aGLPHEMergeRequest author ].
	authorID := aGLPHEMergeRequest cacheAt: #authorID ifAbsent: [
		            (generalReader
			             on: (self glhApi
					              mergeRequestOfProject:
						              aGLPHEMergeRequest project_id
					              withId: aGLPHEMergeRequest iid) readStream;
			             next) at: #author at: #id ].
	aGLPHEMergeRequest author: (self importUser: authorID)
]

{ #category : #'import - merge request' }
GLPHModelImporter >> importMergeResquestMerger: aGLPHEMergeRequest [

	| authorID |
	aGLPHEMergeRequest merge_user ifNotNil: [
		^ aGLPHEMergeRequest merge_user ].
	authorID := aGLPHEMergeRequest cacheAt: #mergeUserID ifAbsent: [
		            (generalReader
			             on: (self glhApi
					              mergeRequestOfProject:
						              aGLPHEMergeRequest project_id
					              withId: aGLPHEMergeRequest iid) readStream;
			             next)
			            at: #merge_user
			            ifPresent: [ :mergeUser |
			            mergeUser ifNotNil: [ :mruser | mruser at: #id ] ] ].
	aGLPHEMergeRequest merge_user: (self importUser: authorID)
]

{ #category : #'as yet unclassified' }
GLPHModelImporter >> importProject: aProjectID [

	| result projectResult |
	('Import project with id:  ' , aProjectID printString) recordInfo.

	result := self glhApi project: aProjectID.
	projectResult := self parseProjectResult: result.

	^ self completeImportProject: projectResult
]

{ #category : #'private - api' }
GLPHModelImporter >> importRepository: aGLHRepository [

	super importRepository: aGLHRepository.

	withInitialCommits ifTrue: [
		aGLHRepository branches do: [ :branch |
			self importCommitsOfBranch: branch ] ]
]

{ #category : #initialization }
GLPHModelImporter >> initReader [

	super initReader.
	self configureReaderForMergeRequest: generalReader
]

{ #category : #initialization }
GLPHModelImporter >> initialize [

	super initialize.
	withCommitDiffs := true
]

{ #category : #parsing }
GLPHModelImporter >> parseDiffString: aDiff [
	"parse diff string to create entities for each lines"

	| lines range index firstChangeRange |
	lines := aDiff diffString lines.
	index := 0.
	range := nil.

	lines ifEmpty: [ ^ aDiff diffRanges ].
	lines := self filterCommitChanges: lines.
	(lines first beginsWith: '@@') ifFalse: [ ^ aDiff diffRanges ].

	lines do: [ :line |
		| aChange |
		firstChangeRange := false.
		(line trim beginsWith: #'@@') ifTrue: [
			range := GLPHEDiffRange newFrom: line.
			firstChangeRange := true.
			range := aDiff diffRanges add: range unless: [ :existing :new |
				         existing originalLineRange = new originalLineRange and: [
					         existing newLineRange = new newLineRange ] ] ].

		self withCommitDiffs ifTrue: [
			firstChangeRange ifFalse: [
				aChange := GLPHEChange newFrom: line.
				aChange relativeIndex: index.
				aChange := range changes add: aChange unless: [ :existing :new |
					           existing sourceCode = new sourceCode and: [
						           existing index = new index ] ].
				index := index + 1 ] ] ].

	"add changes to the diff range"
	aDiff diffRanges do: [ :diffRange |
		self glhModel addAll: diffRange changes unless: [ :existing :new |
			existing diffRange mooseID = new diffRange mooseID and: [
				existing sourceCode = new sourceCode and: [
					existing index = new index ] ] ] ].

	^ aDiff diffRanges
]

{ #category : #parsing }
GLPHModelImporter >> parseMergeRequestResult: result [

	generalReader on: result readStream.
	^ generalReader nextAs: #ArrayOfMergeRequest
]

{ #category : #parsing }
GLPHModelImporter >> parseProjectResult: aResult [ 
		| reader |
	reader := NeoJSONReader on: aResult readStream.
	reader for: GLHProject do: [ :mapping |
		mapping mapInstVars. ].
"	reader mapInstVarsFor: GLHProject."

	^ reader nextAs: GLHProject
]

{ #category : #accessing }
GLPHModelImporter >> withCommitsSince: someDays [
	"substract the current date with a given number of days. Use to retrieve the commits submit in the last giving days"
	"(GLPHModelImporter new withCommitsSince: 1 week ) >>> (Date today - 1 week) asDateAndTime"
	"(GLPHModelImporter new withCommitsSince: 30 day ) >>> (Date today - 30 day) asDateAndTime"
	withCommitsSince := (Date today - someDays) asDateAndTime
]
