Class {
	#name : #GLPHApiMock,
	#superclass : #GLPHApi,
	#category : #'GitLabProjectHealth-Model-Importer-Tests'
}

{ #category : #'as yet unclassified' }
GLPHApiMock >> mergeRequestOfProject: project withId: id [

	^ '{
	"author":{ "id": 12 }
}'
]
