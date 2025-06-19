Class {
	#name : #CreatedNoteInMergedOrClosedMergeRequest,
	#superclass : #ProjectMetric,
	#category : #'GitLabHealth-Model-Analysis'
}

{ #category : #calculating }
CreatedNoteInMergedOrClosedMergeRequest >> calculate [

	| groupedByDate |
	projectMergeRequests ifNil: [ self load ].
	groupedByDate := self setupGroupedDate.

	projectMergeRequests := projectMergeRequests select: [ :mr |
		                        mr state = #closed or: [ mr state = #merged ] ].
	
	projectMergeRequests do: [ :mergeRequest |
		| dateOver mrDate  |
		mrDate := mergeRequest state = #closed ifTrue: [ mergeRequest closed_at ] ifFalse: [ mergeRequest merged_at ].
		dateOver := self transformDate: mrDate to: over.
		groupedByDate at: dateOver printString ifPresent: [ :v | v add: mergeRequest ] ].

	groupedByDate := groupedByDate collect: [ :mergeRequestGroup |
		                 mergeRequestGroup sum: [ :mr | mr note size ] ].
	projectMergeRequests ifEmpty: [ ^ 0 ].
	^ (groupedByDate average / projectMergeRequests size) asFloat
]

{ #category : #accessing }
CreatedNoteInMergedOrClosedMergeRequest >> description [

	^ 'Average number of comments/notes by MR for a project'
]

{ #category : #loading }
CreatedNoteInMergedOrClosedMergeRequest >> load [
	projectMergeRequests := self
	                      loadMergeRequestsSince:  (period at: #since)
	                      until:  (period at: #until) .
	projectMergeRequests do: [ :mr | glhImporter importNotesfromMergeRequest: mr ].
]
