Class {
	#name : #GLPHModelImporter,
	#superclass : #GLHModelImporter,
	#category : #'GitLabProjectHealth-Model-Importer'
}

{ #category : #commit }
GLPHModelImporter >> chainsCommitsFrom: commitsCollection [

	commitsCollection do: [ :commit |
		commit parent_ids do: [ :parentId |
			| parentCommit |
			parentCommit := (self glhModel allWithType: GLHCommit)
				                detect: [ :c | c id = parentId ]
				                ifNone: [ nil ].
			parentCommit ifNotNil: [
			
				parentCommit childCommits add: commit unless: [ :existing :new | existing id = new id ].
					
				"parentCommit childCommits
					detect: [ :c | c id = commit id ]
					ifNone: [ parentCommit addChildCommit: commit ] "] ] ]
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
		aGLHProject mooseModel addAll: newlyFoundCommit.
		aGLHProject repository commits addAll: newlyFoundCommit ].
	self withCommitDiffs ifTrue: [
		aGLHProject repository commits do: [ :commit |
			self importDiffOfCommit: commit ] ]
]

{ #category : #'private - api' }
GLPHModelImporter >> completeImportProject: aGLHProject [

	super completeImportProject: aGLHProject.

	self importMergeRequests: aGLHProject.
	

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
		| diffs |
		(self importUserByUsername: aCommit author_name) commits
			add: aCommit
			unless: [ :existingCommit :newCommit |
			existingCommit id = newCommit id ].

		aCommit repository: aGLHBranch repository.

		('Import diff of commit: ' , aCommit short_id printString)
			recordInfo.

		diffs := self importDiffOfCommit: aCommit.
		self glhModel addAll: diffs unless: [ :existing :new |
			existing diffString size = new diffString size and: [
				existing diffString = new diffString ] ].

		diffs do: [ :diff | "changes are added into the model during the import"
			self importDiffRangesForDiff: diff ] ]
]

{ #category : #commit }
GLPHModelImporter >> importCommitsOfBranch: aGLHBranch forRefName: refName since: fromDate [

	^ self
		  importCommitsOfBranch: aGLHBranch
		  forRefName: refName
		  since: fromDate
		  until: nil
]

{ #category : #commit }
GLPHModelImporter >> importCommitsOfBranch: aGLHBranch forRefName: refName since: fromDate until: toDate [

	| newlyFoundCommit page |
	page := 0.
	newlyFoundCommit := { true }.
	[ newlyFoundCommit isNotEmpty ] whileTrue: [
		| results |
		page := page + 1.
		('import commit page ' , page printString) recordInfo.
		results := self glhApi
			           commitsOfProject: aGLHBranch repository project id
			           forRefName: aGLHBranch name
			           since:
			           (fromDate ifNotNil: [ fromDate asDateAndTime asString ])
			           until:
			           (toDate ifNotNil: [ toDate asDateAndTime asString ])
			           path: nil
			           author: nil
			           all: nil
			           with_stats: nil
			           firstParent: nil
			           order: nil
			           trailers: nil
			           perPage: 100
			           page: page.

		newlyFoundCommit := self parseCommitsResult: results.
		aGLHBranch commits
			addAll: newlyFoundCommit
			unless: (self blockEqualityOn: #id) ].

	self glhModel
		addAll: aGLHBranch commits
		unless: [ :old :new | old id = new id ].

	^ aGLHBranch commits
]

{ #category : #commit }
GLPHModelImporter >> importCommitsOfBranch: aGLHBranch forRefName: refName until: toDate [

	^ self
		  importCommitsOfBranch: aGLHBranch
		  forRefName: refName
		  since: nil
		  until: toDate 
]

{ #category : #'as yet unclassified' }
GLPHModelImporter >> importDiffOfMergeRequest: aMergeRequest [

	| result diffsResult |
	aMergeRequest diffs ifNotEmpty: [
		'Diff of already importer: '
		, aMergeRequest iid printString recordInfo.
		^ aMergeRequest diffs ].
	('Import diff of mergeRequest ' , aMergeRequest iid printString)
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
	('Import changes of diff ' , aGLHDiff printString) recordInfo.
	diffRanges := self parseDiffString: aGLHDiff.
	
	self glhModel addAll: diffRanges unless: [ :existing :new |
		(existing diff mooseID = new diff mooseID and: [
			 existing originalLineRange = new originalLineRange ]) and: [
			existing newLineRange = new newLineRange ] ].

	^ aGLHDiff diffRanges
]

{ #category : #import }
GLPHModelImporter >> importMergeRequests: aGLHProject [

	| results parsedResults |
	results := self glhApi mergeRequestOfProject: aGLHProject id.
	parsedResults := self parseMergeRequestResult: results.

	1 halt.
	aGLHProject mergeRequests addAll: parsedResults unless: self blockOnIdEquality .
	self glhModel addAll: aGLHProject mergeRequests unless: self blockOnIdEquality.

	self withCommitDiffs ifTrue: [
		aGLHProject mergeRequests do: [ :mr |
			self importDiffOfMergeRequest: mr ] ]
]

{ #category : #'as yet unclassified' }
GLPHModelImporter >> importProject: aProjectID [
		| result projectResult |
	('Import group: ' , aProjectID printString) recordInfo.

	result := self glhApi project: aProjectID.
	projectResult := self parseProjectResult: result.
	
	^ self completeImportProject: projectResult
]

{ #category : #'private - api' }
GLPHModelImporter >> importRepository: aGLHRepository [

	super importRepository: aGLHRepository.

	aGLHRepository branches do: [ :branch |
		self importCommitsOfBranch: branch ].
]

{ #category : #user }
GLPHModelImporter >> importUserByUsername: anUsername [

	^ (self glhModel allWithType: GLHUser)
		  detect: [ :user | user username = anUsername ]
		  ifNone: [
			  | result userId searchResult |
			  ('Import user with username: ' , anUsername printString)
				  recordInfo.
			  result := self glhApi usersSearchByUsername: anUsername.
			  searchResult := NeoJSONReader fromString: result.
			  searchResult ifEmpty: [ GLHUser new ] ifNotEmpty: [
				  userId := searchResult first at: #id.
				  (self glhModel allWithType: GLHUser)
					  detect: [ :user | user id = userId ]
					  ifNone: [
						  self importUser: userId.
						   ] ] ]
]

{ #category : #initialization }
GLPHModelImporter >> initialize [

	super initialize.
	withCommitDiffs := true
]

{ #category : #parsing }
GLPHModelImporter >> parseDiffString: aDiff [
	"parse diff string to create entities for each lines"

	| lines range index |
	lines := aDiff diffString lines.
	index := 0.
	range := nil.
	lines do: [ :line |
		| aChange |
		(line trim beginsWith: #'@@') ifTrue: [
			range := GLPHEDiffRange newFrom: line.

			aDiff diffRanges add: range unless: [ :existing :new |
				existing originalLineRange = new originalLineRange and: [
					existing newLineRange = new newLineRange ] ]

			"	self glhModel 
				add: range 
				unless: [:existing :new | ((existing diff mooseID = new diff mooseID) 
					and: [existing originalLineRange = new originalLineRange]) 
					and: [ existing newLineRange = new newLineRange  ] 
					]." ].

		self withCommitDiffs ifTrue: [
			aChange := GLPHEChange newFrom: line.
			aChange relativeIndex: index.
			range changes add: aChange unless: [ :existing :new |
				existing sourceCode = new sourceCode and: [
					existing index = new index ] ].
			"self glhModel add: aChange ."
			index := index + 1 ] ].


	aDiff diffRanges do: [ :diffRange |
		self glhModel addAll: diffRange changes unless: [ :existing :new |
			(existing diffRange mooseID = new diffRange mooseID and: [
				 existing sourceCode = new sourceCode ]) and: [
				existing index = new index ] ] ].
	
^ aDiff diffRanges.
]

{ #category : #parsing }
GLPHModelImporter >> parseMergeRequestResult: result [ 
		| reader |
	reader := NeoJSONReader on: result readStream.
	
	"declare quil y a un array a mapper"
	reader
		for: #ArrayOfMergeRequest 
		customDo: [ :customMappting |
		customMappting listOfElementSchema: GLPHEMergeRequest ].
	
	"declare la liste des pro"
	reader for: GLPHEMergeRequest  do: [ :mapping |

		mapping mapInstVars:
			#( blocking_discussions_resolved
changes_count
description
detailed_merge_status
discussion_locked
downvotes
draft
first_deployed_to_production_at
force_remove_source_branch
has_conflicts
id
iid
labels
latest_build_finished_at
latest_build_started_at
merge_commit_sha
merge_status
merge_when_pipeline_succeeds
merged_at
milestone
project_id
reference
references_full
references_relative
references_short
sha
should_remove_source_branch
source_branch
source_project_id
squash
squash_commit_sha
squash_on_merge
state
subscribed
target_branch
target_project_id
task_completion_status_completed_count
task_completion_status_count
time_stats_human_time_estimate
time_stats_human_total_time_spent
time_stats_time_estimate
time_stats_total_time_spent
title
updated_at
upvotes
user_notes_count
web_url
work_in_progress).
"		(mapping mapInstVar: #closed_at) valueSchema: DateAndTime.
		(mapping mapInstVar: #created_at) valueSchema: DateAndTime.
		(mapping mapInstVar: #assignee) valueSchema: GLHUser.
		(mapping mapInstVar: #author) valueSchema: GLHUser.
		(mapping mapInstVar: #closed_by) valueSchema: GLHUser.
		(mapping mapInstVar: #mergeCommit) valueSchema: GLHCommit."

	"	mapping
			mapProperty: 'stats'
			getter: [ :el | ""Not used"" ]
			setter: [ :commit :value |
				commit deletions: (value at: #deletions).
				commit additions: (value at: #additions) ]
"
].
"	reader for: DateAndTime customDo: [ :mapping |
		mapping decoder: [ :string | DateAndTime fromString: string ] ]."
	
	^ reader nextAs: #ArrayOfMergeRequest
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
