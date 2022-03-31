Class {
	#name : #GLHMetamodelGenerator,
	#superclass : #FamixMetamodelGenerator,
	#instVars : [
		'project',
		'group'
	],
	#category : #'BL.GitLabHealth-Model-Generator'
}

{ #category : #accessing }
GLHMetamodelGenerator class >> packageName [
	^ #'BL.GitLabHealth-Model'
]

{ #category : #accessing }
GLHMetamodelGenerator class >> prefix [
	^ #GLH
]

{ #category : #definition }
GLHMetamodelGenerator >> defineClasses [
	super defineClasses.
	group := builder newClassNamed: #Group comment: 'A GitLab Group'.
	project := builder newClassNamed: #Project comment: 'A GitLab Project'.
]

{ #category : #definition }
GLHMetamodelGenerator >> defineProperties [

	super defineProperties.
	"Group properties"
	group property: #id type: #Number.
	group property: #web_url type: #String.
	group property: #name type: #String.
	group property: #description type: #String.
	group property: #visibility type: #String.
	group property: #avatar_url type: #String.

	"Project properties"
	project property: #id type: #Number.
	project property: #description type: #String.
	project property: #name type: #String.
	project property: #readme_url type: #String.
	project property: #avatar_url type: #String.
	project property: #web_url type: #String
]

{ #category : #definition }
GLHMetamodelGenerator >> defineRelations [

	super defineRelations.
	(group property: #projects) <>-* (project property: #group).
	(group property: #subGroups) <>-* (group property: #group)
]
