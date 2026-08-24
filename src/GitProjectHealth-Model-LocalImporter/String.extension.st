Extension { #name : #String }

{ #category : #'*GitProjectHealth-Model-LocalImporter' }
String >> allButFirstLines: aNumberOfLine [

	| stream skipped |
	stream := ReadStream on: self.
	skipped := 0.

	[ stream atEnd or: [ skipped >= aNumberOfLine ] ] whileFalse: [
		stream upTo: Character lf.
		skipped := skipped + 1 ].

	^ stream upToEnd
]
