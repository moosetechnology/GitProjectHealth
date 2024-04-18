Extension { #name : #GLPHEChange }

{ #category : #'*GLPHExtended-Model-Extension' }
GLPHEChange class >> createFrom: aDiffLine [
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

{ #category : #'*GLPHExtended-Model-Extension' }
GLPHEChange >> name [

	<FMProperty: #name type: #String>
	<generated>
	<FMComment: 'Basic name of the entity, not full reference.'>
	^ sourceCode 
]

{ #category : #'*GLPHExtended-Model-Extension' }
GLPHEChange class >> newFrom: aDiffLine [
	"Factory a Change from a loc"

	| aChange code|
	aChange := GLPHELineOfCode new.
	
	code := aDiffLine.
	(aDiffLine beginsWith: #'@@') ifTrue: [
		code := (aDiffLine splitOn: '@@') copyWithoutFirst second.
	].
	(aDiffLine trim beginsWith: #+) ifTrue: [ aChange := GLPHEAddition new. ]. 
	(aDiffLine trim beginsWith: #-) ifTrue: [ aChange := GLPHEDeletion new. ]. 
	
	aChange sourceCode: code.
		
	^ aChange
]
