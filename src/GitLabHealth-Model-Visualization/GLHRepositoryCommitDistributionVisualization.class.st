Class {
	#name : 'GLHRepositoryCommitDistributionVisualization',
	#superclass : 'MiAbstractVisualization',
	#category : 'GitLabHealth-Model-Visualization',
	#package : 'GitLabHealth-Model-Visualization'
}

{ #category : 'instance creation' }
GLHRepositoryCommitDistributionVisualization >> forRepository: aRepository [

	| c lb oldestCommit oldestCommitDate commitByDate horizontal |
	c := RSCompositeChart new.
	oldestCommit := aRepository commits last.
	oldestCommitDate := oldestCommit committed_date.
	commitByDate := (oldestCommitDate to: Date today) dates collect: [
		                :date |
		                date -> (aRepository commits select: [ :commit |
			                 commit committed_date asDate = date ]) ].

	c add: (RSAbstractChart barHeights:
			 (commitByDate collect: [ :dateToCommit | dateToCommit value size ])).
	"	c add: ((RSAbstractChart barHeights: womenMeans) bottom: menMeans)."
	horizontal := c horizontalTick fromNames:
		              (commitByDate collect: [ :dateToCommit |
			               dateToCommit key printString ]).
	horizontal configuration fontSize: 2.
	horizontal useDiagonalLabel.
	c verticalTick integer.
	c ylabel: 'Number of commits'.
	c title: 'Number of commits by date grouped by user'.
	c build.
	lb := RSLegend new.
	lb layout horizontal.
	lb container: c canvas.
	lb build.
	^ c canvas
]
