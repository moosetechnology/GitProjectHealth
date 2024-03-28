Extension { #name : #FamixTSourceEntity }

{ #category : #'*GitProject-FamixConnector-Model-accessing' }
FamixTSourceEntity >> appliedDiffs [
	"Relation named: #appliedDiffs type: #GLHDiff opposite: #onSourceEntity"

	<generated>
	<derived>
	<FMProperty: #appliedDiffs type: #GLHDiff opposite: #onSourceEntity>
	<package: #'GitProject-FamixConnector-Model'>
	^ self attributeAt: #appliedDiffs ifAbsentPut: [ FMMultivalueLink on: self opposite: #onSourceEntity: ]
]

{ #category : #'*GitProject-FamixConnector-Model-accessing' }
FamixTSourceEntity >> appliedDiffs: anObject [

	<generated>
	self appliedDiffs value: anObject
]
