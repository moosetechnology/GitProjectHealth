Class {
	#name : #CreatedACRPipelineByProject,
	#superclass : #ProjectMetric,
	#category : #'GitLabHealth-Model-Analysis'
}

{ #category : #acr }
CreatedACRPipelineByProject class >> acrBotId [
	^2661.
]

{ #category : #calculating }
CreatedACRPipelineByProject >> calculate [  
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
        (notesGroup select: [ :note | (note author isNotNil and: [ note author id = self class acrBotId ]) and: note body = 'The automated review has been completed. No modifications were found based on the current analysis rules.']) size .  
    ].   

    ^ groupedByDate sum asFloat.
]

{ #category : #accessing }
CreatedACRPipelineByProject >> description [

	^ 'Number of ACR pipeline run for a project'
]

{ #category : #loading }
CreatedACRPipelineByProject >> load [
	projectMergeRequests := self
	                      loadMergeRequestsSince:  (period at: #since)
	                      until:  (period at: #until) .
	projectMergeRequests do: [ :mr | glhImporter importNotesfromMergeRequest: mr ].
]
