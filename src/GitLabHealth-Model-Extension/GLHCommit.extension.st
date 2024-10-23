Extension { #name : 'GLHCommit' }

{ #category : '*GitLabHealth-Model-Extension' }
GLHCommit >> computeChurnForMaxCommits: aLimit [

	^ GitAnalyzer new
		  fromCommit: self;
		  maxChildCommit: aLimit;
		  analyseChurn
]

{ #category : '*GitLabHealth-Model-Extension' }
GLHCommit >> displayStringOn: aStream [

	aStream
		<< (self short_id ifNil: [ self id first: 7 ]);
		<< ' ';
		<< self message
]

{ #category : '*GitLabHealth-Model-Extension' }
GLHCommit >> inspectionGLHCommitChildren [

	<inspectorPresentationOrder: 3 title: 'Commits Tree'>
	| canvas |
	canvas := RSCommit canvasCompleteHierachyFor: self.

	^ canvas asPresenter
]

{ #category : '*GitLabHealth-Model-Extension' }
GLHCommit >> inspectionGLHCommitFileImpacts [

	<inspectorPresentationOrder: 3 title: 'File Impact'>
	| canvas |
	canvas := RSCommit canvasDiffImpactFor: self.

	^ canvas asPresenter
]

{ #category : '*GitLabHealth-Model-Extension' }
GLHCommit >> mooseNameOn: stream [
	message ifNotNil: [ :mess | stream nextPutAll: mess ] ifNil: [
		stream
			nextPutAll: 'Commit#';
			nextPutAll: (short_id ifNil: [ 'unknow id' ]) ]
]

{ #category : '*GitLabHealth-Model-Extension' }
GLHCommit >> parent_ids [
	
	^ parent_ids
]
