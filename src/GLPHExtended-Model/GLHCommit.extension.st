Extension { #name : #GLHCommit }

{ #category : #'*GLPHExtended-Model-accessing' }
GLHCommit >> commitedMergeRequest [
	"Relation named: #commitedMergeRequest type: #GLPHEMergeRequest opposite: #mergeCommit"

	<generated>
	<derived>
	<FMProperty: #commitedMergeRequest type: #GLPHEMergeRequest opposite: #mergeCommit>
	<package: #'GLPHExtended-Model'>
	^ self attributeAt: #commitedMergeRequest ifAbsent: [ nil ]
]

{ #category : #'*GLPHExtended-Model-accessing' }
GLHCommit >> commitedMergeRequest: anObject [

	<generated>
	(self attributeAt: #commitedMergeRequest ifAbsentPut: [nil]) == anObject ifTrue: [ ^ anObject ].
	anObject ifNil: [ | otherSide |
		otherSide :=  self commitedMergeRequest.
		self attributeAt: #commitedMergeRequest put: anObject.
		otherSide mergeCommit: nil ]
	ifNotNil: [ 
		self attributeAt: #commitedMergeRequest put: anObject.
		anObject mergeCommit: self ]
]

{ #category : #'*GLPHExtended-Model-accessing' }
GLHCommit >> squashedMergeRequest [
	"Relation named: #squashedMergeRequest type: #GLPHEMergeRequest opposite: #squashCommit"

	<generated>
	<derived>
	<FMProperty: #squashedMergeRequest type: #GLPHEMergeRequest opposite: #squashCommit>
	<package: #'GLPHExtended-Model'>
	^ self attributeAt: #squashedMergeRequest ifAbsent: [ nil ]
]

{ #category : #'*GLPHExtended-Model-accessing' }
GLHCommit >> squashedMergeRequest: anObject [

	<generated>
	(self attributeAt: #squashedMergeRequest ifAbsentPut: [nil]) == anObject ifTrue: [ ^ anObject ].
	anObject ifNil: [ | otherSide |
		otherSide :=  self squashedMergeRequest.
		self attributeAt: #squashedMergeRequest put: anObject.
		otherSide squashCommit: nil ]
	ifNotNil: [ 
		self attributeAt: #squashedMergeRequest put: anObject.
		anObject squashCommit: self ]
]
