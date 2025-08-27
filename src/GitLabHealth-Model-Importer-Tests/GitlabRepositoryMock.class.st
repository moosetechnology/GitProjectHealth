Class {
	#name : #GitlabRepositoryMock,
	#superclass : #Object,
	#category : #'GitLabHealth-Model-Importer-Tests'
}

{ #category : #api }
GitlabRepositoryMock >> compareInProject: anInteger from: aString to: aString3 [ 
	^ '{
    "commit": null,
    "commits": [],
    "diffs": [],
    "compare_timeout": false,
    "compare_same_ref": true,
    "web_url": "https://gitlab.com/my-project/project/project/name/-/compare/v1.8.1..v1.8.1"
}'.

]
