Class {
	#name : #GLHCommitDistributionVisualization,
	#superclass : #MiAbstractVisualization,
	#instVars : [
		'groupCommitBlock'
	],
	#category : #'GitLabHealth-Model-Visualization'
}

{ #category : #'instance creation' }
GLHCommitDistributionVisualization >> forCommits: aCommitsCollection [

	| c lb horizontal commitGroups groupToCommitByDate alreadyAdded dates commits|
	c := RSCompositeChart new.
	aCommitsCollection ifEmpty: [ ^ c canvas].
	commits := (aCommitsCollection sort: [ :c1 :c2 | c1 committed_date  > c2 committed_date  ]).
	"collect dates from oldest to youngest among commits"
	dates := (commits last committed_date to: commits first committed_date) dates.

	"default is group by commitCreator (initialize)"
	commitGroups := commits groupedBy: self groupCommitBlock.

	groupToCommitByDate := commitGroups associations collect: [ :assoc |
		                       assoc key -> (dates collect: [ :date |
			                        date
			                        ->
			                        (assoc value select: [ :commit |
												"weird, but only way I know to compare two dates with different timezone."
				                         commit committed_date asDate asString  = date asString ]) ]) ].
	 
	alreadyAdded := dates collect: [ :d | 0 ].
	groupToCommitByDate do: [ :assocGroupToCommitByDate |
		| chart |
		chart := (RSAbstractChart barHeights:
			          (assocGroupToCommitByDate value collect: [ :dateToCommit |
				           dateToCommit value size ])) bottom: alreadyAdded.
		c add: chart.
		alreadyAdded := alreadyAdded + chart yValues ].

	horizontal := c horizontalTick fromNames:
		              (dates collect: [ :date | date printString ]).
	horizontal configuration fontSize: 10.
	horizontal useDiagonalLabel.
	c verticalTick integer.
	c ylabel: 'Number of commits'.
	c title: 'Number of commits by date'.
	c build.
	lb := RSLegend new.
	lb layout vertical.
	commitGroups keys doWithIndex: [ :groupObject :index |
		lb
			text: groupObject fullDisplayString
			withBoxColor: (c plots at: index) computeColor ].
	lb container: c canvas.
	lb location
		right;
		middle;
		offset: 10 @ 0.
	lb build.
	^ c canvas
]

{ #category : #'as yet unclassified' }
GLHCommitDistributionVisualization >> groupCommitBlock [

	^ groupCommitBlock
]

{ #category : #'as yet unclassified' }
GLHCommitDistributionVisualization >> groupCommitBlock: anObject [

	groupCommitBlock := anObject
]

{ #category : #initialization }
GLHCommitDistributionVisualization >> initialize [

	super initialize.
	groupCommitBlock := [ :commit | commit commitCreator ]
]
