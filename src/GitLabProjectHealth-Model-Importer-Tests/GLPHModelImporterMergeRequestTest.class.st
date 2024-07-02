Class {
	#name : #GLPHModelImporterMergeRequestTest,
	#superclass : #TestCase,
	#instVars : [
		'githubDiffData',
		'gitlabDiffData',
		'glhImporter',
		'gitlabMergeData'
	],
	#category : #'GitLabProjectHealth-Model-Importer-Tests'
}

{ #category : #running }
GLPHModelImporterMergeRequestTest >> setUp [

	super setUp.
	glhImporter := GLPHModelImporter new.
	gitlabMergeData := '[
		{"id":46074,
		"iid":1415,
		"project_id":4810,
		"title":"Super MR",
		"description":"Close Issue XX",
		"state":"opened",
		"created_at":"2024-07-01T16:05:48.775+02:00",
		"updated_at":"2024-07-01T16:05:51.221+02:00",
		"merged_by":null,
		"merge_user":null,
		"merged_at":null,
		"closed_by":null,
		"closed_at":null,
		"target_branch":"1.0.0",
		"source_branch":"feature/XX",
		"user_notes_count":0,
		"upvotes":0,
		"downvotes":0,
		"author":
			{
				"id":12,
				"username":"badetitou",
				"name":"Verhaeghe Benoit",
				"state":"active",
				"avatar_url":"https://gitlab.com/badetitou.png",
				"web_url":"https://gitlab.com/badetitou"
			},
		"assignees":[
			{
			"id":12,
			"username":"badetitou",
			"name":"Verhaeghe Benoit",
			"state":"active",
			"avatar_url":"https://gitlab.com/badetitou.png",
			"web_url":"https://gitlab.com/badetitou"
			}
		],
		"assignee":{
			"id":12,
			"username":"badetitou",
			"name":"Verhaeghe Benoit",
			"state":"active",
			"avatar_url":"https://gitlab.com/badetitou.png",
			"web_url":"https://gitlab.com/badetitou"
		},
		"reviewers":[],
		"source_project_id":4810,
		"target_project_id":4810,
		"labels":[],
		"draft":false,
		"work_in_progress":false,
		"milestone":null,
		"merge_when_pipeline_succeeds":false,
		"merge_status":"can_be_merged",
		"detailed_merge_status":"mergeable",
		"sha":"idgyuzegfdyugfzuygdiuezg",
		"merge_commit_sha":null,
		"squash_commit_sha":null,
		"discussion_locked":null,
		"should_remove_source_branch":null,
		"force_remove_source_branch":true,
		"reference":"!1024",
		"references":{
			"short":"!1415",
			"relative":"!1415",
			"full":"group/group2!1415"
		},
		"web_url":"https://gitlab.com/group/group2/-/merge_requests/1415",
		"time_stats":{
			"time_estimate":0,
			"total_time_spent":0,
			"human_time_estimate":null,
			"human_total_time_spent":null
		},
		"squash":true,
		"squash_on_merge":true,
		"task_completion_status":{
			"count":0,
			"completed_count":0
		},
		"has_conflicts":false,
		"blocking_discussions_resolved":true
}]'
]

{ #category : #test }
GLPHModelImporterMergeRequestTest >> testParseMergeRequestResult [

	| parseRes |
	parseRes := glhImporter parseMergeRequestResult: gitlabMergeData.
	self assert: parseRes size equals: 1.
	self assert: parseRes anyOne id equals: 46074
]