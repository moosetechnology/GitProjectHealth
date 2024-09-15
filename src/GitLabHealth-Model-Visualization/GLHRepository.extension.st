Extension { #name : 'GLHRepository' }

{ #category : '*GitLabHealth-Model-Visualization' }
GLHRepository >> rsCommitDistribution: aBuilder [

	<inspectorPresentationOrder: 100 title: 'Commits distribution'>
	^ SpRoassalInspectorPresenter new
		  canvas:
			  (GLHCommitDistributionVisualization new forCommits:
					   self commits);
		  yourself
]
