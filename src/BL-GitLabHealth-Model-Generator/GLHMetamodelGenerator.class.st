Class {
	#name : #GLHMetamodelGenerator,
	#superclass : #FamixMetamodelGenerator,
	#instVars : [
		'project',
		'group',
		'pipeline',
		'user',
		'repository',
		'branch',
		'file',
		'fileBlob',
		'fileDirectory'
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
GLHMetamodelGenerator >> branchProperties [

	branch property: #name type: #String
]

{ #category : #definition }
GLHMetamodelGenerator >> defineClasses [
	super defineClasses.
	group := builder newClassNamed: #Group comment: 'A GitLab Group'.
	project := builder newClassNamed: #Project comment: 'A GitLab Project'.
	pipeline := builder newClassNamed: #Pipeline comment: 'A GitLab Pipeline execution'.
	user := builder newClassNamed: #User comment: 'A GitLab User'.
	repository := builder newClassNamed: #Repository comment: 'A git repository'.
	branch := builder newClassNamed: #Branch comment: 'A git branch'.
	file := builder newClassNamed: #File comment: 'A file'.
	fileBlob := builder newClassNamed: #FileBlob comment: 'A file blob'.
	fileDirectory := builder newClassNamed: #FileDirectory comment: 'A file directory'.
]

{ #category : #definition }
GLHMetamodelGenerator >> defineHierarchy [

	super defineHierarchy.
	(builder ensureClassNamed: #Entity) --|> #TEntityMetaLevelDependency.
	fileDirectory --|> file.
	fileBlob --|> file
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
	self branchProperties.
	self fileProperties.
]

{ #category : #definition }
GLHMetamodelGenerator >> defineRelations [

	super defineRelations.
	(group property: #projects) <>-* (project property: #group).
	(group property: #subGroups) <>-* (group property: #group).
	(project property: #pipelines) <>-* (pipeline property: #project).
	(project property: #creator) *- (user property: #createdProjects).
	(project property: #repository) <>- (repository property: #project).
	(repository property: #branches) <>-* (branch property: #repository).
	(branch property: #files) <>-* (file property: #branch).
	(fileDirectory property: #files) <>-* (file property: #directoryOwner) 
]

{ #category : #definition }
GLHMetamodelGenerator >> fileProperties [

	file property: #name type: #String
]

{ #category : #definition }
GLHMetamodelGenerator >> userProperties [
	user property: #id type: #Number.
	user property: #username type: #String.
	user property: #name type: #String.
	user property: #state type: #String.
	user property: #avatar_url type: #String.
	user property: #web_url type: #String.
	user property: #created_at type: #String.
	user property: #bio type: #String.
	user property: #location type: #String.
	user property: #public_email type: #String.
	user property: #skype type: #String.
	user property: #linkedin type: #String.
	user property: #twitter type: #String.
	user property: #website_url type: #String.
	user property: #organization type: #String.
	user property: #job_title type: #String.
	user property: #pronouns type: #String.
	user property: #bot type: #String.
	user property: #work_information type: #String.
	user property: #followers type: #String.
	user property: #following type: #String
]
