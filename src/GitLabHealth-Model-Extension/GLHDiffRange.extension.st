Extension { #name : #GLHDiffRange }

{ #category : #'*GitLabHealth-Model-Extension' }
GLHDiffRange >> end [
 ^	(self newLineRange copyFrom: (self newLineRange indexOf:$,)+1 to: self newLineRange size) asNumber 
]

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

{ #category : #'*GitLabHealth-Model-Extension' }
GLHDiffRange >> start [
	^ (self newLineRange copyFrom: 2 to: (self newLineRange indexOf:$,)-1) asNumber 
]
