Extension { #name : #GLHFile }

{ #category : #'*GLPHExtended-Model-accessing' }
GLHFile >> diffs [
	"Relation named: #diffs type: #GLHDiff opposite: #file"

	<generated>
	<container>
	<FMProperty: #diffs type: #GLHDiff opposite: #file>
	<package: #'GLPHExtended-Model'>
	^ self attributeAt: #diffs ifAbsent: [ nil ]
]

{ #category : #'*GLPHExtended-Model-accessing' }
GLHFile >> diffs: anObject [

	<generated>
	self attributeAt: #diffs put: (FMMultivalueLink on: self update: #file from: self diffs to: anObject).
]
