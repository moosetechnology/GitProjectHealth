Extension { #name : #FamixTSourceEntity }

{ #category : #'*GitProject-FamixConnector-Model-accessing' }
FamixTSourceEntity >> appliedDiffs [
	"Relation named: #appliedDiffs type: #GLHDiff opposite: #onSourceEntities"

	<generated>
	<derived>
	<FMProperty: #appliedDiffs type: #GLHDiff opposite: #onSourceEntities>
	<package: #'GitProject-FamixConnector-Model'>
	^ self attributeAt: #appliedDiffs ifAbsentPut: [ FMMultivalueLink on: self opposite: #onSourceEntities: ]
]

{ #category : #'*GitProject-FamixConnector-Model-accessing' }
FamixTSourceEntity >> appliedDiffs: anObject [

	<generated>
	self appliedDiffs value: anObject
]
