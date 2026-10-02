"
I compute the truckfactor based on the files under directories
"
Class {
	#name : #GLPTruckFactor,
	#superclass : #Object,
	#instVars : [
		'directories',
		'tfInfo'
	],
	#category : #'GitLabHealth-Model-Analysis-TruckFactor'
}

{ #category : #'as yet unclassified' }
GLPTruckFactor >> blobFiles [

	^ self directories flatCollect: [ :directory |
		  directory allToScope: GLHFileBlob ]
]

{ #category : #'as yet unclassified' }
GLPTruckFactor >> computeCoverageOf: repositoryFilesSize from: authorsMap [ 
	| authorsSet |
	authorsSet := Set new.

	authorsMap valuesDo: [:files |
		files do: [:file |
			authorsSet add: file.
			authorsSet size = repositoryFilesSize ifTrue: [ ^ 1.0 ] ] ].

	^ authorsSet size asFloat / repositoryFilesSize
]

{ #category : #accessing }
GLPTruckFactor >> directories [

	^ directories
]

{ #category : #accessing }
GLPTruckFactor >> directories: anObject [

	directories := anObject
]

{ #category : #accessing }
GLPTruckFactor >> filesAuthorMap [

	| users authorsDictionary |
	authorsDictionary := Dictionary new.
	users := directories anyOne mooseModel allWithType: GLHUser.
	self blobFiles
		select: [ :fileBlob | fileBlob diffs isNotEmpty ]
		thenCollect: [ :fileBlob |
			fileBlob degreeOfAuthorshipAuthors associationsDo: [ :assoc |
				(authorsDictionary at: assoc key ifAbsentPut: [ Set new ]) add:
					fileBlob ] ].
	^ authorsDictionary
]

{ #category : #initialization }
GLPTruckFactor >> initialize [

	super initialize.
	tfInfo := GLPTruckFactorInfo new
]

{ #category : #removing }
GLPTruckFactor >> removeTopAuthorOf: repFilesSize from: authorsMap [

	| biggerNumber biggerDev |
	biggerNumber := 0.
	biggerDev := nil.

	authorsMap associationsDo: [ :assoc |
		assoc value size > biggerNumber ifTrue: [
			biggerNumber := assoc value size.
			biggerDev := assoc key ].

		(biggerDev notNil and: [
			 assoc value size = biggerNumber and: [
				 (assoc key commits flatCollect: #diffs) size
				 > (biggerDev commits flatCollect: #diffs) size ] ]) ifTrue: [
			biggerDev := assoc key ] ].

	tfInfo developers add: biggerDev.
	authorsMap removeKey: biggerDev
]

{ #category : #accessing }
GLPTruckFactor >> truckFactor [

	| authorsMap numberOfFiles factor coverage |
	authorsMap := self filesAuthorMap.
	numberOfFiles := self blobFiles size.
	factor := 0.
	coverage := 1.0.
	[
	authorsMap isNotEmpty and: [
		0.5 < (self computeCoverageOf: numberOfFiles from: authorsMap) ] ]
		whileTrue: [
			self removeTopAuthorOf: numberOfFiles from: authorsMap.
			factor := factor + 1 ].
	tfInfo coverage:
		(self computeCoverageOf: numberOfFiles from: authorsMap).
	tfInfo truckFactor: factor.
	tfInfo totalFiles: numberOfFiles.
	^ tfInfo
]
