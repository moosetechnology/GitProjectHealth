"
a gitlab merge request

## Relations
======================

### Parents
| Relation | Origin | Opposite | Type | Comment |
|---|
| `project` | `GLPHEMergeRequest` | `mergeRequests` | `GLHProject` | |

### Other
| Relation | Origin | Opposite | Type | Comment |
|---|
| `assignee` | `GLPHEMergeRequest` | `currentlyAssignedMergeRequest` | `GLHUser` | |
| `assignees` | `GLPHEMergeRequest` | `assignedMergeRequests` | `GLHUser` | |
| `author` | `GLPHEMergeRequest` | `createdMergeRequests` | `GLHUser` | |
| `closed_by` | `GLPHEMergeRequest` | `closedMergeRequests` | `GLHUser` | |
| `diffs` | `GLPHEMergeRequest` | `mergeRequest` | `GLHDiff` | |
| `mergeCommit` | `GLPHEMergeRequest` | `commitedMergeRequest` | `GLHCommit` | |
| `merge_user` | `GLPHEMergeRequest` | `usedMerges` | `GLHUser` | |
| `merged_by` | `GLPHEMergeRequest` | `mergerOfMergeRequests` | `GLHUser` | |
| `pipeline` | `GLPHEMergeRequest` | `mergeResquest` | `GLHPipeline` | |
| `reviewers` | `GLPHEMergeRequest` | `reviewedMergeResquest` | `GLHUser` | |
| `squashCommit` | `GLPHEMergeRequest` | `squashedMergeRequest` | `GLHCommit` | |


## Properties
======================

| Name | Type | Default value | Comment |
|---|
| `blocking_discussions_resolved` | `Boolean` | nil | |
| `changes_count` | `String` | nil | |
| `closed_at` | `String` | nil | |
| `created_at` | `String` | nil | |
| `description` | `String` | nil | |
| `detailed_merge_status` | `String` | nil | |
| `discussion_locked` | `String` | nil | |
| `downvotes` | `Number` | nil | |
| `draft` | `Boolean` | nil | |
| `first_deployed_to_production_at` | `String` | nil | |
| `force_remove_source_branch` | `Boolean` | nil | |
| `has_conflicts` | `Boolean` | nil | |
| `id` | `Number` | nil | |
| `iid` | `Number` | nil | |
| `labels` | `Object` | nil | |
| `latest_build_finished_at` | `String` | nil | |
| `latest_build_started_at` | `String` | nil | |
| `merge_commit_sha` | `String` | nil | |
| `merge_status` | `String` | nil | |
| `merge_when_pipeline_succeeds` | `Boolean` | nil | |
| `merged_at` | `String` | nil | |
| `milestone` | `String` | nil | |
| `project_id` | `Number` | nil | |
| `reference` | `String` | nil | |
| `references_full` | `String` | nil | |
| `references_relative` | `String` | nil | |
| `references_short` | `String` | nil | |
| `sha` | `String` | nil | |
| `should_remove_source_branch` | `Boolean` | nil | |
| `source_branch` | `String` | nil | |
| `source_project_id` | `Number` | nil | |
| `squash` | `Boolean` | nil | |
| `squash_commit_sha` | `String` | nil | |
| `squash_on_merge` | `Boolean` | nil | |
| `state` | `String` | nil | |
| `subscribed` | `Boolean` | nil | |
| `target_branch` | `String` | nil | |
| `target_project_id` | `Number` | nil | |
| `task_completion_status_completed_count` | `Number` | nil | |
| `task_completion_status_count` | `Number` | nil | |
| `time_stats_human_time_estimate` | `String` | nil | |
| `time_stats_human_total_time_spent` | `String` | nil | |
| `time_stats_time_estimate` | `Number` | nil | |
| `time_stats_total_time_spent` | `Number` | nil | |
| `title` | `String` | nil | |
| `updated_at` | `String` | nil | |
| `upvotes` | `Number` | nil | |
| `user_notes_count` | `Number` | nil | |
| `web_url` | `String` | nil | |
| `work_in_progress` | `Boolean` | nil | |

"
Class {
	#name : #GLPHEMergeRequest,
	#superclass : #GLPHEEntity,
	#instVars : [
		'#blocking_discussions_resolved => FMProperty',
		'#changes_count => FMProperty',
		'#closed_at => FMProperty',
		'#created_at => FMProperty',
		'#description => FMProperty',
		'#detailed_merge_status => FMProperty',
		'#discussion_locked => FMProperty',
		'#downvotes => FMProperty',
		'#draft => FMProperty',
		'#first_deployed_to_production_at => FMProperty',
		'#force_remove_source_branch => FMProperty',
		'#has_conflicts => FMProperty',
		'#id => FMProperty',
		'#iid => FMProperty',
		'#labels => FMProperty',
		'#latest_build_finished_at => FMProperty',
		'#latest_build_started_at => FMProperty',
		'#merge_commit_sha => FMProperty',
		'#merge_status => FMProperty',
		'#merge_when_pipeline_succeeds => FMProperty',
		'#merged_at => FMProperty',
		'#milestone => FMProperty',
		'#project_id => FMProperty',
		'#reference => FMProperty',
		'#references_full => FMProperty',
		'#references_relative => FMProperty',
		'#references_short => FMProperty',
		'#sha => FMProperty',
		'#should_remove_source_branch => FMProperty',
		'#source_branch => FMProperty',
		'#source_project_id => FMProperty',
		'#squash => FMProperty',
		'#squash_commit_sha => FMProperty',
		'#squash_on_merge => FMProperty',
		'#state => FMProperty',
		'#subscribed => FMProperty',
		'#target_branch => FMProperty',
		'#target_project_id => FMProperty',
		'#task_completion_status_completed_count => FMProperty',
		'#task_completion_status_count => FMProperty',
		'#time_stats_human_time_estimate => FMProperty',
		'#time_stats_human_total_time_spent => FMProperty',
		'#time_stats_time_estimate => FMProperty',
		'#time_stats_total_time_spent => FMProperty',
		'#title => FMProperty',
		'#updated_at => FMProperty',
		'#upvotes => FMProperty',
		'#user_notes_count => FMProperty',
		'#web_url => FMProperty',
		'#work_in_progress => FMProperty'
	],
	#category : #'GLPHExtended-Model-Entities'
}

{ #category : #meta }
GLPHEMergeRequest class >> annotation [

	<FMClass: #MergeRequest super: #GLPHEEntity>
	<package: #'GLPHExtended-Model'>
	<generated>
	^ self
]

{ #category : #adding }
GLPHEMergeRequest >> addAssignee: anObject [
	<generated>
	^ self assignees add: anObject
]

{ #category : #adding }
GLPHEMergeRequest >> addDiff: anObject [
	<generated>
	^ self diffs add: anObject
]

{ #category : #adding }
GLPHEMergeRequest >> addReviewer: anObject [
	<generated>
	^ self reviewers add: anObject
]

{ #category : #accessing }
GLPHEMergeRequest >> assignee [
	"Relation named: #assignee type: #GLHUser opposite: #currentlyAssignedMergeRequest"

	<generated>
	<FMProperty: #assignee type: #GLHUser opposite: #currentlyAssignedMergeRequest>
	^ self attributeAt: #assignee ifAbsent: [ nil ]
]

{ #category : #accessing }
GLPHEMergeRequest >> assignee: anObject [

	<generated>
	self attributeAt: #assignee put: (FMMultivalueLink on: self update: #currentlyAssignedMergeRequest from: self assignee to: anObject).
]

{ #category : #accessing }
GLPHEMergeRequest >> assignees [
	"Relation named: #assignees type: #GLHUser opposite: #assignedMergeRequests"

	<generated>
	<derived>
	<FMProperty: #assignees type: #GLHUser opposite: #assignedMergeRequests>
	^ self attributeAt: #assignees ifAbsentPut: [ FMMultiMultivalueLink on: self opposite: #assignedMergeRequests ]
]

{ #category : #accessing }
GLPHEMergeRequest >> assignees: anObject [

	<generated>
	self assignees value: anObject
]

{ #category : #accessing }
GLPHEMergeRequest >> author [
	"Relation named: #author type: #GLHUser opposite: #createdMergeRequests"

	<generated>
	<FMProperty: #author type: #GLHUser opposite: #createdMergeRequests>
	^ self attributeAt: #author ifAbsent: [ nil ]
]

{ #category : #accessing }
GLPHEMergeRequest >> author: anObject [

	<generated>
	self attributeAt: #author put: (FMMultivalueLink on: self update: #createdMergeRequests from: self author to: anObject).
]

{ #category : #accessing }
GLPHEMergeRequest >> blocking_discussions_resolved [

	<FMProperty: #blocking_discussions_resolved type: #Boolean>
	<generated>
	^ blocking_discussions_resolved
]

{ #category : #accessing }
GLPHEMergeRequest >> blocking_discussions_resolved: anObject [
	<generated>
	blocking_discussions_resolved := anObject
]

{ #category : #accessing }
GLPHEMergeRequest >> changes_count [

	<FMProperty: #changes_count type: #String>
	<generated>
	^ changes_count
]

{ #category : #accessing }
GLPHEMergeRequest >> changes_count: anObject [
	<generated>
	changes_count := anObject
]

{ #category : #accessing }
GLPHEMergeRequest >> closed_at [

	<FMProperty: #closed_at type: #String>
	<generated>
	^ closed_at
]

{ #category : #accessing }
GLPHEMergeRequest >> closed_at: anObject [
	<generated>
	closed_at := anObject
]

{ #category : #accessing }
GLPHEMergeRequest >> closed_by [
	"Relation named: #closed_by type: #GLHUser opposite: #closedMergeRequests"

	<generated>
	<FMProperty: #closed_by type: #GLHUser opposite: #closedMergeRequests>
	^ self attributeAt: #closed_by ifAbsent: [ nil ]
]

{ #category : #accessing }
GLPHEMergeRequest >> closed_by: anObject [

	<generated>
	self attributeAt: #closed_by put: (FMMultivalueLink on: self update: #closedMergeRequests from: self closed_by to: anObject).
]

{ #category : #accessing }
GLPHEMergeRequest >> created_at [

	<FMProperty: #created_at type: #String>
	<generated>
	^ created_at
]

{ #category : #accessing }
GLPHEMergeRequest >> created_at: anObject [
	<generated>
	created_at := anObject
]

{ #category : #accessing }
GLPHEMergeRequest >> description [

	<FMProperty: #description type: #String>
	<generated>
	^ description
]

{ #category : #accessing }
GLPHEMergeRequest >> description: anObject [
	<generated>
	description := anObject
]

{ #category : #accessing }
GLPHEMergeRequest >> detailed_merge_status [

	<FMProperty: #detailed_merge_status type: #String>
	<generated>
	^ detailed_merge_status
]

{ #category : #accessing }
GLPHEMergeRequest >> detailed_merge_status: anObject [
	<generated>
	detailed_merge_status := anObject
]

{ #category : #accessing }
GLPHEMergeRequest >> diffs [
	"Relation named: #diffs type: #GLHDiff opposite: #mergeRequest"

	<generated>
	<derived>
	<FMProperty: #diffs type: #GLHDiff opposite: #mergeRequest>
	^ self attributeAt: #diffs ifAbsentPut: [ FMMultivalueLink on: self opposite: #mergeRequest: ]
]

{ #category : #accessing }
GLPHEMergeRequest >> diffs: anObject [

	<generated>
	self diffs value: anObject
]

{ #category : #accessing }
GLPHEMergeRequest >> discussion_locked [

	<FMProperty: #discussion_locked type: #String>
	<generated>
	^ discussion_locked
]

{ #category : #accessing }
GLPHEMergeRequest >> discussion_locked: anObject [
	<generated>
	discussion_locked := anObject
]

{ #category : #accessing }
GLPHEMergeRequest >> downvotes [

	<FMProperty: #downvotes type: #Number>
	<generated>
	^ downvotes
]

{ #category : #accessing }
GLPHEMergeRequest >> downvotes: anObject [
	<generated>
	downvotes := anObject
]

{ #category : #accessing }
GLPHEMergeRequest >> draft [

	<FMProperty: #draft type: #Boolean>
	<generated>
	^ draft
]

{ #category : #accessing }
GLPHEMergeRequest >> draft: anObject [
	<generated>
	draft := anObject
]

{ #category : #accessing }
GLPHEMergeRequest >> first_deployed_to_production_at [

	<FMProperty: #first_deployed_to_production_at type: #String>
	<generated>
	^ first_deployed_to_production_at
]

{ #category : #accessing }
GLPHEMergeRequest >> first_deployed_to_production_at: anObject [
	<generated>
	first_deployed_to_production_at := anObject
]

{ #category : #accessing }
GLPHEMergeRequest >> force_remove_source_branch [

	<FMProperty: #force_remove_source_branch type: #Boolean>
	<generated>
	^ force_remove_source_branch
]

{ #category : #accessing }
GLPHEMergeRequest >> force_remove_source_branch: anObject [
	<generated>
	force_remove_source_branch := anObject
]

{ #category : #accessing }
GLPHEMergeRequest >> has_conflicts [

	<FMProperty: #has_conflicts type: #Boolean>
	<generated>
	^ has_conflicts
]

{ #category : #accessing }
GLPHEMergeRequest >> has_conflicts: anObject [
	<generated>
	has_conflicts := anObject
]

{ #category : #accessing }
GLPHEMergeRequest >> id [

	<FMProperty: #id type: #Number>
	<generated>
	^ id
]

{ #category : #accessing }
GLPHEMergeRequest >> id: anObject [
	<generated>
	id := anObject
]

{ #category : #accessing }
GLPHEMergeRequest >> iid [

	<FMProperty: #iid type: #Number>
	<generated>
	^ iid
]

{ #category : #accessing }
GLPHEMergeRequest >> iid: anObject [
	<generated>
	iid := anObject
]

{ #category : #accessing }
GLPHEMergeRequest >> labels [

	<FMProperty: #labels type: #Object>
	<generated>
	^ labels
]

{ #category : #accessing }
GLPHEMergeRequest >> labels: anObject [
	<generated>
	labels := anObject
]

{ #category : #accessing }
GLPHEMergeRequest >> latest_build_finished_at [

	<FMProperty: #latest_build_finished_at type: #String>
	<generated>
	^ latest_build_finished_at
]

{ #category : #accessing }
GLPHEMergeRequest >> latest_build_finished_at: anObject [
	<generated>
	latest_build_finished_at := anObject
]

{ #category : #accessing }
GLPHEMergeRequest >> latest_build_started_at [

	<FMProperty: #latest_build_started_at type: #String>
	<generated>
	^ latest_build_started_at
]

{ #category : #accessing }
GLPHEMergeRequest >> latest_build_started_at: anObject [
	<generated>
	latest_build_started_at := anObject
]

{ #category : #accessing }
GLPHEMergeRequest >> mergeCommit [
	"Relation named: #mergeCommit type: #GLHCommit opposite: #commitedMergeRequest"

	<generated>
	<FMProperty: #mergeCommit type: #GLHCommit opposite: #commitedMergeRequest>
	^ self attributeAt: #mergeCommit ifAbsent: [ nil ]
]

{ #category : #accessing }
GLPHEMergeRequest >> mergeCommit: anObject [

	<generated>
	(self attributeAt: #mergeCommit ifAbsentPut: [nil]) == anObject ifTrue: [ ^ anObject ].
	anObject ifNil: [ | otherSide |
		otherSide :=  self mergeCommit.
		self attributeAt: #mergeCommit put: anObject.
		otherSide commitedMergeRequest: nil ]
	ifNotNil: [ 
		self attributeAt: #mergeCommit put: anObject.
		anObject commitedMergeRequest: self ]
]

{ #category : #accessing }
GLPHEMergeRequest >> merge_commit_sha [

	<FMProperty: #merge_commit_sha type: #String>
	<generated>
	^ merge_commit_sha
]

{ #category : #accessing }
GLPHEMergeRequest >> merge_commit_sha: anObject [
	<generated>
	merge_commit_sha := anObject
]

{ #category : #accessing }
GLPHEMergeRequest >> merge_status [

	<FMProperty: #merge_status type: #String>
	<generated>
	^ merge_status
]

{ #category : #accessing }
GLPHEMergeRequest >> merge_status: anObject [
	<generated>
	merge_status := anObject
]

{ #category : #accessing }
GLPHEMergeRequest >> merge_user [
	"Relation named: #merge_user type: #GLHUser opposite: #usedMerges"

	<generated>
	<FMProperty: #merge_user type: #GLHUser opposite: #usedMerges>
	^ self attributeAt: #merge_user ifAbsent: [ nil ]
]

{ #category : #accessing }
GLPHEMergeRequest >> merge_user: anObject [

	<generated>
	self attributeAt: #merge_user put: (FMMultivalueLink on: self update: #usedMerges from: self merge_user to: anObject).
]

{ #category : #accessing }
GLPHEMergeRequest >> merge_when_pipeline_succeeds [

	<FMProperty: #merge_when_pipeline_succeeds type: #Boolean>
	<generated>
	^ merge_when_pipeline_succeeds
]

{ #category : #accessing }
GLPHEMergeRequest >> merge_when_pipeline_succeeds: anObject [
	<generated>
	merge_when_pipeline_succeeds := anObject
]

{ #category : #accessing }
GLPHEMergeRequest >> merged_at [

	<FMProperty: #merged_at type: #String>
	<generated>
	^ merged_at
]

{ #category : #accessing }
GLPHEMergeRequest >> merged_at: anObject [
	<generated>
	merged_at := anObject
]

{ #category : #accessing }
GLPHEMergeRequest >> merged_by [
	"Relation named: #merged_by type: #GLHUser opposite: #mergerOfMergeRequests"

	<generated>
	<FMProperty: #merged_by type: #GLHUser opposite: #mergerOfMergeRequests>
	^ self attributeAt: #merged_by ifAbsent: [ nil ]
]

{ #category : #accessing }
GLPHEMergeRequest >> merged_by: anObject [

	<generated>
	self attributeAt: #merged_by put: (FMMultivalueLink on: self update: #mergerOfMergeRequests from: self merged_by to: anObject).
]

{ #category : #accessing }
GLPHEMergeRequest >> milestone [

	<FMProperty: #milestone type: #String>
	<generated>
	^ milestone
]

{ #category : #accessing }
GLPHEMergeRequest >> milestone: anObject [
	<generated>
	milestone := anObject
]

{ #category : #accessing }
GLPHEMergeRequest >> pipeline [
	"Relation named: #pipeline type: #GLHPipeline opposite: #mergeResquest"

	<generated>
	<FMProperty: #pipeline type: #GLHPipeline opposite: #mergeResquest>
	^ self attributeAt: #pipeline ifAbsent: [ nil ]
]

{ #category : #accessing }
GLPHEMergeRequest >> pipeline: anObject [

	<generated>
	(self attributeAt: #pipeline ifAbsentPut: [nil]) == anObject ifTrue: [ ^ anObject ].
	anObject ifNil: [ | otherSide |
		otherSide :=  self pipeline.
		self attributeAt: #pipeline put: anObject.
		otherSide mergeResquest: nil ]
	ifNotNil: [ 
		self attributeAt: #pipeline put: anObject.
		anObject mergeResquest: self ]
]

{ #category : #accessing }
GLPHEMergeRequest >> project [
	"Relation named: #project type: #GLHProject opposite: #mergeRequests"

	<generated>
	<container>
	<FMProperty: #project type: #GLHProject opposite: #mergeRequests>
	^ self attributeAt: #project ifAbsent: [ nil ]
]

{ #category : #accessing }
GLPHEMergeRequest >> project: anObject [

	<generated>
	self attributeAt: #project put: (FMMultivalueLink on: self update: #mergeRequests from: self project to: anObject).
]

{ #category : #navigation }
GLPHEMergeRequest >> projectGroup [
	<generated>
	<navigation: 'Project'>
	^ MooseSpecializedGroup with: self project
]

{ #category : #accessing }
GLPHEMergeRequest >> project_id [

	<FMProperty: #project_id type: #Number>
	<generated>
	^ project_id
]

{ #category : #accessing }
GLPHEMergeRequest >> project_id: anObject [
	<generated>
	project_id := anObject
]

{ #category : #accessing }
GLPHEMergeRequest >> reference [

	<FMProperty: #reference type: #String>
	<generated>
	^ reference
]

{ #category : #accessing }
GLPHEMergeRequest >> reference: anObject [
	<generated>
	reference := anObject
]

{ #category : #accessing }
GLPHEMergeRequest >> references_full [

	<FMProperty: #references_full type: #String>
	<generated>
	^ references_full
]

{ #category : #accessing }
GLPHEMergeRequest >> references_full: anObject [
	<generated>
	references_full := anObject
]

{ #category : #accessing }
GLPHEMergeRequest >> references_relative [

	<FMProperty: #references_relative type: #String>
	<generated>
	^ references_relative
]

{ #category : #accessing }
GLPHEMergeRequest >> references_relative: anObject [
	<generated>
	references_relative := anObject
]

{ #category : #accessing }
GLPHEMergeRequest >> references_short [

	<FMProperty: #references_short type: #String>
	<generated>
	^ references_short
]

{ #category : #accessing }
GLPHEMergeRequest >> references_short: anObject [
	<generated>
	references_short := anObject
]

{ #category : #accessing }
GLPHEMergeRequest >> reviewers [
	"Relation named: #reviewers type: #GLHUser opposite: #reviewedMergeResquest"

	<generated>
	<derived>
	<FMProperty: #reviewers type: #GLHUser opposite: #reviewedMergeResquest>
	^ self attributeAt: #reviewers ifAbsentPut: [ FMMultiMultivalueLink on: self opposite: #reviewedMergeResquest ]
]

{ #category : #accessing }
GLPHEMergeRequest >> reviewers: anObject [

	<generated>
	self reviewers value: anObject
]

{ #category : #accessing }
GLPHEMergeRequest >> sha [

	<FMProperty: #sha type: #String>
	<generated>
	^ sha
]

{ #category : #accessing }
GLPHEMergeRequest >> sha: anObject [
	<generated>
	sha := anObject
]

{ #category : #accessing }
GLPHEMergeRequest >> should_remove_source_branch [

	<FMProperty: #should_remove_source_branch type: #Boolean>
	<generated>
	^ should_remove_source_branch
]

{ #category : #accessing }
GLPHEMergeRequest >> should_remove_source_branch: anObject [
	<generated>
	should_remove_source_branch := anObject
]

{ #category : #accessing }
GLPHEMergeRequest >> source_branch [

	<FMProperty: #source_branch type: #String>
	<generated>
	^ source_branch
]

{ #category : #accessing }
GLPHEMergeRequest >> source_branch: anObject [
	<generated>
	source_branch := anObject
]

{ #category : #accessing }
GLPHEMergeRequest >> source_project_id [

	<FMProperty: #source_project_id type: #Number>
	<generated>
	^ source_project_id
]

{ #category : #accessing }
GLPHEMergeRequest >> source_project_id: anObject [
	<generated>
	source_project_id := anObject
]

{ #category : #accessing }
GLPHEMergeRequest >> squash [

	<FMProperty: #squash type: #Boolean>
	<generated>
	^ squash
]

{ #category : #accessing }
GLPHEMergeRequest >> squash: anObject [
	<generated>
	squash := anObject
]

{ #category : #accessing }
GLPHEMergeRequest >> squashCommit [
	"Relation named: #squashCommit type: #GLHCommit opposite: #squashedMergeRequest"

	<generated>
	<FMProperty: #squashCommit type: #GLHCommit opposite: #squashedMergeRequest>
	^ self attributeAt: #squashCommit ifAbsent: [ nil ]
]

{ #category : #accessing }
GLPHEMergeRequest >> squashCommit: anObject [

	<generated>
	(self attributeAt: #squashCommit ifAbsentPut: [nil]) == anObject ifTrue: [ ^ anObject ].
	anObject ifNil: [ | otherSide |
		otherSide :=  self squashCommit.
		self attributeAt: #squashCommit put: anObject.
		otherSide squashedMergeRequest: nil ]
	ifNotNil: [ 
		self attributeAt: #squashCommit put: anObject.
		anObject squashedMergeRequest: self ]
]

{ #category : #accessing }
GLPHEMergeRequest >> squash_commit_sha [

	<FMProperty: #squash_commit_sha type: #String>
	<generated>
	^ squash_commit_sha
]

{ #category : #accessing }
GLPHEMergeRequest >> squash_commit_sha: anObject [
	<generated>
	squash_commit_sha := anObject
]

{ #category : #accessing }
GLPHEMergeRequest >> squash_on_merge [

	<FMProperty: #squash_on_merge type: #Boolean>
	<generated>
	^ squash_on_merge
]

{ #category : #accessing }
GLPHEMergeRequest >> squash_on_merge: anObject [
	<generated>
	squash_on_merge := anObject
]

{ #category : #accessing }
GLPHEMergeRequest >> state [

	<FMProperty: #state type: #String>
	<generated>
	^ state
]

{ #category : #accessing }
GLPHEMergeRequest >> state: anObject [
	<generated>
	state := anObject
]

{ #category : #accessing }
GLPHEMergeRequest >> subscribed [

	<FMProperty: #subscribed type: #Boolean>
	<generated>
	^ subscribed
]

{ #category : #accessing }
GLPHEMergeRequest >> subscribed: anObject [
	<generated>
	subscribed := anObject
]

{ #category : #accessing }
GLPHEMergeRequest >> target_branch [

	<FMProperty: #target_branch type: #String>
	<generated>
	^ target_branch
]

{ #category : #accessing }
GLPHEMergeRequest >> target_branch: anObject [
	<generated>
	target_branch := anObject
]

{ #category : #accessing }
GLPHEMergeRequest >> target_project_id [

	<FMProperty: #target_project_id type: #Number>
	<generated>
	^ target_project_id
]

{ #category : #accessing }
GLPHEMergeRequest >> target_project_id: anObject [
	<generated>
	target_project_id := anObject
]

{ #category : #accessing }
GLPHEMergeRequest >> task_completion_status_completed_count [

	<FMProperty: #task_completion_status_completed_count type: #Number>
	<generated>
	^ task_completion_status_completed_count
]

{ #category : #accessing }
GLPHEMergeRequest >> task_completion_status_completed_count: anObject [
	<generated>
	task_completion_status_completed_count := anObject
]

{ #category : #accessing }
GLPHEMergeRequest >> task_completion_status_count [

	<FMProperty: #task_completion_status_count type: #Number>
	<generated>
	^ task_completion_status_count
]

{ #category : #accessing }
GLPHEMergeRequest >> task_completion_status_count: anObject [
	<generated>
	task_completion_status_count := anObject
]

{ #category : #accessing }
GLPHEMergeRequest >> time_stats_human_time_estimate [

	<FMProperty: #time_stats_human_time_estimate type: #String>
	<generated>
	^ time_stats_human_time_estimate
]

{ #category : #accessing }
GLPHEMergeRequest >> time_stats_human_time_estimate: anObject [
	<generated>
	time_stats_human_time_estimate := anObject
]

{ #category : #accessing }
GLPHEMergeRequest >> time_stats_human_total_time_spent [

	<FMProperty: #time_stats_human_total_time_spent type: #String>
	<generated>
	^ time_stats_human_total_time_spent
]

{ #category : #accessing }
GLPHEMergeRequest >> time_stats_human_total_time_spent: anObject [
	<generated>
	time_stats_human_total_time_spent := anObject
]

{ #category : #accessing }
GLPHEMergeRequest >> time_stats_time_estimate [

	<FMProperty: #time_stats_time_estimate type: #Number>
	<generated>
	^ time_stats_time_estimate
]

{ #category : #accessing }
GLPHEMergeRequest >> time_stats_time_estimate: anObject [
	<generated>
	time_stats_time_estimate := anObject
]

{ #category : #accessing }
GLPHEMergeRequest >> time_stats_total_time_spent [

	<FMProperty: #time_stats_total_time_spent type: #Number>
	<generated>
	^ time_stats_total_time_spent
]

{ #category : #accessing }
GLPHEMergeRequest >> time_stats_total_time_spent: anObject [
	<generated>
	time_stats_total_time_spent := anObject
]

{ #category : #accessing }
GLPHEMergeRequest >> title [

	<FMProperty: #title type: #String>
	<generated>
	^ title
]

{ #category : #accessing }
GLPHEMergeRequest >> title: anObject [
	<generated>
	title := anObject
]

{ #category : #accessing }
GLPHEMergeRequest >> updated_at [

	<FMProperty: #updated_at type: #String>
	<generated>
	^ updated_at
]

{ #category : #accessing }
GLPHEMergeRequest >> updated_at: anObject [
	<generated>
	updated_at := anObject
]

{ #category : #accessing }
GLPHEMergeRequest >> upvotes [

	<FMProperty: #upvotes type: #Number>
	<generated>
	^ upvotes
]

{ #category : #accessing }
GLPHEMergeRequest >> upvotes: anObject [
	<generated>
	upvotes := anObject
]

{ #category : #accessing }
GLPHEMergeRequest >> user_notes_count [

	<FMProperty: #user_notes_count type: #Number>
	<generated>
	^ user_notes_count
]

{ #category : #accessing }
GLPHEMergeRequest >> user_notes_count: anObject [
	<generated>
	user_notes_count := anObject
]

{ #category : #accessing }
GLPHEMergeRequest >> web_url [

	<FMProperty: #web_url type: #String>
	<generated>
	^ web_url
]

{ #category : #accessing }
GLPHEMergeRequest >> web_url: anObject [
	<generated>
	web_url := anObject
]

{ #category : #accessing }
GLPHEMergeRequest >> work_in_progress [

	<FMProperty: #work_in_progress type: #Boolean>
	<generated>
	^ work_in_progress
]

{ #category : #accessing }
GLPHEMergeRequest >> work_in_progress: anObject [
	<generated>
	work_in_progress := anObject
]
