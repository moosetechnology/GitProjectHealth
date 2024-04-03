Extension { #name : #GLHDiff }

{ #category : #'*GLPHExtended-Model-accessing' }
GLHDiff >> addition [
	"Relation named: #addition type: #GLPHEAddition opposite: #diffs"

	<generated>
	<derived>
	<FMProperty: #addition type: #GLPHEAddition opposite: #diffs>
	<package: #'GLPHExtended-Model'>
	^ self attributeAt: #addition ifAbsentPut: [ FMMultivalueLink on: self opposite: #diffs: ]
]

{ #category : #'*GLPHExtended-Model-accessing' }
GLHDiff >> addition: anObject [

	<generated>
	self addition value: anObject
]

{ #category : #'*GLPHExtended-Model-accessing' }
GLHDiff >> changes [
	"Relation named: #changes type: #GLPHEChange opposite: #diff"

	<generated>
	<derived>
	<FMProperty: #changes type: #GLPHEChange opposite: #diff>
	<package: #'GLPHExtended-Model'>
	^ self attributeAt: #changes ifAbsentPut: [ FMMultivalueLink on: self opposite: #diff: ]
]

{ #category : #'*GLPHExtended-Model-accessing' }
GLHDiff >> changes: anObject [

	<generated>
	self changes value: anObject
]

{ #category : #'*GLPHExtended-Model-accessing' }
GLHDiff >> deletion [
	"Relation named: #deletion type: #GLPHEDeletion opposite: #diffs"

	<generated>
	<derived>
	<FMProperty: #deletion type: #GLPHEDeletion opposite: #diffs>
	<package: #'GLPHExtended-Model'>
	^ self attributeAt: #deletion ifAbsentPut: [ FMMultivalueLink on: self opposite: #diffs: ]
]

{ #category : #'*GLPHExtended-Model-accessing' }
GLHDiff >> deletion: anObject [

	<generated>
	self deletion value: anObject
]

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
