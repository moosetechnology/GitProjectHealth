Extension { #name : #GLHDiffRange }

{ #category : #'*GitLabHealth-Model-Extension' }
GLHDiffRange >> name [

	^ '[ OG: ' , originalLineRange , ' | NEW: ' , newLineRange , ']'
]

{ #category : #'*GitLabHealth-Model-Extension' }
GLHDiffRange class >> newFrom: aLine [

	| range infos rangesInfo |
	range := GLHDiffRange new.
	infos := (aLine splitOn: '@@') second.
	rangesInfo := infos trim splitOn: ' '.
	range originalLineRange: rangesInfo first.
	range newLineRange: rangesInfo second.

	^ range
]
