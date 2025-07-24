Class {
	#name : #GLHSpCommitView,
	#superclass : #SpPresenterWithModel,
	#instVars : [
		'commitAuthorCapsule',
		'shortId',
		'commitDate',
		'commitMessage',
		'diffs',
		'inspectAuthorButton',
		'commitWebURLLink'
	],
	#category : #'GitLabHealth-Model-Visualization'
}

{ #category : #layout }
GLHSpCommitView >> defaultLayout [

	^ SpBoxLayout newTopToBottom
		  add: (SpBoxLayout newLeftToRight
				   add: 'Commit ' expand: false;
				   add: shortId expand: false;
				   add: commitWebURLLink withConstraints: [ :constraints |
					   constraints
						   width: 20;
						   height: 20 ];
				   add: ' authored ' expand: false;
				   add: commitDate expand: false;
				   add: ' by ' expand: false;
				   add: commitAuthorCapsule expand: false;
				   add: inspectAuthorButton withConstraints: [ :constraints |
				   constraints
					   width: 20;
					   height: 20 ];
				   yourself)
		  expand: false;
		  add: (SpPanedLayout newTopToBottom
				   positionOfSlider: 0.2;
				   add: commitMessage;
				   add: diffs;
				   yourself) yourself
]

{ #category : #initialization }
GLHSpCommitView >> initializePresenters [

	super initializePresenters.
	commitAuthorCapsule := self
		                       instantiate: GLHSpUserCapsule
		                       on: self model commitCreator.
	shortId := self newLabel.
	shortId label: self model short_id.
	commitDate := self newLabel.
	commitDate label: self model committed_date asDate ddmmyyyy.
	commitMessage := self newText.
	commitMessage text: self model message.
	diffs := self newNotebook.
	self model diffs do: [ :diff |
		| lines |
		diff diffString ifNotEmpty: [
			lines := diff diffString lines.
			diffs
				addPageTitle: (lines first splitOn: '/') last
				provider: [ GLHSpDiffView on: diff ] ] ].

	inspectAuthorButton := self newButton.
	inspectAuthorButton icon: (self iconNamed: #smallInspectIt).
	inspectAuthorButton action: [ self model commitCreator inspect ].

	commitWebURLLink := self newButton.
	commitWebURLLink icon: (self iconNamed: #remote).
	commitWebURLLink action: [ WebBrowser openOn: self model web_url ].
	(self model web_url isNil or: [self model web_url isEmpty]) ifTrue: [commitWebURLLink disable]
]

{ #category : #initialization }
GLHSpCommitView >> modelChanged [

]
