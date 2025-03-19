Class {
	#name : #CreatedNotesByACRByProjectMetric,
	#superclass : #ProjectMetric,
	#category : #'GitLabHealth-Model-Analysis'
}

{ #category : #'as yet unclassified' }
CreatedNotesByACRByProjectMetric >> calculate [
	| notes acrnotes regex |
	
	projectMergeRequests ifNil: [ self load ].
	
	"import all notes from project merge request"
	notes := projectMergeRequests collect: [ :mr |
		glhImporter importNotesfromMergeRequest: mr iid ofProject: mr project id].

	"filtering notes with ACR notation"
	regex := '.*Auto code review has detected that the code violates this rule.*' asRegex.

	acrnotes := (notes 
    collect: [ :orderedCollection |
        (orderedCollection 
            collect: [ :noteArray |
                noteArray 
                    select: [ :note | (regex search: (note body)) ] 
            ]) flatCollect: [ :filteredArray | filteredArray ].
    ])flatCollect: [ :filteredArray | filteredArray ].

	^ acrnotes size.
]

{ #category : #accessing }
CreatedNotesByACRByProjectMetric >> description [
	^ 'Nb AutoCodeReview notes for a project'
]

{ #category : #loading }
CreatedNotesByACRByProjectMetric >> load [
	projectMergeRequests := self
	                      loadMergeRequestsSince:  (period at: #since)
	                      until:  (period at: #until)
]
