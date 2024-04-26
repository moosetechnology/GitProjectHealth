Extension { #name : #GLHDiff }

{ #category : #'*GLPHExtended-Model-accessing' }
GLHDiff >> diffRanges [
	"Relation named: #diffRanges type: #GLPHEDiffRange opposite: #diff"

	<generated>
	<derived>
	<FMProperty: #diffRanges type: #GLPHEDiffRange opposite: #diff>
	<package: #'GLPHExtended-Model'>
	^ self attributeAt: #diffRanges ifAbsentPut: [ FMMultivalueLink on: self opposite: #diff: ]
]

{ #category : #'*GLPHExtended-Model-accessing' }
GLHDiff >> diffRanges: anObject [

	<generated>
	self diffRanges value: anObject
]

{ #category : #'*GLPHExtended-Model-accessing' }
GLHDiff >> file [
	"Relation named: #file type: #GLHFile opposite: #diffs"

	<generated>
	<derived>
	<FMProperty: #file type: #GLHFile opposite: #diffs>
	<package: #'GLPHExtended-Model'>
	^ self attributeAt: #file ifAbsentPut: [ FMMultivalueLink on: self opposite: #diffs: ]
]

{ #category : #'*GLPHExtended-Model-accessing' }
GLHDiff >> file: anObject [

	<generated>
	self file value: anObject
]

{ #category : #'*GLPHExtended-Model-accessing' }
GLHDiff >> mergeRequest [
	"Relation named: #mergeRequest type: #GLPHEMergeRequest opposite: #diffs"

	<generated>
	<FMProperty: #mergeRequest type: #GLPHEMergeRequest opposite: #diffs>
	<package: #'GLPHExtended-Model'>
	^ self attributeAt: #mergeRequest ifAbsent: [ nil ]
]

{ #category : #'*GLPHExtended-Model-accessing' }
GLHDiff >> mergeRequest: anObject [

	<generated>
	self attributeAt: #mergeRequest put: (FMMultivalueLink on: self update: #diffs from: self mergeRequest to: anObject).
]
