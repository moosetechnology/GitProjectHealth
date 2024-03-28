"
This is a generator to generate a metamodel that aims to link any git repository with file based project in Famix
"
Class {
	#name : #GPCMetamodelGenerator,
	#superclass : #FamixMetamodelGenerator,
	#instVars : [
		'glhDiff',
		'tSourceEntity'
	],
	#category : #'GitProject-FamixConnector-Generator'
}

{ #category : #accessing }
GPCMetamodelGenerator class >> packageName [

	^ #'GitProject-FamixConnector-Model'
]

{ #category : #accessing }
GPCMetamodelGenerator class >> prefix [

	^ #GPC
]

{ #category : #accessing }
GPCMetamodelGenerator class >> submetamodels [

	^ {
		  GLHMetamodelGenerator.
		  FamixGenerator }
]

{ #category : #'as yet unclassified' }
GPCMetamodelGenerator >> defineClasses [

	super defineClasses.
	glhDiff := self remoteEntity: 'Diff' withPrefix: #GLH.
	tSourceEntity := self remoteTrait: #TSourceEntity withPrefix: #Famix
]

{ #category : #'as yet unclassified' }
GPCMetamodelGenerator >> defineRelations [

	super defineRelations.
	(glhDiff property: #onSourceEntity)
	*-<> (tSourceEntity property: #appliedDiffs)
]
