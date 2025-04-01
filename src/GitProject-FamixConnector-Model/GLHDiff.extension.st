Extension { #name : #GLHDiff }

{ #category : #'*GitProject-FamixConnector-Model-accessing' }
GLHDiff >> onSourceEntity [
	"Relation named: #onSourceEntity type: #FamixTSourceEntity opposite: #appliedDiffs"

	<generated>
	<container>
	<FMProperty: #onSourceEntity type: #FamixTSourceEntity opposite: #appliedDiffs>
	<package: #'GitProject-FamixConnector-Model'>
	^ self attributeAt: #onSourceEntity ifAbsent: [ nil ]
]

{ #category : #'*GitProject-FamixConnector-Model-accessing' }
GLHDiff >> onSourceEntity: anObject [

	<generated>
	self attributeAt: #onSourceEntity put: (FMMultivalueLink on: self update: #appliedDiffs from: self onSourceEntity to: anObject).
]
