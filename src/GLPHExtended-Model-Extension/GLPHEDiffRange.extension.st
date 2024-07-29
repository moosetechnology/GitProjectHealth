Extension { #name : 'GLPHEDiffRange' }

{ #category : '*GLPHExtended-Model-Extension' }
GLPHEDiffRange >> name [

	^ '[ OG: ' , originalLineRange , ' | NEW: ' , newLineRange , ']'
]

{ #category : '*GLPHExtended-Model-Extension' }
GLPHEDiffRange class >> newFrom: aLine [

	| range infos rangesInfo |
	range := GLPHEDiffRange new.
	infos := (aLine splitOn: '@@') second.
	rangesInfo := infos trim splitOn: ' '.
	range originalLineRange: rangesInfo first.
	range newLineRange: rangesInfo second.

	^ range
]
