Class {
	#name : #CodeChurnOnMergedMergeRequestProjectMetric,
	#superclass : #ProjectMetric,
	#instVars : [
		'maxCommitWindow'
	],
	#category : #'GitLabHealth-Model-Analysis'
}

{ #category : #calculating }
CodeChurnOnMergedMergeRequestProjectMetric >> calculate [

	| res groupedByDate totalContributions gitAnalyzer parentsCommits |
	projectMergeRequests ifNil: [ self load ].

	totalContributions := OrderedCollection new.


	groupedByDate := self setupGroupedDate.

	parentsCommits := projectMergeRequests collect: [ :mr |
		                  | parentCommit mergedCommit |
		                  mergedCommit := mr mergedCommit.
		                  mergedCommit parentCommits
			                  addAll:
				                  (mergedCommit parent_ids collect: [ :id |
					                   glhImporter
						                   importCommit: id
						                   ofProject: project ])
			                  unless: glhImporter blockOnIdEquality.
		                  parentCommit := (mergedCommit parentCommits sort: [
			                                   :c1
			                                   :c2 | "oldest commit first"
			                                   c1 created_at < c2 created_at ])
			                                  first ].


	gitAnalyzer := GitAnalyzer new maxChildCommit: 1.
	res := parentsCommits collect: [ :commit |
		       commit -> (gitAnalyzer
			        fromCommit: commit;
			        analyseChurn) ].

	res do: [ :commits4Churns |
		| commit allChurnsInCommit sumChurnInCommit overDate contribution churnOnCommit |
		commit := commits4Churns key.
		allChurnsInCommit := commits4Churns value.
		sumChurnInCommit := (allChurnsInCommit at: #churns) sum: [ :churn |
			                    | numerator |
			                    numerator := churn value at: #churnLoC.
			                    numerator ].
		contribution := allChurnsInCommit at: #totalContribution.
		totalContributions add: contribution.
		churnOnCommit := {
			                 (#churnOnCommit -> sumChurnInCommit).
			                 (#LoCOnCommit -> contribution) } asDictionary.
		overDate := self transformDate: commit created_at to: over.
		groupedByDate
			at: overDate printString
			ifPresent: [ :array | array add: churnOnCommit ]
			ifAbsentPut: [
				OrderedCollection new
					add: churnOnCommit;
					yourself ] ].
	groupedByDate := groupedByDate collect: [ :churnsAtDate |
		                 | totalChurn totalContribution percentage |
		                 totalChurn := churnsAtDate sum: [ :churn |
			                               churn at: #churnOnCommit ].
		                 totalContribution := churnsAtDate sum: [ :churn |
			                                      churn at: #LoCOnCommit ].
		                 totalContribution = 0
			                 ifTrue: [ percentage := 0 asFloat ]
			                 ifFalse: [
			                 percentage := (totalChurn * 100
			                                / totalContribution) asFloat ].
		                 {
			                 (#churn -> totalChurn).
			                 (#contribution -> totalContribution).
			                 (#percentage -> percentage) } asDictionary ].

	^ (groupedByDate collect: [ :date | date at: #percentage ]) average
]

{ #category : #accessing }
CodeChurnOnMergedMergeRequestProjectMetric >> description [

	^ 'churn % made by a MR (avg by MR)'
]

{ #category : #initialization }
CodeChurnOnMergedMergeRequestProjectMetric >> initialize [ 
	maxCommitWindow := 3. 
]

{ #category : #loading }
CodeChurnOnMergedMergeRequestProjectMetric >> load [

	projectMergeRequests := self
		                        loadMergeRequestsSince: (period at: #since)
		                        until: (period at: #until).
		
		projectMergeRequests := projectMergeRequests select: [ :mr |
		                        mr state = #merged ].
	
		projectMergeRequests do: [ :mr | glhImporter importMergeRequestMergeCommits: mr ]
]

{ #category : #accessing }
CodeChurnOnMergedMergeRequestProjectMetric >> maxCommitWindow: anInteger [ 
	maxCommitWindow := anInteger
]
