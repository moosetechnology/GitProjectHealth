Class {
	#name : #GLHCommitDistributionByWeekDayVisualization,
	#superclass : #GLHCommitDistributionVisualization,
	#category : #'GitLabHealth-Model-Visualization'
}

{ #category : #'instance creation' }
GLHCommitDistributionByWeekDayVisualization >> forCommits: aCommitsCollection [

	| c lb horizontal commitGroups alreadyAdded dates groupToCommitByProject |
	c := RSCompositeChart new.
	aCommitsCollection ifEmpty: [ ^ c canvas ].

	dates := Date dayNames.

	"default is group by commitCreator (initialize)"
	commitGroups := aCommitsCollection groupedBy: [ :commit |
		                commit repository project name ].

	groupToCommitByProject := commitGroups associations collect: [ :assoc |
		                          assoc key -> (dates collect: [ :date |
			                           date
			                           -> (assoc value select: [ :commit |
					                            commit committed_date dayOfWeekName
					                            = date ]) ]) ].



	alreadyAdded := dates asArray collect: [ :d | 0 ].

	groupToCommitByProject do: [ :assocGroupToCommitByProject |
		| chart |
		chart := (RSAbstractChart barHeights:
			          (assocGroupToCommitByProject value collect: [
				           :project2Commits | project2Commits value size ]))
			         bottom: alreadyAdded.
		c add: chart.
		chart color: assocGroupToCommitByProject key asColorHSL.
		alreadyAdded := alreadyAdded + chart yValues asArray ].

	horizontal := c horizontalTick fromNames: dates.
	horizontal configuration fontSize: 10.
	horizontal useDiagonalLabel.
	c verticalTick integer.
	c ylabel: 'Number of commits'.
	c title: 'Number of commits by Day of the Week'.
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
