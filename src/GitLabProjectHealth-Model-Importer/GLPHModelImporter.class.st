Class {
	#name : #GLPHModelImporter,
	#superclass : #GLHModelImporter,
	#category : #'GitLabProjectHealth-Model-Importer'
}

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
GLPHModelImporter >> importChangesForDiff: aGLHDiff [ 
	|result|
	('Import changes of diff ' , aGLHDiff printString) recordInfo.
	self parseDiffString: aGLHDiff. 
	
	^ aGLHDiff changes.

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
		          until: Date today.

	commits do: [ :aCommit |
		| diffs |
		('Import diff of commit: ' , aCommit short_id printString)
			recordInfo.
		diffs := self importDiffOfCommit: aCommit.
		aCommit diffs addAll: diffs.
		aCommit mooseModel addAll: diffs.

		diffs do: [ :diff |
			| changes |
			"changes are added into the model during the import"
			self importChangesForDiff: diff ] ]
]

{ #category : #commit }
GLPHModelImporter >> importCommitsOfBranch: aGLHBranch forRefName: refName until: toDate [

	| newlyFoundCommit page |
	page := 0.
	newlyFoundCommit := { true }.
	[ newlyFoundCommit isNotEmpty ] whileTrue: [
		| results parsedResults existingCommits |
		page := page + 1.
		('import commit page ' , page printString) recordInfo.
		results := self glhApi
			           commitsOfProject: aGLHBranch repository project id
			           forRefName: aGLHBranch name
			           since: nil
			           until: toDate asDateAndTime asString
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
		existingCommits := aGLHBranch commits.


		newlyFoundCommit := parsedResults reject: [ :commitParsed |
			                    existingCommits anySatisfy: [ :existingCommit |
				                    existingCommit id = commitParsed id ] ].

		"newlyFoundCommit := self parseCommitsResult: results."

		aGLHBranch mooseModel addAll: newlyFoundCommit.
		aGLHBranch commits addAll: newlyFoundCommit ].

	aGLHBranch commits do: [ :commit |
		commit repository: aGLHBranch repository.
		commit repository project: aGLHBranch repository project ].
	^ aGLHBranch commits
]

{ #category : #'as yet unclassified' }
GLPHModelImporter >> importDiffOfMergeRequest: aMergeRequest [

	| result diffsResult |
	
	aMergeRequest diffs ifNotEmpty: [
		'Diff of already importer: '
		, aMergeRequest iid printString recordInfo.
		^ aMergeRequest diffs ].
	('Import diff of mergeRequest ' , aMergeRequest iid printString) recordInfo.
	result := self glhApi
		          diffsMergeRequestOfProject: (aMergeRequest project_id)
		          withId: aMergeRequest iid.
	
	diffsResult := self parseDiffResult: result.
	aMergeRequest diffs addAll: diffsResult.
	aMergeRequest mooseModel addAll: aMergeRequest diffs.
	
	aMergeRequest diffs do: [ :diff |
		self importChangesForDiff: diff.
		 ].
	
	^ diffsResult
]

{ #category : #import }
GLPHModelImporter >> importMergeRequests: aGLHProject [

	| results parsedResults |
	results := self glhApi mergeRequestOfProject: aGLHProject id.
	parsedResults := self parseMergeRequestResult: results.

	aGLHProject mergeRequests addAll: parsedResults.
	aGLHProject mooseModel addAll: aGLHProject mergeRequests.

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

{ #category : #initialization }
GLPHModelImporter >> initialize [

	super initialize.
	withCommitDiffs := true
]

{ #category : #parsing }
GLPHModelImporter >> parseDiffString: aDiff [

	| lines range index |
	lines := aDiff diffString lines.
	index := 0.
	lines do: [ :line |
		| aChange |
		aChange := GLPHEChange newFrom: line.
		(line trim beginsWith: #'@@') ifTrue: [
			range := GLPHEDiffRange newFrom: line.
			range diff: aDiff.
			aDiff mooseModel add: range ].

		aChange diffRange: range.
		aChange relativeIndex: index.
		index := index + 1.
		aDiff mooseModel add: aChange.
		aChange ].
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
