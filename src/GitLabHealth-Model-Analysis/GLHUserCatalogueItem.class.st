Class {
	#name : 'GLHUserCatalogueItem',
	#superclass : 'Dictionary',
	#instVars : [
		'user',
		'names'
	],
	#category : 'GitLabHealth-Model-Analysis',
	#package : 'GitLabHealth-Model-Analysis'
}

{ #category : 'initialization' }
GLHUserCatalogueItem >> initialize [

	names := Set new. 
]
