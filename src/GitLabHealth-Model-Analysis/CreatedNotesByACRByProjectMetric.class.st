Class {
	#name : #CreatedNotesByACRByProjectMetric,
	#superclass : #ProjectMetric,
	#category : #'GitLabHealth-Model-Analysis'
}

{ #category : #'as yet unclassified' }
CreatedNotesByACRByProjectMetric >> calculate [
    | notes acrnotes regex |

    projectMergeRequests ifNil: [ self load ].

    "Import all notes from project merge request"
    notes := projectMergeRequests 
        flatCollect: [ :mr | glhImporter importNotesfromMergeRequest: mr iid ofProject: mr project id ].

    "Filtering notes with ACR notation"
    regex := '.*Auto code review has detected that the code violates this rule.*' asRegex.

    acrnotes := notes 
        flatCollect: [ :noteArray | 
            noteArray select: [ :note | (regex search: note body) 
													and: ((note created_at asDateAndTime > (period at: #since) asDateAndTime) 
													and: (note updated_at asDateAndTime < (period at: #until))).] 
        ].

    ^ acrnotes size.

]

{ #category : #accessing }
CreatedNotesByACRByProjectMetric >> description [
	^ 'Nb AutoCodeReview notes for a project (all MR) in a given timeline'
]

{ #category : #loading }
CreatedNotesByACRByProjectMetric >> load [
	projectMergeRequests := self
	                      loadMergeRequestsSince:  (period at: #since)
	                      until:  (period at: #until)
]
