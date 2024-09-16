Extension { #name : 'GLHUser' }

{ #category : '*GitLabHealth-Visualization' }
GLHUser >> rsCommitDistribution: aBuilder [

	<inspectorPresentationOrder: 100 title: 'Commits distribution'>
	^ SpRoassalInspectorPresenter new
		  canvas: (GLHCommitDistributionVisualization new
				   groupCommitBlock: [ :commit | commit repository project ];
				   forCommits: self commits);
		  yourself
]
