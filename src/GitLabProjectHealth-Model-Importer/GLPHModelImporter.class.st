Class {
	#name : #GLPHModelImporter,
	#superclass : #GLHModelImporter,
	#category : #'GitLabProjectHealth-Model-Importer'
}

{ #category : #'private - api' }
GLPHModelImporter >> completeImportProject: aGLHProject [

	super completeImportProject: aGLHProject.
	self importMergeRequests: aGLHProject
]

{ #category : #import }
GLPHModelImporter >> importMergeRequests: aGLHProject [

	| results parsedResults |
	results := self glhApi mergeRequestOfProject: aGLHProject id .
	parsedResults := self parseMergeRequestResult: results.
	1 halt.
	aGLHProject mergeRequests addAll: parsedResults.
	
	self withCommitDiffs ifTrue: [
		aGLHProject repository commits do: [ :commit |
			self importDiffOfCommit: commit ] ]
]

{ #category : #'as yet unclassified' }
GLPHModelImporter >> importProject: aProjectID [
]

{ #category : #initialization }
GLPHModelImporter >> initialize [

	super initialize.
	withCommitDiffs := true
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
