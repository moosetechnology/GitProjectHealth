Extension { #name : #GLHUser }

{ #category : #'*GitLabHealth-Model-Visualization' }
GLHUser >> rsWeeklyActivity: aBuilder [

	<inspectorPresentationOrder: 101 title: 'Weekly Commits'>
	^ SpRoassalInspectorPresenter new
		  canvas:
			  (GLHCommitDistributionByWeekDayVisualization new forCommits:
					   self commits);
		  yourself
]
