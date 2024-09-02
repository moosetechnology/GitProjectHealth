Class {
	#name : #DelayUntilFirstChurnMetric,
	#superclass : #UserCommitsMetric,
	#instVars : [
		'maxCommitWindow'
	],
	#category : #'GitLabHealth-Model-Analysis'
}

{ #category : #calculating }
DelayUntilFirstChurnMetric >> calculate [

	| commits groupedByDate res average |
	userCommits ifNil: [ self load ].
	groupedByDate := self setupGroupedDate.
	commits := user
		           foundSuccessorOf: userCommits
		           andCompleteImportForMax: maxCommitWindow.


	"class commit by dates, filter none user commits"
	commits do: [ :commit |
		commit commitCreator = user user ifTrue: [
			| overDate |
			overDate := self transformDate: commit created_at to: over.

			groupedByDate
				at: overDate printString
				ifPresent: [ :arrayOfCommits | arrayOfCommits add: commit ]
				ifAbsentPut: [
					OrderedCollection new
						add: commit;
						yourself ] ] ].



	res := groupedByDate collect: [ :commits4Date |
		       | durationFromA2B |
		       commits4Date collect: [ :commitA |
			       | commitB |
			       commitB := GitAnalyzer new
				                  fromCommit: commitA;
				                  maxChildCommit: maxCommitWindow;
				                  analyseDelayUntilFirstChurn.

			       durationFromA2B := commitB
				                          ifNil: [ 0 ]
				                          ifNotNil: [
				                          commitB created_at - commitA created_at ].
			       durationFromA2B ] ].



	res := res collect: [ :durationsByDate |
		       | filtered |
		       filtered := durationsByDate reject: [ :value | value = 0 ].
		       filtered isEmpty
			       ifTrue: [ nil ]
			       ifFalse: [
			       (filtered sum: [ :v | v asDuration asSeconds ])
			       / filtered size ] ].
	
	res := res reject: #isNil.

	average := res
		           ifEmpty: [ nil ]
		           ifNotEmpty: [ res values average asFloat ].

	^ average
]

{ #category : #accessing }
DelayUntilFirstChurnMetric >> description [

	^ 'delay Until First Churn (W=' , maxCommitWindow printString
			   , ')'
]

{ #category : #initialization }
DelayUntilFirstChurnMetric >> initialize [
	super initialize.
	maxCommitWindow := 3
]

{ #category : #accessing }
DelayUntilFirstChurnMetric >> name [

	^'delayUntilFirstChurn'
]
