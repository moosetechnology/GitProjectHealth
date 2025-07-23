Class {
	#name : #GLHSpDiffView,
	#superclass : #SpPresenterWithModel,
	#instVars : [
		'diff'
	],
	#category : #'GitLabHealth-Model-Visualization'
}

{ #category : #layout }
GLHSpDiffView >> defaultLayout [

	^ SpBoxLayout newTopToBottom
		  add: diff expand: true fill: true;
		  yourself
]

{ #category : #initialization }
GLHSpDiffView >> initializePresenters [

	| lines |
	super initializePresenters.
	diff := self newDiff.
	diff showOptions: false.
	lines := self model diffString lines.
	diff leftLabel: (lines first splitOn: '/') last.
	diff leftText: (String cr join: ((lines allButFirst: 2)
				  reject: [ :line |
				  (line beginsWith: '+') or: [ line beginsWith: '@@' ] ]
				  thenCollect: [ :line | line withoutPrefix: '-' ])).
	diff rightLabel: (lines second splitOn: '/') last.
	diff rightText: (String cr join: ((lines allButFirst: 2)
				  reject: [ :line |
				  (line beginsWith: '-') or: [ line beginsWith: '@@' ] ]
				  thenCollect: [ :line | line withoutPrefix: '+' ]))
]
