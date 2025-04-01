"
a gitlab merge request

## Relations
======================

### Parents
| Relation | Origin | Opposite | Type | Comment |
|---|
| `project` | `GLHMergeRequest` | `mergeRequests` | `GLHProject` | |

### Other
| Relation | Origin | Opposite | Type | Comment |
|---|
| `approved_by` | `GLHMergeRequest` | `approcheMergeRequests` | `GLHUser` | |
| `assignee` | `GLHMergeRequest` | `currentlyAssignedMergeRequest` | `GLHUser` | |
| `assignees` | `GLHMergeRequest` | `assignedMergeRequests` | `GLHUser` | |
| `author` | `GLHMergeRequest` | `createdMergeRequests` | `GLHUser` | |
| `closed_by` | `GLHMergeRequest` | `closedMergeRequests` | `GLHUser` | |
| `diffs` | `GLHMergeRequest` | `mergeRequest` | `GLHDiff` | |
| `mergeRequestCommit` | `GLHMergeRequest` | `commitedMergeRequest` | `GLHCommit` | |
| `merge_user` | `GLHMergeRequest` | `usedMerges` | `GLHUser` | |
| `mergedCommit` | `GLHMergeRequest` | `commitedMergeRequest` | `GLHCommit` | |
| `merged_by` | `GLHMergeRequest` | `mergerOfMergeRequests` | `GLHUser` | |
| `note` | `GLHMergeRequest` | `mergeRequest` | `GLHNote` | |
| `pipeline` | `GLHMergeRequest` | `mergeResquest` | `GLHPipeline` | |
| `reviewers` | `GLHMergeRequest` | `reviewedMergeResquest` | `GLHUser` | |
| `squashCommit` | `GLHMergeRequest` | `squashedMergeRequest` | `GLHCommit` | |


## Properties
======================

| Name | Type | Default value | Comment |
|---|
| `approved` | `Boolean` | nil | |
| `blocking_discussions_resolved` | `Boolean` | nil | |
| `changes_count` | `String` | nil | |
| `closed_at` | `Object` | nil | |
| `commits` | `Object` | nil | |
| `created_at` | `Object` | nil | |
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
| `merged_at` | `Object` | nil | |
| `milestone` | `String` | nil | |
| `name` | `String` | nil | Basic name of the entity, not full reference.|
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
| `updated_at` | `Object` | nil | |
| `upvotes` | `Number` | nil | |
| `user_notes_count` | `Number` | nil | |
| `web_url` | `String` | nil | |
| `work_in_progress` | `Boolean` | nil | |

"
Class {
	#name : #GLHMergeRequest,
	#superclass : #GLHEntity,
	#traits : 'FamixTNamedEntity',
	#classTraits : 'FamixTNamedEntity classTrait',
	#instVars : [
		'#id => FMProperty',
		'#iid => FMProperty',
		'#project_id => FMProperty',
		'#title => FMProperty',
		'#description => FMProperty',
		'#state => FMProperty',
		'#created_at => FMProperty',
		'#updated_at => FMProperty',
		'#merged_at => FMProperty',
		'#closed_at => FMProperty',
		'#target_branch => FMProperty',
		'#source_branch => FMProperty',
		'#user_notes_count => FMProperty',
		'#upvotes => FMProperty',
		'#downvotes => FMProperty',
		'#source_project_id => FMProperty',
		'#target_project_id => FMProperty',
		'#labels => FMProperty',
		'#draft => FMProperty',
		'#work_in_progress => FMProperty',
		'#milestone => FMProperty',
		'#merge_when_pipeline_succeeds => FMProperty',
		'#merge_status => FMProperty',
		'#detailed_merge_status => FMProperty',
		'#sha => FMProperty',
		'#merge_commit_sha => FMProperty',
		'#squash_commit_sha => FMProperty',
		'#discussion_locked => FMProperty',
		'#should_remove_source_branch => FMProperty',
		'#force_remove_source_branch => FMProperty',
		'#reference => FMProperty',
		'#references_short => FMProperty',
		'#references_relative => FMProperty',
		'#references_full => FMProperty',
		'#web_url => FMProperty',
		'#time_stats_time_estimate => FMProperty',
		'#time_stats_total_time_spent => FMProperty',
		'#time_stats_human_time_estimate => FMProperty',
		'#time_stats_human_total_time_spent => FMProperty',
		'#squash => FMProperty',
		'#squash_on_merge => FMProperty',
		'#task_completion_status_count => FMProperty',
		'#task_completion_status_completed_count => FMProperty',
		'#has_conflicts => FMProperty',
		'#blocking_discussions_resolved => FMProperty',
		'#subscribed => FMProperty',
		'#changes_count => FMProperty',
		'#latest_build_started_at => FMProperty',
		'#latest_build_finished_at => FMProperty',
		'#first_deployed_to_production_at => FMProperty',
		'#approved => FMProperty',
		'#commits => FMProperty',
		'#author => FMOne type: #GLHUser opposite: #createdMergeRequests',
		'#approved_by => FMMany type: #GLHUser opposite: #approcheMergeRequests',
		'#merge_user => FMOne type: #GLHUser opposite: #usedMerges',
		'#closed_by => FMOne type: #GLHUser opposite: #closedMergeRequests',
		'#merged_by => FMOne type: #GLHUser opposite: #mergerOfMergeRequests',
		'#assignees => FMMany type: #GLHUser opposite: #assignedMergeRequests',
		'#assignee => FMOne type: #GLHUser opposite: #currentlyAssignedMergeRequest',
		'#reviewers => FMMany type: #GLHUser opposite: #reviewedMergeResquest',
		'#pipeline => FMOne type: #GLHPipeline opposite: #mergeResquest',
		'#mergedCommit => FMOne type: #GLHCommit opposite: #commitedMergeRequest',
		'#mergeRequestCommit => FMOne type: #GLHCommit opposite: #commitedMergeRequest',
		'#squashCommit => FMOne type: #GLHCommit opposite: #squashedMergeRequest',
		'#diffs => FMMany type: #GLHDiff opposite: #mergeRequest',
		'#project => FMOne type: #GLHProject opposite: #mergeRequests',
		'#note => FMMany type: #GLHNote opposite: #mergeRequest'
	],
	#category : #'GitLabHealth-Model-Entities'
}

{ #category : #meta }
GLHMergeRequest class >> annotation [

	<FMClass: #MergeRequest super: #GLHEntity>
	<package: #'GitLabHealth-Model'>
	<generated>
	^ self
]

{ #category : #adding }
GLHMergeRequest >> addApproved_by: anObject [
	<generated>
	^ self approved_by add: anObject
]

{ #category : #adding }
GLHMergeRequest >> addAssignee: anObject [
	<generated>
	^ self assignees add: anObject
]

{ #category : #adding }
GLHMergeRequest >> addDiff: anObject [
	<generated>
	^ self diffs add: anObject
]

{ #category : #adding }
GLHMergeRequest >> addNote: anObject [
	<generated>
	^ self note add: anObject
]

{ #category : #adding }
GLHMergeRequest >> addReviewer: anObject [
	<generated>
	^ self reviewers add: anObject
]

{ #category : #accessing }
GLHMergeRequest >> approved [

	<FMProperty: #approved type: #Boolean>
	<generated>
	^ approved
]

{ #category : #accessing }
GLHMergeRequest >> approved: anObject [
	<generated>
	approved := anObject
]

{ #category : #accessing }
GLHMergeRequest >> approved_by [
	"Relation named: #approved_by type: #GLHUser opposite: #approcheMergeRequests"

	<generated>
	<derived>
	^ approved_by
]

{ #category : #accessing }
GLHMergeRequest >> approved_by: anObject [

	<generated>
	approved_by value: anObject
]

{ #category : #accessing }
GLHMergeRequest >> assignee [
	"Relation named: #assignee type: #GLHUser opposite: #currentlyAssignedMergeRequest"

	<generated>
	^ assignee
]

{ #category : #accessing }
GLHMergeRequest >> assignee: anObject [

	<generated>
	assignee := anObject
]

{ #category : #accessing }
GLHMergeRequest >> assignees [
	"Relation named: #assignees type: #GLHUser opposite: #assignedMergeRequests"

	<generated>
	<derived>
	^ assignees
]

{ #category : #accessing }
GLHMergeRequest >> assignees: anObject [

	<generated>
	assignees value: anObject
]

{ #category : #accessing }
GLHMergeRequest >> author [
	"Relation named: #author type: #GLHUser opposite: #createdMergeRequests"

	<generated>
	^ author
]

{ #category : #accessing }
GLHMergeRequest >> author: anObject [

	<generated>
	author := anObject
]

{ #category : #accessing }
GLHMergeRequest >> blocking_discussions_resolved [

	<FMProperty: #blocking_discussions_resolved type: #Boolean>
	<generated>
	^ blocking_discussions_resolved
]

{ #category : #accessing }
GLHMergeRequest >> blocking_discussions_resolved: anObject [
	<generated>
	blocking_discussions_resolved := anObject
]

{ #category : #accessing }
GLHMergeRequest >> changes_count [

	<FMProperty: #changes_count type: #String>
	<generated>
	^ changes_count
]

{ #category : #accessing }
GLHMergeRequest >> changes_count: anObject [
	<generated>
	changes_count := anObject
]

{ #category : #accessing }
GLHMergeRequest >> closed_at [

	<FMProperty: #closed_at type: #Object>
	<generated>
	^ closed_at
]

{ #category : #accessing }
GLHMergeRequest >> closed_at: anObject [
	<generated>
	closed_at := anObject
]

{ #category : #accessing }
GLHMergeRequest >> closed_by [
	"Relation named: #closed_by type: #GLHUser opposite: #closedMergeRequests"

	<generated>
	^ closed_by
]

{ #category : #accessing }
GLHMergeRequest >> closed_by: anObject [

	<generated>
	closed_by := anObject
]

{ #category : #accessing }
GLHMergeRequest >> commits [

	<FMProperty: #commits type: #Object>
	<generated>
	^ commits
]

{ #category : #accessing }
GLHMergeRequest >> commits: anObject [
	<generated>
	commits := anObject
]

{ #category : #accessing }
GLHMergeRequest >> created_at [

	<FMProperty: #created_at type: #Object>
	<generated>
	^ created_at
]

{ #category : #accessing }
GLHMergeRequest >> created_at: anObject [
	<generated>
	created_at := anObject
]

{ #category : #accessing }
GLHMergeRequest >> description [

	<FMProperty: #description type: #String>
	<generated>
	^ description
]

{ #category : #accessing }
GLHMergeRequest >> description: anObject [
	<generated>
	description := anObject
]

{ #category : #accessing }
GLHMergeRequest >> detailed_merge_status [

	<FMProperty: #detailed_merge_status type: #String>
	<generated>
	^ detailed_merge_status
]

{ #category : #accessing }
GLHMergeRequest >> detailed_merge_status: anObject [
	<generated>
	detailed_merge_status := anObject
]

{ #category : #accessing }
GLHMergeRequest >> diffs [
	"Relation named: #diffs type: #GLHDiff opposite: #mergeRequest"

	<generated>
	<derived>
	^ diffs
]

{ #category : #accessing }
GLHMergeRequest >> diffs: anObject [

	<generated>
	diffs value: anObject
]

{ #category : #accessing }
GLHMergeRequest >> discussion_locked [

	<FMProperty: #discussion_locked type: #String>
	<generated>
	^ discussion_locked
]

{ #category : #accessing }
GLHMergeRequest >> discussion_locked: anObject [
	<generated>
	discussion_locked := anObject
]

{ #category : #accessing }
GLHMergeRequest >> downvotes [

	<FMProperty: #downvotes type: #Number>
	<generated>
	^ downvotes
]

{ #category : #accessing }
GLHMergeRequest >> downvotes: anObject [
	<generated>
	downvotes := anObject
]

{ #category : #accessing }
GLHMergeRequest >> draft [

	<FMProperty: #draft type: #Boolean>
	<generated>
	^ draft
]

{ #category : #accessing }
GLHMergeRequest >> draft: anObject [
	<generated>
	draft := anObject
]

{ #category : #accessing }
GLHMergeRequest >> first_deployed_to_production_at [

	<FMProperty: #first_deployed_to_production_at type: #String>
	<generated>
	^ first_deployed_to_production_at
]

{ #category : #accessing }
GLHMergeRequest >> first_deployed_to_production_at: anObject [
	<generated>
	first_deployed_to_production_at := anObject
]

{ #category : #accessing }
GLHMergeRequest >> force_remove_source_branch [

	<FMProperty: #force_remove_source_branch type: #Boolean>
	<generated>
	^ force_remove_source_branch
]

{ #category : #accessing }
GLHMergeRequest >> force_remove_source_branch: anObject [
	<generated>
	force_remove_source_branch := anObject
]

{ #category : #accessing }
GLHMergeRequest >> has_conflicts [

	<FMProperty: #has_conflicts type: #Boolean>
	<generated>
	^ has_conflicts
]

{ #category : #accessing }
GLHMergeRequest >> has_conflicts: anObject [
	<generated>
	has_conflicts := anObject
]

{ #category : #accessing }
GLHMergeRequest >> id [

	<FMProperty: #id type: #Number>
	<generated>
	^ id
]

{ #category : #accessing }
GLHMergeRequest >> id: anObject [
	<generated>
	id := anObject
]

{ #category : #accessing }
GLHMergeRequest >> iid [

	<FMProperty: #iid type: #Number>
	<generated>
	^ iid
]

{ #category : #accessing }
GLHMergeRequest >> iid: anObject [
	<generated>
	iid := anObject
]

{ #category : #accessing }
GLHMergeRequest >> labels [

	<FMProperty: #labels type: #Object>
	<generated>
	^ labels
]

{ #category : #accessing }
GLHMergeRequest >> labels: anObject [
	<generated>
	labels := anObject
]

{ #category : #accessing }
GLHMergeRequest >> latest_build_finished_at [

	<FMProperty: #latest_build_finished_at type: #String>
	<generated>
	^ latest_build_finished_at
]

{ #category : #accessing }
GLHMergeRequest >> latest_build_finished_at: anObject [
	<generated>
	latest_build_finished_at := anObject
]

{ #category : #accessing }
GLHMergeRequest >> latest_build_started_at [

	<FMProperty: #latest_build_started_at type: #String>
	<generated>
	^ latest_build_started_at
]

{ #category : #accessing }
GLHMergeRequest >> latest_build_started_at: anObject [
	<generated>
	latest_build_started_at := anObject
]

{ #category : #accessing }
GLHMergeRequest >> mergeRequestCommit [
	"Relation named: #mergeRequestCommit type: #GLHCommit opposite: #commitedMergeRequest"

	<generated>
	^ mergeRequestCommit
]

{ #category : #accessing }
GLHMergeRequest >> mergeRequestCommit: anObject [

	<generated>
	mergeRequestCommit := anObject
]

{ #category : #accessing }
GLHMergeRequest >> merge_commit_sha [

	<FMProperty: #merge_commit_sha type: #String>
	<generated>
	^ merge_commit_sha
]

{ #category : #accessing }
GLHMergeRequest >> merge_commit_sha: anObject [
	<generated>
	merge_commit_sha := anObject
]

{ #category : #accessing }
GLHMergeRequest >> merge_status [

	<FMProperty: #merge_status type: #String>
	<generated>
	^ merge_status
]

{ #category : #accessing }
GLHMergeRequest >> merge_status: anObject [
	<generated>
	merge_status := anObject
]

{ #category : #accessing }
GLHMergeRequest >> merge_user [
	"Relation named: #merge_user type: #GLHUser opposite: #usedMerges"

	<generated>
	^ merge_user
]

{ #category : #accessing }
GLHMergeRequest >> merge_user: anObject [

	<generated>
	merge_user := anObject
]

{ #category : #accessing }
GLHMergeRequest >> merge_when_pipeline_succeeds [

	<FMProperty: #merge_when_pipeline_succeeds type: #Boolean>
	<generated>
	^ merge_when_pipeline_succeeds
]

{ #category : #accessing }
GLHMergeRequest >> merge_when_pipeline_succeeds: anObject [
	<generated>
	merge_when_pipeline_succeeds := anObject
]

{ #category : #accessing }
GLHMergeRequest >> mergedCommit [
	"Relation named: #mergedCommit type: #GLHCommit opposite: #commitedMergeRequest"

	<generated>
	^ mergedCommit
]

{ #category : #accessing }
GLHMergeRequest >> mergedCommit: anObject [

	<generated>
	mergedCommit := anObject
]

{ #category : #accessing }
GLHMergeRequest >> merged_at [

	<FMProperty: #merged_at type: #Object>
	<generated>
	^ merged_at
]

{ #category : #accessing }
GLHMergeRequest >> merged_at: anObject [
	<generated>
	merged_at := anObject
]

{ #category : #accessing }
GLHMergeRequest >> merged_by [
	"Relation named: #merged_by type: #GLHUser opposite: #mergerOfMergeRequests"

	<generated>
	^ merged_by
]

{ #category : #accessing }
GLHMergeRequest >> merged_by: anObject [

	<generated>
	merged_by := anObject
]

{ #category : #accessing }
GLHMergeRequest >> milestone [

	<FMProperty: #milestone type: #String>
	<generated>
	^ milestone
]

{ #category : #accessing }
GLHMergeRequest >> milestone: anObject [
	<generated>
	milestone := anObject
]

{ #category : #accessing }
GLHMergeRequest >> note [
	"Relation named: #note type: #GLHNote opposite: #mergeRequest"

	<generated>
	<derived>
	^ note
]

{ #category : #accessing }
GLHMergeRequest >> note: anObject [

	<generated>
	note value: anObject
]

{ #category : #accessing }
GLHMergeRequest >> pipeline [
	"Relation named: #pipeline type: #GLHPipeline opposite: #mergeResquest"

	<generated>
	^ pipeline
]

{ #category : #accessing }
GLHMergeRequest >> pipeline: anObject [

	<generated>
	pipeline := anObject
]

{ #category : #accessing }
GLHMergeRequest >> project [
	"Relation named: #project type: #GLHProject opposite: #mergeRequests"

	<generated>
	<container>
	^ project
]

{ #category : #accessing }
GLHMergeRequest >> project: anObject [

	<generated>
	project := anObject
]

{ #category : #navigation }
GLHMergeRequest >> projectGroup [
	<generated>
	<navigation: 'Project'>
	^ MooseSpecializedGroup with: self project
]

{ #category : #accessing }
GLHMergeRequest >> project_id [

	<FMProperty: #project_id type: #Number>
	<generated>
	^ project_id
]

{ #category : #accessing }
GLHMergeRequest >> project_id: anObject [
	<generated>
	project_id := anObject
]

{ #category : #accessing }
GLHMergeRequest >> reference [

	<FMProperty: #reference type: #String>
	<generated>
	^ reference
]

{ #category : #accessing }
GLHMergeRequest >> reference: anObject [
	<generated>
	reference := anObject
]

{ #category : #accessing }
GLHMergeRequest >> references_full [

	<FMProperty: #references_full type: #String>
	<generated>
	^ references_full
]

{ #category : #accessing }
GLHMergeRequest >> references_full: anObject [
	<generated>
	references_full := anObject
]

{ #category : #accessing }
GLHMergeRequest >> references_relative [

	<FMProperty: #references_relative type: #String>
	<generated>
	^ references_relative
]

{ #category : #accessing }
GLHMergeRequest >> references_relative: anObject [
	<generated>
	references_relative := anObject
]

{ #category : #accessing }
GLHMergeRequest >> references_short [

	<FMProperty: #references_short type: #String>
	<generated>
	^ references_short
]

{ #category : #accessing }
GLHMergeRequest >> references_short: anObject [
	<generated>
	references_short := anObject
]

{ #category : #accessing }
GLHMergeRequest >> reviewers [
	"Relation named: #reviewers type: #GLHUser opposite: #reviewedMergeResquest"

	<generated>
	<derived>
	^ reviewers
]

{ #category : #accessing }
GLHMergeRequest >> reviewers: anObject [

	<generated>
	reviewers value: anObject
]

{ #category : #accessing }
GLHMergeRequest >> sha [

	<FMProperty: #sha type: #String>
	<generated>
	^ sha
]

{ #category : #accessing }
GLHMergeRequest >> sha: anObject [
	<generated>
	sha := anObject
]

{ #category : #accessing }
GLHMergeRequest >> should_remove_source_branch [

	<FMProperty: #should_remove_source_branch type: #Boolean>
	<generated>
	^ should_remove_source_branch
]

{ #category : #accessing }
GLHMergeRequest >> should_remove_source_branch: anObject [
	<generated>
	should_remove_source_branch := anObject
]

{ #category : #accessing }
GLHMergeRequest >> source_branch [

	<FMProperty: #source_branch type: #String>
	<generated>
	^ source_branch
]

{ #category : #accessing }
GLHMergeRequest >> source_branch: anObject [
	<generated>
	source_branch := anObject
]

{ #category : #accessing }
GLHMergeRequest >> source_project_id [

	<FMProperty: #source_project_id type: #Number>
	<generated>
	^ source_project_id
]

{ #category : #accessing }
GLHMergeRequest >> source_project_id: anObject [
	<generated>
	source_project_id := anObject
]

{ #category : #accessing }
GLHMergeRequest >> squash [

	<FMProperty: #squash type: #Boolean>
	<generated>
	^ squash
]

{ #category : #accessing }
GLHMergeRequest >> squash: anObject [
	<generated>
	squash := anObject
]

{ #category : #accessing }
GLHMergeRequest >> squashCommit [
	"Relation named: #squashCommit type: #GLHCommit opposite: #squashedMergeRequest"

	<generated>
	^ squashCommit
]

{ #category : #accessing }
GLHMergeRequest >> squashCommit: anObject [

	<generated>
	squashCommit := anObject
]

{ #category : #accessing }
GLHMergeRequest >> squash_commit_sha [

	<FMProperty: #squash_commit_sha type: #String>
	<generated>
	^ squash_commit_sha
]

{ #category : #accessing }
GLHMergeRequest >> squash_commit_sha: anObject [
	<generated>
	squash_commit_sha := anObject
]

{ #category : #accessing }
GLHMergeRequest >> squash_on_merge [

	<FMProperty: #squash_on_merge type: #Boolean>
	<generated>
	^ squash_on_merge
]

{ #category : #accessing }
GLHMergeRequest >> squash_on_merge: anObject [
	<generated>
	squash_on_merge := anObject
]

{ #category : #accessing }
GLHMergeRequest >> state [

	<FMProperty: #state type: #String>
	<generated>
	^ state
]

{ #category : #accessing }
GLHMergeRequest >> state: anObject [
	<generated>
	state := anObject
]

{ #category : #accessing }
GLHMergeRequest >> subscribed [

	<FMProperty: #subscribed type: #Boolean>
	<generated>
	^ subscribed
]

{ #category : #accessing }
GLHMergeRequest >> subscribed: anObject [
	<generated>
	subscribed := anObject
]

{ #category : #accessing }
GLHMergeRequest >> target_branch [

	<FMProperty: #target_branch type: #String>
	<generated>
	^ target_branch
]

{ #category : #accessing }
GLHMergeRequest >> target_branch: anObject [
	<generated>
	target_branch := anObject
]

{ #category : #accessing }
GLHMergeRequest >> target_project_id [

	<FMProperty: #target_project_id type: #Number>
	<generated>
	^ target_project_id
]

{ #category : #accessing }
GLHMergeRequest >> target_project_id: anObject [
	<generated>
	target_project_id := anObject
]

{ #category : #accessing }
GLHMergeRequest >> task_completion_status_completed_count [

	<FMProperty: #task_completion_status_completed_count type: #Number>
	<generated>
	^ task_completion_status_completed_count
]

{ #category : #accessing }
GLHMergeRequest >> task_completion_status_completed_count: anObject [
	<generated>
	task_completion_status_completed_count := anObject
]

{ #category : #accessing }
GLHMergeRequest >> task_completion_status_count [

	<FMProperty: #task_completion_status_count type: #Number>
	<generated>
	^ task_completion_status_count
]

{ #category : #accessing }
GLHMergeRequest >> task_completion_status_count: anObject [
	<generated>
	task_completion_status_count := anObject
]

{ #category : #accessing }
GLHMergeRequest >> time_stats_human_time_estimate [

	<FMProperty: #time_stats_human_time_estimate type: #String>
	<generated>
	^ time_stats_human_time_estimate
]

{ #category : #accessing }
GLHMergeRequest >> time_stats_human_time_estimate: anObject [
	<generated>
	time_stats_human_time_estimate := anObject
]

{ #category : #accessing }
GLHMergeRequest >> time_stats_human_total_time_spent [

	<FMProperty: #time_stats_human_total_time_spent type: #String>
	<generated>
	^ time_stats_human_total_time_spent
]

{ #category : #accessing }
GLHMergeRequest >> time_stats_human_total_time_spent: anObject [
	<generated>
	time_stats_human_total_time_spent := anObject
]

{ #category : #accessing }
GLHMergeRequest >> time_stats_time_estimate [

	<FMProperty: #time_stats_time_estimate type: #Number>
	<generated>
	^ time_stats_time_estimate
]

{ #category : #accessing }
GLHMergeRequest >> time_stats_time_estimate: anObject [
	<generated>
	time_stats_time_estimate := anObject
]

{ #category : #accessing }
GLHMergeRequest >> time_stats_total_time_spent [

	<FMProperty: #time_stats_total_time_spent type: #Number>
	<generated>
	^ time_stats_total_time_spent
]

{ #category : #accessing }
GLHMergeRequest >> time_stats_total_time_spent: anObject [
	<generated>
	time_stats_total_time_spent := anObject
]

{ #category : #accessing }
GLHMergeRequest >> title [

	<FMProperty: #title type: #String>
	<generated>
	^ title
]

{ #category : #accessing }
GLHMergeRequest >> title: anObject [
	<generated>
	title := anObject
]

{ #category : #accessing }
GLHMergeRequest >> updated_at [

	<FMProperty: #updated_at type: #Object>
	<generated>
	^ updated_at
]

{ #category : #accessing }
GLHMergeRequest >> updated_at: anObject [
	<generated>
	updated_at := anObject
]

{ #category : #accessing }
GLHMergeRequest >> upvotes [

	<FMProperty: #upvotes type: #Number>
	<generated>
	^ upvotes
]

{ #category : #accessing }
GLHMergeRequest >> upvotes: anObject [
	<generated>
	upvotes := anObject
]

{ #category : #accessing }
GLHMergeRequest >> user_notes_count [

	<FMProperty: #user_notes_count type: #Number>
	<generated>
	^ user_notes_count
]

{ #category : #accessing }
GLHMergeRequest >> user_notes_count: anObject [
	<generated>
	user_notes_count := anObject
]

{ #category : #accessing }
GLHMergeRequest >> web_url [

	<FMProperty: #web_url type: #String>
	<generated>
	^ web_url
]

{ #category : #accessing }
GLHMergeRequest >> web_url: anObject [
	<generated>
	web_url := anObject
]

{ #category : #accessing }
GLHMergeRequest >> work_in_progress [

	<FMProperty: #work_in_progress type: #Boolean>
	<generated>
	^ work_in_progress
]

{ #category : #accessing }
GLHMergeRequest >> work_in_progress: anObject [
	<generated>
	work_in_progress := anObject
]
