Class {
	#name : #CreatedNotesByACRByProjectMetric,
	#superclass : #ProjectMetric,
	#category : #'GitLabHealth-Model-Analysis'
}

{ #category : #'as yet unclassified' }
CreatedNotesByACRByProjectMetric >> calculate [  
    | groupedByDate regex filteredGroupedByDate |  

    projectMergeRequests ifNil: [ self load ].  
    groupedByDate := self setupGroupedDate.  

    "Définition du regex pour filtrer les notes"
    regex := '.*Auto code review has detected that the code violates this rule.*' asRegex.

    "Parcourir les merge requests et regrouper les notes par date"
    projectMergeRequests do: [ :mr |  
        mr note do: [ :note |  
            | dateOver |  
            dateOver := self transformDate: note created_at to: over.  
            groupedByDate at: dateOver printString ifPresent: [ :v | v add: note ].  
        ]  
    ].  

    "Appliquer le regex sur les notes déjà filtrées par période"
    filteredGroupedByDate := groupedByDate collect: [ :notesGroup |  
        (notesGroup select: [ :note | regex search: note body ]) size.  
    ].  

    "Retourner le total des notes filtrées"
    ^ filteredGroupedByDate sum.

]

{ #category : #accessing }
CreatedNotesByACRByProjectMetric >> description [
	^ 'Nb AutoCodeReview notes for a project (all MR) in a given timeline'
]

{ #category : #loading }
CreatedNotesByACRByProjectMetric >> load [
	projectMergeRequests := self
	                      loadMergeRequestsSince:  (period at: #since)
	                      until:  (period at: #until) .
	projectMergeRequests do: [ :mr | glhImporter importNotesfromMergeRequest: mr ].
]
