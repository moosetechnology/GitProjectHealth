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
		'fileDirectory',
		'commit',
		'commitStats',
		'diff'
	],
	#category : #'GitLabHealth-Model-Generator'
}

{ #category : #accessing }
GLHMetamodelGenerator class >> packageName [
	^ #'GitLabHealth-Model'
]

{ #category : #accessing }
GLHMetamodelGenerator class >> prefix [
	^ #GLH
]

{ #category : #accessing }
GLHMetamodelGenerator class >> submetamodels [

	^ { FamixMooseQueryGenerator . FamixGenerator }
]

{ #category : #definition }
GLHMetamodelGenerator >> branchProperties [

	branch property: #name type: #String
]

{ #category : #definition }
GLHMetamodelGenerator >> commitProperties [

	commit property: #parent_ids type: #Object defaultValue: 'OrderedCollection new'.

	commit property: #id type: #String.
	commit property: #short_id type: #String.
	commit property: #title type: #String.
	commit property: #author_name type: #String.
	commit property: #author_email type: #String.
	commit property: #authored_date type: #Object.
	commit property: #committer_name type: #String.
	commit property: #committer_email type: #String.
	commit property: #committed_date type: #Object.
	commit property: #created_at type: #Object.
	commit property: #message type: #String.
	commit property: #web_url type: #String.


	(commit property: #additions type: #Number) comment:
		'The number of line that git consider added'.
	(commit property: #deletions type: #Number) comment:
		'The number of line that git consider deleted'
]

{ #category : #definition }
GLHMetamodelGenerator >> defineClasses [

	super defineClasses.
	group := builder newClassNamed: #Group comment: 'A GitLab Group'.
	project := builder
		           newClassNamed: #Project
		           comment: 'A GitLab Project'.
	pipeline := builder
		            newClassNamed: #Pipeline
		            comment: 'A GitLab Pipeline execution'.
	user := builder newClassNamed: #User comment: 'A GitLab User'.
	repository := builder
		              newClassNamed: #Repository
		              comment: 'A git repository'.
	branch := builder newClassNamed: #Branch comment: 'A git branch'.
	file := builder newClassNamed: #File comment: 'A file'.
	fileBlob := builder newClassNamed: #FileBlob comment: 'A file blob'.
	fileDirectory := builder
		                 newClassNamed: #FileDirectory
		                 comment: 'A file directory'.
	commit := builder
		          newClassNamed: #Commit
		          comment: 'a commit attached to a repository'.
	diff := builder newClassNamed: #Diff comment: 'The diff of a commit'
]

{ #category : #definition }
GLHMetamodelGenerator >> defineHierarchy [

	super defineHierarchy.
	(builder ensureClassNamed: #Entity) --|> #TEntityMetaLevelDependency.
	fileDirectory --|> file.
	fileBlob --|> file.

	group --|> #TNamedEntity.
	project --|> #TNamedEntity.
	user --|> #TNamedEntity.
	commit --|> #TNamedEntity.
	diff --|> #TNamedEntity
]

{ #category : #definition }
GLHMetamodelGenerator >> defineProperties [

	super defineProperties.
	"Group properties"
	group property: #id type: #Number.
	group property: #web_url type: #String.
	group property: #description type: #String.
	group property: #visibility type: #String.
	group property: #avatar_url type: #String.

	"Project properties"
	project property: #id type: #Number.
	project property: #topics type: #Object.
	project property: #archived type: #Boolean.
	project property: #archived type: #Boolean.
	project property: #description type: #String.
	project property: #readme_url type: #String.
	project property: #avatar_url type: #String.
	project property: #web_url type: #String.
	project property: #creator_id type: #Number.

	"Pipelines properties"
	(pipeline property: #status type: #String) comment:
		'#success or #failure'.
	(pipeline property: #runDate type: #Object) comment:
		'Date this pipeline was run'.

	self userProperties.
	self branchProperties.
	self fileProperties.
	self commitProperties.
	self diffProperties
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
	(fileDirectory property: #files)
	<>-* (file property: #directoryOwner).
	(repository property: #commits) <>-* (commit property: #repository).
	(branch property: #commits) <>-* (commit property: #branch).
	
	(commit property: #diffs) <>-* (diff property: #commit).
	(user property: #commits) <>-* (commit property: #commitCreator).
	(commit property: #parentCommits) *-* (commit property: #childCommits)
]

{ #category : #definition }
GLHMetamodelGenerator >> diffProperties [

	(diff property: #diffString type: #String) comment:
		'The string presenting the diff. It should follow the [Detailed-Unified](https://www.gnu.org/software/diffutils/manual/html_node/Detailed-Unified.html) format'.
		
	(diff property: #new_path type: #String) comment:
		'The path to the file in the resulted repository commitish'.
		
	(diff property: #old_path type: #String) comment:
		'The path to the file in the origin repository commitish'.
		
	(diff property: #new_file type: #Boolean defaultValue: false)
		comment: 'Is the file of the diff is a new file'.
		
	(diff property: #renamed_file type: #Boolean defaultValue: false)
		comment:
		'Is the file of the diff has been renamed (see old_path/new_path) file'.
		
	(diff property: #deleted_file type: #Boolean defaultValue: false)
		comment: 'Is the file of the diff has been removed'
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
