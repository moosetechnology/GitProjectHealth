Class {
	#name : #GitlabMergeRequestsMock,
	#superclass : #Object,
	#category : #'GitLabHealth-Model-Importer-Tests'
}

{ #category : #api }
GitlabMergeRequestsMock >> diffsOf: aMergeRequest inProject: aProjectID [
	"three times the same diff separated. This cas happens when asking for json output and there are more than 25 changes (grouped by changes)"
	^ { '[
    {
        "diff": "@@ -67,2 +67,1 @@\n- hello 1\n- hello 1\n+ hello new",
        "new_path": "a/path",
        "old_path": "a/path",
        "a_mode": "100644",
        "b_mode": "100644",
        "new_file": false,
        "renamed_file": false,
        "deleted_file": false,
        "generated_file": false
    }
]'. '[
    {
        "diff": "@@ -67,2 +67,1 @@\n- hello 2\n- hello 2\n+ hello new",
        "new_path": "a/path",
        "old_path": "a/path",
        "a_mode": "100644",
        "b_mode": "100644",
        "new_file": false,
        "renamed_file": false,
        "deleted_file": false,
        "generated_file": false
    }
]'. '[
    {
        "diff": "@@ -67,2 +67,1 @@\n- hello 3\n- hello 3\n+ hello new",
        "new_path": "a/path",
        "old_path": "a/path",
        "a_mode": "100644",
        "b_mode": "100644",
        "new_file": false,
        "renamed_file": false,
        "deleted_file": false,
        "generated_file": false
    }
]' }
]

{ #category : #api }
GitlabMergeRequestsMock >> get: id inProject: projectId [

		^ '{
	"author":{ "id": 12 },
	"merge_user":{ "id": 12 }
}'
]
