Class {
	#name : #GLPTruckFactorInfo,
	#superclass : #Object,
	#instVars : [
		'truckFactor',
		'totalFiles',
		'coverage',
		'developers',
		'fileAuthorship'
	],
	#category : #'GitLabHealth-Model-Analysis-TruckFactor'
}

{ #category : #accessing }
GLPTruckFactorInfo >> coverage [

	^ coverage
]

{ #category : #accessing }
GLPTruckFactorInfo >> coverage: anObject [

	coverage := anObject
]

{ #category : #accessing }
GLPTruckFactorInfo >> developers [

	^ developers
]

{ #category : #accessing }
GLPTruckFactorInfo >> developers: anObject [

	developers := anObject
]

{ #category : #accessing }
GLPTruckFactorInfo >> fileAuthorship [

	^ fileAuthorship
]

{ #category : #accessing }
GLPTruckFactorInfo >> fileAuthorship: anObject [

	fileAuthorship := anObject
]

{ #category : #initialization }
GLPTruckFactorInfo >> initialize [

	super initialize.
	developers := OrderedCollection new
]

{ #category : #printing }
GLPTruckFactorInfo >> printOn: stream [

	stream
		nextPutAll: '*TF*';
		nextPut: $;;
		print: truckFactor;
		nextPut: $;;
		print: totalFiles;
		cr.

	coverage isNaN ifTrue: [ coverage := 0 ].

	stream
		nextPutAll: '*Coverage*';
		nextPut: $;;
		print: (coverage * 100 roundTo: 0.01);
		nextPut: $;;
		print: (totalFiles * coverage) rounded;
		cr.

	developers do: [ :developer |
		stream
			nextPutAll: developer name;
			nextPut: $;;
			print:
				((self fileAuthorship at: developer) size asFloat / totalFiles * 100
					 roundTo: 0.01);
			nextPut: $;;
			print: (self fileAuthorship at: developer) size;
			cr
		"nextPutAll: repository;
		nextPut: $;;" ].

	stream
]

{ #category : #accessing }
GLPTruckFactorInfo >> totalFiles [

	^ totalFiles
]

{ #category : #accessing }
GLPTruckFactorInfo >> totalFiles: anObject [

	totalFiles := anObject
]

{ #category : #accessing }
GLPTruckFactorInfo >> truckFactor [

	^ truckFactor
]

{ #category : #accessing }
GLPTruckFactorInfo >> truckFactor: anObject [

	truckFactor := anObject
]
