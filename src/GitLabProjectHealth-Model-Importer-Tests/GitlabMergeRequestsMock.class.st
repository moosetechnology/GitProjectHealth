Class {
	#name : #GitlabMergeRequestsMock,
	#superclass : #Object,
	#category : #'GitLabProjectHealth-Model-Importer-Tests'
}

{ #category : #api }
GitlabMergeRequestsMock >> get: id inProject: projectId [

		^ '{
	"author":{ "id": 12 },
	"merge_user":{ "id": 12 }
}'
]
