Class {
	#name : #GLHCommitDistributionAverageByWeekDayVisualization,
	#superclass : #GLHCommitDistributionVisualization,
	#category : #'GitLabHealth-Model-Visualization'
}

{ #category : #'instance creation' }
GLHCommitDistributionAverageByWeekDayVisualization >> forCommits: aCommitsCollection [

	| c  horizontal commitGroups  dates data |
	c := RSBoxPlot new.
	aCommitsCollection ifEmpty: [ ^ c canvas ].

	dates := Date dayNames.

	"default is group by commitCreator (initialize)"
	commitGroups := aCommitsCollection groupedBy: [ :commit |
		                commit committed_date asDate ].


	data := (dates collect: [ :day |
		         | commitsAtDay |
		         commitsAtDay := OrderedCollection new.
		         commitGroups keysAndValuesDo: [ :date :commitsAtDate |
			         date dayOfWeekName = day ifTrue: [
				         commitsAtDay add: commitsAtDate size ] ].

		         day -> (commitsAtDay ifEmpty: [ { 0 } ]) ]) asDictionary.
	
	c y: data values.

	horizontal := c horizontalTick fromNames: dates.
	horizontal configuration fontSize: 10.
	horizontal useDiagonalLabel.


	c verticalTick integer.
	c ylabel: 'Average commits'.
	c title: 'Average commits by day of the week'.
	c build.

	"lb := RSLegend new.
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
	lb build."
	^ c canvas
]
