Class {
	#name : #GLHModelImporter,
	#superclass : #Object,
	#instVars : [
		'glhModel',
		'baseAPIUrl',
		'privateToken'
	],
	#category : #'BL.GitLabHealth-Model-Importer'
}

{ #category : #accessing }
GLHModelImporter >> baseAPIUrl [

	^ baseAPIUrl
]

{ #category : #accessing }
GLHModelImporter >> baseAPIUrl: anObject [

	baseAPIUrl := anObject
]

{ #category : #accessing }
GLHModelImporter >> glhModel [

	^ glhModel
]

{ #category : #accessing }
GLHModelImporter >> glhModel: anObject [

	glhModel := anObject
]

{ #category : #accessing }
GLHModelImporter >> privateToken [

	^ privateToken
]

{ #category : #accessing }
GLHModelImporter >> privateToken: anObject [

	privateToken := anObject
]
