Extension { #name : #GLHFile }

{ #category : #'*GitLabHealth-Model-Analysis' }
GLHFile >> degreeOfAuthorship [

	^ GLPDegreeOfAuthorshipAnalyzer new
		  glhFile: self;
		  compute
]

{ #category : #'*GitLabHealth-Model-Analysis' }
GLHFile >> degreeOfAuthorshipAuthors [
	"the most restrictive computation"

	^ GLPDegreeOfAuthorshipAnalyzer new
		  glhFile: self;
		  computeFileAuthors
]
