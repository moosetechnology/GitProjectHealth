Class {
	#name : #AutoCodeReviewCommitFrequencyProjectMetric,
	#superclass : #ProjectMetric,
	#category : #'GitLabHealth-Model-Analysis'
}

{ #category : #calculating }
AutoCodeReviewCommitFrequencyProjectMetric >> calculate [  
    | groupedByDate |  
    projectCommits ifNil: [ self load ].  
    groupedByDate := self setupGroupedDate.  

    projectCommits do: [ :c |  
        (c title beginsWith: '[ACR]')  ifTrue: [  
            | dateOver |  
            dateOver := self transformDate: c created_at to: over.  
            groupedByDate at: dateOver printString ifPresent: [ :v | v add: c ]  
        ]  
    ].  

    groupedByDate := groupedByDate collect: [ :group | group size ].  
    ^ groupedByDate average asFloat.
]

{ #category : #accessing }
AutoCodeReviewCommitFrequencyProjectMetric >> description [

	^ 'Nb AutoCodeReview commit for accepted suggestion (avg)'
]

{ #category : #loading }
AutoCodeReviewCommitFrequencyProjectMetric >> load [
	projectCommits := self loadCommitsSince: (period at: #since) until: (period at: #until) 
]
