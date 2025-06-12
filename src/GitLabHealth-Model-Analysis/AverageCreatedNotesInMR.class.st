Class {
	#name : #AverageCreatedNotesInMR,
	#superclass : #ProjectMetric,
	#category : #'GitLabHealth-Model-Analysis'
}

{ #category : #calculating }
AverageCreatedNotesInMR >> calculate [  
    | groupedByDate |  

    projectMergeRequests ifNil: [ self load ].  
    groupedByDate := self setupGroupedDate.  

    projectMergeRequests do: [ :mr |  
        mr note do: [ :note |  
            | dateOver |  
            dateOver := self transformDate: note created_at to: over.  
            groupedByDate at: dateOver printString ifPresent: [ :v | v add: note ].  
        ]  
    ].  
    groupedByDate := groupedByDate collect: [ :notesGroup |  
        notesGroup size.  
    ].   
    ^ groupedByDate average asFloat .
]

{ #category : #accessing }
AverageCreatedNotesInMR >> description [

	^ 'Average number of comments/notes by MR for a project'
]

{ #category : #loading }
AverageCreatedNotesInMR >> load [
	projectMergeRequests := self
	                      loadMergeRequestsSince:  (period at: #since)
	                      until:  (period at: #until) .
	projectMergeRequests do: [ :mr | glhImporter importNotesfromMergeRequest: mr ].
]
