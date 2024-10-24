Extension { #name : 'GLHLineOfCode' }

{ #category : '*GitLabHealth-Model-Extension' }
GLHLineOfCode class >> newFrom: aDiffLine [

	| aLoC infos |
	infos := (aDiffLine splitOn: '@@') copyWithoutFirst.
	aLoC := GLHLineOfCode new.
	aLoC sourceCode: infos second.
	^ aLoC
]

{ #category : '*GitLabHealth-Model-Extension' }
GLHLineOfCode class >> newFromLoCRange: aDiffLine [

	| aLoC infos ranges |
	infos := (aDiffLine splitOn: '@@') copyWithoutFirst.
	ranges := infos first splitOn: ','.
	aLoC := GLHLineOfCode new.
	aLoC originalLineRange: ranges first.
	aLoC newLineRange: 1.
	aLoC lineOfCode: infos second
]
