Class {
	#name : 'GLPHApiMock',
	#superclass : 'GLPHApi',
	#category : 'GitLabProjectHealth-Model-Importer-Tests',
	#package : 'GitLabProjectHealth-Model-Importer-Tests'
}

{ #category : 'as yet unclassified' }
GLPHApiMock >> mergeRequestOfProject: project withId: id [

	^ '{
	"author":{ "id": 12 },
	"merge_user":{ "id": 12 }
}'
]
