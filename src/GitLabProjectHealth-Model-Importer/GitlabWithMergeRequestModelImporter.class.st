Class {
	#name : #GitlabWithMergeRequestModelImporter,
	#superclass : #GitlabModelImporter,
	#category : #'GitLabProjectHealth-Model-Importer'
}

{ #category : #testing }
GitlabWithMergeRequestModelImporter class >> isDeprecated [
		" Uses GitlabModelImporter instead of GitlabWithMergeRequestModelImporter"
		^ true
]

{ #category : #'import - notes' }
GitlabWithMergeRequestModelImporter >> importNotesfromMergeRequest: mergeRequestIID ofProject: projectId [
	| results notes |
	
	results := self repoApi notes allInMergeRequest: mergeRequestIID ofProject: projectId.
	
	notes := results collect: [ :note | 
		self parseNoteJson: note ].
	"notes := self parseNoteJson: results."
	notes do: [ :tabNotes | tabNotes do: [ :note |
			note author: (self importUser: (note author at: #id)).
			note name: note id asString]. ].
	
	notes do: [:note | self glhModel addAll: note unless: self blockOnIdEquality.]
	

	
]
