Extension { #name : #GLHRepository }

{ #category : #'*GitLabHealth-Model-Visualization' }
GLHRepository >> rsCommitDistribution: aBuilder [

	<inspectorPresentationOrder: 100 title: 'Commits distribution'>
	^ SpRoassalInspectorPresenter new
		  canvas:
			  (GLHCommitDistributionVisualization new forCommits:
					   self commits);
		  yourself
]

{ #category : #'*GitLabHealth-Model-Visualization' }
GLHRepository >> rsCommitHistory: aBuilder [

	<inspectorPresentationOrder: 100 title: 'Commits History'>
	^ GLHCommitHiedraVisualization new forCommits: self commits
]

{ #category : #'*GitLabHealth-Model-Visualization' }
GLHRepository >> rsWeeklyActivity: aBuilder [

	<inspectorPresentationOrder: 101 title: 'Weekly Commits'>
	^ SpRoassalInspectorPresenter new
		  canvas:
			  (GLHCommitDistributionByWeekDayVisualization new forCommits: self commits);
		  yourself
]
