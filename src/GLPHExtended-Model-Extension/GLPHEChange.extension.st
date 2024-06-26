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
GLPHEChange >> isAddition [

	^ false
]

{ #category : #'*GLPHExtended-Model-Extension' }
GLPHEChange >> isDeletion [

	^ false
]

{ #category : #'*GLPHExtended-Model-Extension' }
GLPHEChange >> name [

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
