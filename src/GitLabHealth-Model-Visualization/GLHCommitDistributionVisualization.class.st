Class {
	#name : 'GLHCommitDistributionVisualization',
	#superclass : 'MiAbstractVisualization',
	#instVars : [
		'groupCommitBlock'
	],
	#category : 'GitLabHealth-Model-Visualization',
	#package : 'GitLabHealth-Model-Visualization'
}

{ #category : 'instance creation' }
GLHCommitDistributionVisualization >> forCommits: commits [

	| c lb oldestCommit horizontal commitGroups groupToCommitByDate alreadyAdded dates |
	c := RSCompositeChart new.
	oldestCommit := commits last.
	dates := (oldestCommit committed_date to: Date today) dates.

	commitGroups := commits groupedBy: self groupCommitBlock.

	groupToCommitByDate := commitGroups associations collect: [ :assoc |
		                       assoc key -> (dates collect: [ :date |
			                        date
			                        ->
			                        (assoc value select: [ :commit |
				                         commit committed_date asDate = date ]) ]) ].

	alreadyAdded := dates collect: [ :d | 0 ].
	groupToCommitByDate do: [ :assocGroupToCommitByDate |
		| chart |
		chart := (RSAbstractChart barHeights:
			          (assocGroupToCommitByDate value collect: [ :dateToCommit |
				           dateToCommit value size ])) bottom: alreadyAdded.
		c add: chart.
		alreadyAdded := chart yValues ].

	horizontal := c horizontalTick fromNames:
		              (dates collect: [ :date | date printString ]).
	horizontal configuration fontSize: 2.
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

{ #category : 'accessing' }
GLHCommitDistributionVisualization >> groupCommitBlock [

	^ groupCommitBlock
]

{ #category : 'accessing' }
GLHCommitDistributionVisualization >> groupCommitBlock: anObject [

	groupCommitBlock := anObject
]

{ #category : 'initialization' }
GLHCommitDistributionVisualization >> initialize [

	super initialize.
	groupCommitBlock := [ :commit | commit commitCreator ]
]
