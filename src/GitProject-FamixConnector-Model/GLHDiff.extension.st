Extension { #name : #GLHDiff }

{ #category : #'*GitProject-FamixConnector-Model-accessing' }
GLHDiff >> onSourceEntities [
	"Relation named: #onSourceEntities type: #FamixTSourceEntity opposite: #appliedDiffs"

	<generated>
	<container>
	<FMProperty: #onSourceEntities type: #FamixTSourceEntity opposite: #appliedDiffs>
	<package: #'GitProject-FamixConnector-Model'>
	^ self attributeAt: #onSourceEntities ifAbsent: [ nil ]
]

{ #category : #'*GitProject-FamixConnector-Model-accessing' }
GLHDiff >> onSourceEntities: anObject [

	<generated>
	self attributeAt: #onSourceEntities put: (FMMultivalueLink on: self update: #appliedDiffs from: self onSourceEntities to: anObject).
]
