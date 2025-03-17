Class {
	#name : #GLHCommitHiedraVisualization,
	#superclass : #SpPresenter,
	#instVars : [
		'groupCommitBlock',
		'hiedraColumnController',
		'ancestorIds'
	],
	#category : #'GitLabHealth-Model-Visualization'
}

{ #category : #'instance creation' }
GLHCommitHiedraVisualization >> forCommits: commits [

	| table |
	table := self newTable.
	table items: commits.
	self initializeHiedraColumnForCommits: commits.
	table
		addColumn: (SpImageTableColumn evaluated: [ :item |
					 hiedraColumnController cellMorphAtValue: item ]);
		addColumn: (SpStringTableColumn evaluated: [ :item | item message ]);
		addColumn: (SpStringTableColumn evaluated: [:commit | String streamContents:[:str |  commit committed_date asDate printOn: str format: #(1 2 3 $  2 2) ] ]).
	hiedraColumnController ruler:
		(HiRulerBuilder newRulerValues: commits linksBlock: [ :aCommit |
			 (aCommit parentCommits collect: #id) collect: [ :id |
				 commits detect: [ :each | each id = id ] ] ]).
	hiedraColumnController reset.
	"After #reset, we know the desired width for the column."
	table columns first width: hiedraColumnController rulerWidth.
	table columns last width: 75.
	^ table
]

{ #category : #initialization }
GLHCommitHiedraVisualization >> initialize [

	super initialize.
]

{ #category : #'as yet unclassified' }
GLHCommitHiedraVisualization >> initializeHiedraColumnForCommits: commits [

	hiedraColumnController := HiColumnController new.
	hiedraColumnController renderer
		linkWidth: 3.5;
		nodeRadius: 1.5;
		nodeBorderWidth: 3.0;
		arrowSize: 0;
		nodeConnectionOffset: 3;
		cellWidth: 8";
		useUniformColorStrategy".
	"Adjust the ruler rendering settings with table's row height."
	hiedraColumnController renderer rowHeight:
		FTTableMorph defaultRowHeight floor
]
