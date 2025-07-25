Class {
	#name : #GLHSpUserCapsule,
	#superclass : #SpPresenterWithModel,
	#instVars : [
		'userName'
	],
	#category : #'GitLabHealth-Model-Visualization'
}

{ #category : #layout }
GLHSpUserCapsule >> defaultLayout [

	^ SpBoxLayout newLeftToRight
		  add: userName;
		  yourself
]

{ #category : #initialization }
GLHSpUserCapsule >> initializePresenters [

	super initializePresenters.
	userName := self newLabel.
]

{ #category : #initialization }
GLHSpUserCapsule >> modelChanged [

	self model ifNotNil: [ userName label: self model name ]
]
