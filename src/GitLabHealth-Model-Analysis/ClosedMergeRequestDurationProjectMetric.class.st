Class {
	#name : #ClosedMergeRequestDurationProjectMetric,
	#superclass : #ProjectMetric,
	#category : #'GitLabHealth-Model-Analysis'
}

{ #category : #calculating }
ClosedMergeRequestDurationProjectMetric >> calculate [

	| groupedByDate gitAnalyzer mergeRequestsValidation filterGroups |
	projectMergeRequests ifNil: [ self load ].

	groupedByDate := self setupGroupedDate.
	
	"Filtrer les merge requests pour ne garder que celles qui ont une date de clôture (closed_at) et un statut 'closed'"
     projectMergeRequests := projectMergeRequests select: [ :mr | 
    (mr closed_at) notNil and: [(mr state) = 'closed'] ]. 

	projectMergeRequests ifEmpty: [ ^ nil ].

	gitAnalyzer := GitAnalyzer new.

	mergeRequestsValidation := projectMergeRequests collect: [ :mr |
		                           gitAnalyzer
			                           analyseMergeResquestValidation: mr ].


	mergeRequestsValidation do: [ :dic |
		| overDate |
		overDate := self transformDate: (dic at: #closed_at) to: over.

		groupedByDate
			at: overDate printString
			ifPresent: [ :durations | durations add: (dic at: #close_duration) ] ].

	"deleting the empty array (merge request that are not closed )"
	filterGroups := groupedByDate reject: [ :array | array isEmpty ].
	"Check if filterGroups is empty before proceeding to avoid merge request out of analyse periode "
	filterGroups isEmpty ifTrue: [ ^ 0 ].

	filterGroups associations do: [ :assoc |
		| sum denominator |
		denominator := assoc value size.

		sum := assoc value sum: [ :v |
			       v ifNil: [
				       denominator := denominator - 1.
				       0 asDuration ] ].
		denominator = 0 ifTrue: [ denominator := 1 ].

		filterGroups at: assoc key put: sum / denominator ].

	^ filterGroups average asSeconds
]

{ #category : #accessing }
ClosedMergeRequestDurationProjectMetric >> description [

	^ 'closed merge request  duration (second)'
]

{ #category : #loading }
ClosedMergeRequestDurationProjectMetric >> load [

	projectMergeRequests := self
	                      loadMergeRequestsSince:  (period at: #since)
	                      until:  (period at: #until)
]
