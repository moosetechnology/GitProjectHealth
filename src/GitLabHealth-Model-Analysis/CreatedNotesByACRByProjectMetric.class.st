Class {
	#name : #CreatedNotesByACRByProjectMetric,
	#superclass : #ProjectMetric,
	#category : #'GitLabHealth-Model-Analysis'
}

{ #category : #acr }
CreatedNotesByACRByProjectMetric class >> acrBotId [
	^ 2661 .
]

{ #category : #'as yet unclassified' }
CreatedNotesByACRByProjectMetric >> calculate [  
    | groupedByDate |  

    projectMergeRequests ifNil: [ self load ].  
    groupedByDate := self setupGroupedDate.  

    "Parcourir les merge requests et regrouper les notes par date"
    projectMergeRequests do: [ :mr |  
        mr note do: [ :note |  
            | dateOver |  
            dateOver := self transformDate: note created_at to: over.  
            groupedByDate at: dateOver printString ifPresent: [ :v | v add: note ].  
        ]  
    ].  

    " filter note over ACR bot Id"
    groupedByDate := groupedByDate collect: [ :notesGroup |  
        (notesGroup select: [ :note | note author id = self class acrBotId ]) size.  
    ].  

    "Retourner le total des notes filtrées"
    ^ groupedByDate average asFloat.

]

{ #category : #accessing }
CreatedNotesByACRByProjectMetric >> description [
	^ 'Nb AutoCodeReview notes in averge by MR'
]

{ #category : #loading }
CreatedNotesByACRByProjectMetric >> load [
	projectMergeRequests := self
	                      loadMergeRequestsSince:  (period at: #since)
	                      until:  (period at: #until) .
	projectMergeRequests do: [ :mr | glhImporter importNotesfromMergeRequest: mr ].
]
