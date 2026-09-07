"
Given a `GLHFile` I provide the normalized DOA values with their user.
I also provide an utility that filters the one considered as real author based on k = 0.75

(value comes from the [A Novel Approach for Estimating Truck Factors](https://arxiv.org/pdf/1604.06766) research paper)
"
Class {
	#name : #GLPDegreeOfAuthorshipAnalyzer,
	#superclass : #Object,
	#instVars : [
		'glhFile',
		'rawResults',
		'normalizedResults'
	],
	#category : #'GitLabHealth-Model-Analysis-TruckFactor'
}

{ #category : #accessing }
GLPDegreeOfAuthorshipAnalyzer >> authorshipThreshold [

	^ 0.75
]

{ #category : #accessing }
GLPDegreeOfAuthorshipAnalyzer >> baseKnowledge [

	^ 3.293
]

{ #category : #accessing }
GLPDegreeOfAuthorshipAnalyzer >> compute [

	| authors  |
	authors := self glhFile diffs
		           collect: [ :diff | diff commit commitCreator ]
		           as: Set.
	rawResults := (self glhFile mooseModel allWithType: GLHUser)
		           collect: [ :author |
			           author -> (GLPUserDegreeOfAuthorshipAnalyzer new
				            glhFile: self glhFile;
				            glhUser: author;
				            compute) ]
		           as: Dictionary.
	normalizedResults := AIMinMaxNormalizer new normalize: rawResults.
	^ normalizedResults
]

{ #category : #accessing }
GLPDegreeOfAuthorshipAnalyzer >> computeFileAuthors [
	"we consider a developer as an author of a file if its resulting normalized DOA is greater than a threshold k and its absolute DOA is not lower than a value m."

	^ self compute associationsSelect: [ :assoc |
		  assoc value >= self authorshipThreshold and: [
			  (rawResults at: assoc key) >= self baseKnowledge ] ]
]

{ #category : #accessing }
GLPDegreeOfAuthorshipAnalyzer >> glhFile [

	^ glhFile
]

{ #category : #accessing }
GLPDegreeOfAuthorshipAnalyzer >> glhFile: anObject [

	glhFile := anObject
]
