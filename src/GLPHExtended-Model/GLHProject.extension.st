Extension { #name : #GLHProject }

{ #category : #'*GLPHExtended-Model-accessing' }
GLHProject >> mergeRequests [
	"Relation named: #mergeRequests type: #GLPHEMergeRequest opposite: #project"

	<generated>
	<derived>
	<FMProperty: #mergeRequests type: #GLPHEMergeRequest opposite: #project>
	<package: #'GLPHExtended-Model'>
	^ self attributeAt: #mergeRequests ifAbsentPut: [ FMMultivalueLink on: self opposite: #project: ]
]

{ #category : #'*GLPHExtended-Model-accessing' }
GLHProject >> mergeRequests: anObject [

	<generated>
	self mergeRequests value: anObject
]
