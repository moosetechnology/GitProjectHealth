Class {
	#name : #CodeChurnOnCommitsProjectMetric,
	#superclass : #ProjectMetric,
	#instVars : [
		'maxCommitWindow'
	],
	#category : #'GitLabHealth-Model-Analysis'
}

{ #category : #calculating }
CodeChurnOnCommitsProjectMetric >> calculate [

	| commits res groupedByDate totalContributions gitAnalyzer |
	projectCommits ifNil: [ self load ].

	totalContributions := OrderedCollection new.
	groupedByDate := self setupGroupedDate.
	gitAnalyzer := GitAnalyzer new maxChildCommit: maxCommitWindow.

	commits := self
		           foundSuccessorOf: projectCommits
		           andCompleteImportForMax: maxCommitWindow.

	res := commits collect: [ :commit |
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
CodeChurnOnCommitsProjectMetric >> description [

	^ 'churn % in project (W=' , maxCommitWindow printString , ')'
]

{ #category : #initialization }
CodeChurnOnCommitsProjectMetric >> initialize [ 
	maxCommitWindow := 3. 
]

{ #category : #loading }
CodeChurnOnCommitsProjectMetric >> load [

	projectCommits := self
		                  loadCommitsSince: (period at: #since)
		                  until: (period at: #until)
]

{ #category : #accessing }
CodeChurnOnCommitsProjectMetric >> maxCommitWindow: anInteger [ 
	maxCommitWindow := anInteger
]
