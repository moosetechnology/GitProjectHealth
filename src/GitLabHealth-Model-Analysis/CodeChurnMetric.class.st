Class {
	#name : #CodeChurnMetric,
	#superclass : #UserMetric,
	#instVars : [
		'maxCommitWindow'
	],
	#category : #'GitLabHealth-Model-Analysis'
}

{ #category : #calculating }
CodeChurnMetric >> calculate [

	| commits res groupedByDate totalContributions gitAnalyzer |
	totalContributions := OrderedCollection new.
	groupedByDate := self setupGroupedDate.
	gitAnalyzer := GitAnalyzer new
		               glhImporter: glhImporter;
		               maxChildCommit: maxCommitWindow.
	glhImporter withCommitDiffs: false.
	commits := self
		           foundSuccessorOf: userCommits
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
CodeChurnMetric >> description [

	^ 'churn % (W=' , maxCommitWindow printString , ')'
]

{ #category : #initialization }
CodeChurnMetric >> initialize [ 
	maxCommitWindow := 3
]

{ #category : #loading }
CodeChurnMetric >> load [

	self loadUserProjects.
	self loadUserCommits.
]

{ #category : #accessing }
CodeChurnMetric >> name [

	^ 'codeChurn'
]
