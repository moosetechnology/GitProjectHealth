Extension { #name : #GLPHEDiffRange }

{ #category : #'*GLPHExtended-Model-Extension' }
GLPHEDiffRange class >> newFrom: aLine [
	|range infos rangesInfo |
	range := GLPHEDiffRange new. 
	infos := (aLine  splitOn: '@@') copyWithoutFirst.
	rangesInfo := infos first trim splitOn: ' '.
	range originalLineRange: rangesInfo first.
	range newLineRange: rangesInfo second . 
	
^ range. 
]
