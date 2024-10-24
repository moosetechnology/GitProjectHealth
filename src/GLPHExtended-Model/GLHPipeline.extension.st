Extension { #name : #GLHPipeline }

{ #category : #'*GLPHExtended-Model-accessing' }
GLHPipeline >> mergeResquest [
	"Relation named: #mergeResquest type: #GLPHEMergeRequest opposite: #pipeline"

	<generated>
	<derived>
	<FMProperty: #mergeResquest type: #GLPHEMergeRequest opposite: #pipeline>
	<package: #'GLPHExtended-Model'>
	^ self attributeAt: #mergeResquest ifAbsent: [ nil ]
]

{ #category : #'*GLPHExtended-Model-accessing' }
GLHPipeline >> mergeResquest: anObject [

	<generated>
	(self attributeAt: #mergeResquest ifAbsentPut: [nil]) == anObject ifTrue: [ ^ anObject ].
	anObject ifNil: [ | otherSide |
		otherSide :=  self mergeResquest.
		self attributeAt: #mergeResquest put: anObject.
		otherSide pipeline: nil ]
	ifNotNil: [ 
		self attributeAt: #mergeResquest put: anObject.
		anObject pipeline: self ]
]
