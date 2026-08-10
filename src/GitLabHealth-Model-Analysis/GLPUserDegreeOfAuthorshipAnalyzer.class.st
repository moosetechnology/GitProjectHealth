"
I am used by `GLPDegreeOfAuthorshipAnalyzer`

Based on the paper [A Novel Approach for Estimating Truck Factors](https://arxiv.org/pdf/1604.06766), I compute the DOA between a file and a author based on prexisting computed data by GitProjectHealth.

Here is the algorithm: 

```language=txt
DOA(md, fp) = 3.293 + 1.098 ×FA(md, fp) + 0.164× DL(md, fp)−0.321 ×ln(1 + AC (md, fp))

From the equation, DOA depends on three factors: (i) first authorship (FA): if md originally created f, FA is 1; otherwise it is 0; (ii) number of deliveries (DL): number of changes in f made by md; and (iii) number of acceptances (AC): number of changes in f made by any developer, except md.
```

Magic numbers were computed by the authors.

The paper [Algorithms for Estimating Truck Factors: A Comparative study](https://homepages.dcc.ufmg.br/~mtov/pub/2019-sqj.pdf) consider AVL algorithm (on which is based DOA) correct. So DOA seems good

## Usage

```st

GLPDegreeOfAuthorshipAnalyzer new
	glhFile: glhFile;
	glhUser: glhUser;
	compute
```
"
Class {
	#name : #GLPUserDegreeOfAuthorshipAnalyzer,
	#superclass : #Object,
	#instVars : [
		'glhFile',
		'glhUser',
		'baseKnowledge'
	],
	#category : #'GitLabHealth-Model-Analysis-TruckFactor'
}

{ #category : #accessing }
GLPUserDegreeOfAuthorshipAnalyzer >> authorCreatedFile [
	"Paper: Should be 1 if yes. 0 if not"

	"Us: we consider that files might be old, and so in this case 0"
	^ 0
]

{ #category : #accessing }
GLPUserDegreeOfAuthorshipAnalyzer >> compute [

	^ baseKnowledge + (1.098 * self authorCreatedFile)
	  + (0.164 * self numberOfChageMadeByOriginalAuthorDL)
	  - (0.321 * (1 + self numberOfChangeMadeByOtherAuthors) ln)
]

{ #category : #accessing }
GLPUserDegreeOfAuthorshipAnalyzer >> glhFile [

	^ glhFile
]

{ #category : #accessing }
GLPUserDegreeOfAuthorshipAnalyzer >> glhFile: anObject [

	glhFile := anObject
]

{ #category : #accessing }
GLPUserDegreeOfAuthorshipAnalyzer >> glhUser [

	^ glhUser
]

{ #category : #accessing }
GLPUserDegreeOfAuthorshipAnalyzer >> glhUser: anObject [

	glhUser := anObject
]

{ #category : #initialization }
GLPUserDegreeOfAuthorshipAnalyzer >> initialize [
	super initialize.
	baseKnowledge := 3.293
]

{ #category : #accessing }
GLPUserDegreeOfAuthorshipAnalyzer >> numberOfChageMadeByOriginalAuthorDL [

	^ self glhFile diffs count: [ :diff |
		  diff commit commitCreator = self glhUser ]
]

{ #category : #accessing }
GLPUserDegreeOfAuthorshipAnalyzer >> numberOfChangeMadeByOtherAuthors [

	^ self glhFile diffs count: [ :diff |
		  diff commit commitCreator ~= self glhUser ]
]
