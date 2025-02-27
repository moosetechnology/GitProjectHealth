Class {
	#name : #MergedMergeRequestMetric,
	#superclass : #UserMergeRequestMetric,
	#category : #'GitLabHealth-Model-Analysis'
}

{ #category : #calculating }
MergedMergeRequestMetric >> calculate [

	| groupedByDate userMergedMergeRequests dateOver |
		userMergeRequests ifNil: [ self load ].

	groupedByDate := self setupGroupedDate.

	"filter to see the MR associated to one user"
	userMergedMergeRequests := userMergeRequests select: [
		                           :userMergeRequest |
		                           userMergeRequest merge_user isNotNil 
												and: [ userMergeRequest merge_user id = user id ] ].
											
	"filter to reject MR that are not merge"
	userMergedMergeRequests := userMergedMergeRequests reject: [ :mr | mr merged_at isNil ].
	
	userMergedMergeRequests do: [ :userMergeRequest |
		"here we look at the specific date of its merged"
		dateOver := self transformDate: userMergeRequest merged_at to: over.
		groupedByDate
			at: dateOver printString
			ifPresent: [ :value | value add: userMergeRequest ] ].
	groupedByDate := groupedByDate collect: [ :group | group size ].

	^ groupedByDate average asFloat
]

{ #category : #accessing }
MergedMergeRequestMetric >> description [

	^ 'number of merge request merged by this user'
]

{ #category : #loading }
MergedMergeRequestMetric >> load [

	userMergeRequests := self
		                     loadMergeRequestsSince: (period at: #since)
		                     until: (period at: #until)
]

{ #category : #accessing }
MergedMergeRequestMetric >> name [

	^ 'mergedMergeRequest'
]
