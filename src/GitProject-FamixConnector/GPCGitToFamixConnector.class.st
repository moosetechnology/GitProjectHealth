"
I am a connector between a git project represented using a `GLHProject` and any Famix model that use file base source anchor.
I might be adapted to support more options

## Example

This is a basic usage example

```st
GPCGitToFamixConnector new
	famixModel: myFamixModel;
	glhProject: myGitProject;
	connect
```
"
Class {
	#name : #GPCGitToFamixConnector,
	#superclass : #Object,
	#instVars : [
		'famixModel',
		'glhProject'
	],
	#category : #'GitProject-FamixConnector'
}

{ #category : #accessing }
GPCGitToFamixConnector >> connect [

	self glhProject repository commits do: [ :commit |
		self connectCommit: commit ]
]

{ #category : #accessing }
GPCGitToFamixConnector >> connectCommit: commit [
	"I connect a glhCommit with the famix model"

	commit diffs do: [ :diff | self connectDiff: diff ]
]

{ #category : #accessing }
GPCGitToFamixConnector >> connectDiff: diff [
	"I connect a glhDiff with the famix model"
	| col |
	col := OrderedCollection new.
	col addAll: ((famixModel allUsing: FamixTClass) reject: #isAnonymousClass).
	col addAll: (famixModel allUsing: FamixTEnum).
	col addAll: ((famixModel allWithType: FamixJavaInterface) reject: [ :type |
	type sourceAnchor isNil ]). 
	col
		detect: [ :class |
		(self fullSourceAnchorPath: class)  endsWith: diff new_path ]
		ifFound: [ :class | class appliedDiffs add: diff ]
]

{ #category : #accessing }
GPCGitToFamixConnector >> famixModel [

	^ famixModel
]

{ #category : #accessing }
GPCGitToFamixConnector >> famixModel: anObject [

	famixModel := anObject
]

{ #category : #accessing }
GPCGitToFamixConnector >> fullSourceAnchorPath: aSourcedEntity [
	"string of the full path name of aSourcedEntity source file, within the mooseModel rootFolder"

	^(aSourcedEntity mooseModel rootFolder / (aSourcedEntity sourceAnchor fileName)) fullName
]

{ #category : #accessing }
GPCGitToFamixConnector >> glhProject [

	^ glhProject
]

{ #category : #accessing }
GPCGitToFamixConnector >> glhProject: anObject [

	glhProject := anObject
]

{ #category : #accessing }
GPCGitToFamixConnector >> resetConnection [
	"I connect a glhDiff with the famix model"

	(famixModel allUsing: FamixTSourceEntity) do: [ :class |
		class appliedDiffs removeAll.
		class removeAttribute: #appliedDiffs ]
]
