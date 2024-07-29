Extension { #name : 'GLPHELineOfCode' }

{ #category : '*GLPHExtended-Model-Extension' }
GLPHELineOfCode class >> newFrom: aDiffLine [

	| aLoC infos ranges |
	infos := (aDiffLine splitOn: '@@') copyWithoutFirst.
	aLoC := GLPHELineOfCode new.
	aLoC sourceCode: infos second.
	^ aLoC.
]

{ #category : '*GLPHExtended-Model-Extension' }
GLPHELineOfCode class >> newFromLoCRange: aDiffLine [ 
	|aLoC infos ranges|
	infos := (aDiffLine splitOn: '@@') copyWithoutFirst.
	ranges := infos first splitOn: ','.
	aLoC := GLPHELineOfCode new.
	aLoC originalLineRange: ranges first. 
	aLoC newLineRange: 1.
	aLoC lineOfCode: infos second.
]
