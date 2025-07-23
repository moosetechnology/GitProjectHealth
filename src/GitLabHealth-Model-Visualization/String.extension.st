Extension { #name : #String }

{ #category : #'*GitLabHealth-Model-Visualization' }
String >> asColor [

	| red green blue hash |
	hash := self hash >> 2.
	red := (hash bitAnd: 16rFF0000) bitShift: -16.
	green := (hash bitAnd: 16r00FF00) bitShift: -8.
	blue := hash bitAnd: 16r0000FF.
	^ (Color r: red g: green b: blue) darker 
]

{ #category : #'*GitLabHealth-Model-Visualization' }
String >> asColorHSL [

	| hue saturation lightness  hash|
	hash := (self, self reversed) hash. 
    hue := hash \\ 360. "Ensure hue is between 0 and 359"
    saturation := 0.7 + ((hash \\ 30) / 100). "Vary saturation between 0.7 and 1.0"
    lightness := 0.5 + ((hash \\ 50) / 100). "Vary lightness between 0.5 and 1.0"
	^ (Color h: hue s: saturation l: lightness) darker 
]
