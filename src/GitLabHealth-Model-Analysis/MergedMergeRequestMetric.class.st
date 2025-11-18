"
I compute the case where an MR has for author the _user_, and has been merged

If the merge is merged by someone else, it counts since my _user_ created the MR
If the merge is created by someone else, and my _user_ merge it, it does not cound (the important is that the _user_ created it)
"
Class {
	#name : #MergedMergeRequestMetric,
	#superclass : #UserMergeRequestMetric,
	#category : #'GitLabHealth-Model-Analysis'
}

{ #category : #calculating }
MergedMergeRequestMetric >> calculate [

	| groupedByDate dateOver |
	userMergeRequests ifNil: [ self load ].

	groupedByDate := self setupGroupedDate.


	"filter to reject MR that are not merge"
	userMergeRequests := userMergeRequests reject: [ :mr |
		                     mr merged_at isNil ].

	userMergeRequests do: [ :userMergeRequest | "here we look at the specific date of its merged"
		dateOver := self transformDate: userMergeRequest merged_at to: over.
		groupedByDate
			at: dateOver printString
			ifPresent: [ :value | value add: userMergeRequest ] ].
	groupedByDate := groupedByDate collect: [ :group | group size ].

	^ groupedByDate average asFloat
]

{ #category : #accessing }
MergedMergeRequestMetric >> description [

	^ 'number of merge request created by this user that is merged'
]

{ #category : #accessing }
MergedMergeRequestMetric >> name [

	^ 'mergedMergeRequest'
]
