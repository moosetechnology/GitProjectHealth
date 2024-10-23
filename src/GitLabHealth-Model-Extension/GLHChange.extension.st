Extension { #name : 'GLHChange' }

{ #category : '*GitLabHealth-Model-Extension' }
GLHChange class >> createFrom: aDiffLine [
	"Factory a Change from a loc"

	| aChange |
	aChange := nil.
	(aDiffLine beginsWith: #'@@') ifTrue: [
		| infos |
		aChange := GLPHELineOfCode newFromLoCRange: aDiffLine.

		infos := (aDiffLine splitOn: '@@') copyWithoutFirst.
		infos := aDiffLine splitOn: ' ' ].
	^ aChange
]

{ #category : '*GitLabHealth-Model-Extension' }
GLHChange >> name [

	^ sourceCode 
]

{ #category : '*GitLabHealth-Model-Extension' }
GLHChange class >> newFrom: aDiffLine [
	"Factory a Change from a loc"

	| aChange trimedLine code |
	trimedLine := aDiffLine trim.

	aChange := (trimedLine beginsWith: #+)
		           ifTrue: [ GLPHEAddition new ]
		           ifFalse: [
			           (aDiffLine trim beginsWith: #-)
				           ifTrue: [ GLPHEDeletion new ]
				           ifFalse: [ GLPHELineOfCode new ] ].

	code := aDiffLine.
	(trimedLine beginsWith: #'@@') ifTrue: [
		code := (trimedLine splitOn: '@@') copyWithoutFirst second ].
	aChange sourceCode: code.

	^ aChange
]
