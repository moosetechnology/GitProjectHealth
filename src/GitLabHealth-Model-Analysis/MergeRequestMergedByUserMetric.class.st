Class {
	#name : #MergeRequestMergedByUserMetric,
	#superclass : #UserMergeRequestMetric,
	#instVars : [
		'allMergeRequestDuringPeriod'
	],
	#category : #'GitLabHealth-Model-Analysis'
}

{ #category : #calculating }
MergeRequestMergedByUserMetric >> calculate [

	| groupedByDate userMergedMergeRequests dateOver |
	allMergeRequestDuringPeriod ifNil: [ self load ].

	groupedByDate := self setupGroupedDate.

	"filter to see the MR associated to one user"
	userMergedMergeRequests := allMergeRequestDuringPeriod select: [
		                           :userMergeRequest |
		                           userMergeRequest merge_user isNotNil
			                           and: [
			                           userMergeRequest merge_user id = user id ] ].

	"filter to reject MR that are not merge"
	userMergedMergeRequests := userMergedMergeRequests reject: [ :mr |
		                           mr merged_at isNil ].

	userMergedMergeRequests do: [ :userMergeRequest | "here we look at the specific date of its merged"
		dateOver := self transformDate: userMergeRequest merged_at to: over.
		groupedByDate
			at: dateOver printString
			ifPresent: [ :value | value add: userMergeRequest ] ].
	groupedByDate := groupedByDate collect: [ :group | group size ].

	^ groupedByDate average asFloat
]

{ #category : #accessing }
MergeRequestMergedByUserMetric >> description [

	^ 'number of merge request merged by this user'
]

{ #category : #loading }
MergeRequestMergedByUserMetric >> load [

	allMergeRequestDuringPeriod := self
		                     loadMergeRequestsSince: (period at: #since)
		                     until: (period at: #until)
]

{ #category : #accessing }
MergeRequestMergedByUserMetric >> name [

	^ 'mergeRequestMergedByThisUser'
]
