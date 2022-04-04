Class {
	#name : #GLHMetamodelGenerator,
	#superclass : #FamixMetamodelGenerator,
	#instVars : [
		'project',
		'group',
		'pipeline',
		'user'
	],
	#category : #'BL-GitLabHealth-Model-Generator'
}

{ #category : #accessing }
GLHMetamodelGenerator class >> packageName [
	^ #'BL-GitLabHealth-Model'
]

{ #category : #accessing }
GLHMetamodelGenerator class >> prefix [
	^ #GLH
]

{ #category : #accessing }
GLHMetamodelGenerator class >> submetamodels [

	^ { FamixMooseQueryGenerator }
]

{ #category : #definition }
GLHMetamodelGenerator >> defineClasses [
	super defineClasses.
	group := builder newClassNamed: #Group comment: 'A GitLab Group'.
	project := builder newClassNamed: #Project comment: 'A GitLab Project'.
	pipeline := builder newClassNamed: #Pipeline comment: 'A GitLab Pipeline execution'.
	user := builder newClassNamed: #User comment: 'A GitLab User'
]

{ #category : #definition }
GLHMetamodelGenerator >> defineHierarchy [

	super defineHierarchy.
	(builder ensureClassNamed: #Entity) --|> #TEntityMetaLevelDependency
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
	project property: #topics type: #Object.
	project property: #archived type: #Boolean.
	project property: #archived type: #Boolean.
	project property: #description type: #String.
	project property: #name type: #String.
	project property: #readme_url type: #String.
	project property: #avatar_url type: #String.
	project property: #web_url type: #String.
	project property: #creator_id type: #Number.
	
	"Pipelines properties"
	pipeline property: #status type: #String.
	self userProperties.
]

{ #category : #definition }
GLHMetamodelGenerator >> defineRelations [

	super defineRelations.
	(group property: #projects) <>-* (project property: #group).
	(group property: #subGroups) <>-* (group property: #group).
	(project property: #pipelines) <>-* (pipeline property: #project).
	(project property: #creator) *- (user property: #createdProjects)
]

{ #category : #definition }
GLHMetamodelGenerator >> userProperties [
	user property: #id type: #Number.
	user property: #username type: #String.
	user property: #name type: #String.
]
