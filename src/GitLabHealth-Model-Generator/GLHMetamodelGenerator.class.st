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
		'diff',
		'job',
		'mergeRequest',
		'diffRange',
		'change',
		'addition',
		'deletion',
		'lineOfCode',
		'note',
		'notePosition',
		'noteSuggestion',
		'entity',
		'release',
		'tag',
		'issue',
		'milestone',
		'tRef'
	],
	#category : #'GitLabHealth-Model-Generator'
}

{ #category : #initialization }
GLHMetamodelGenerator class >> forceRecreateModel [ 
	<example>

	(UIManager default 
	alert: 'You are about to execute a "generateWithCleaning" process on our model. 
	This method will delete and recreate all the model. It will also delete all entities extensions. 
	Please ensure you have committed our code first so you will be able to reverte the deleted extensios.' title: 'RESET Model'; 
	confirm: 'Are you REALLY sure you want to reset all model''s relations and extensions ?' )
	 ifTrue: [ 
 			Smalltalk image garbageCollect.
			Smalltalk image garbageCollectMost.
        Transcript show: 'Block executed for GLHMetamodelGenerator new generateWithCleaning'; cr.
			GLHMetamodelGenerator new generateWithCleaning.
			"GLHMetamodelGenerator generate"
    ]
    ifFalse: [
        Transcript show: 'Reset operation cancelled'; cr.
    ].



]

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

{ #category : #branches }
GLHMetamodelGenerator >> branchProperties [

	
]

{ #category : #changes }
GLHMetamodelGenerator >> changeProperties [

	change property: #index type: #Number.
	change property: #relativeIndex type: #Number.
	change property: #sourceCode type: #String. 
	addition property: #delimiter type: #String defaultValue: '#+'.
	deletion property: #delimiter type: #String defaultValue: '#-'
]

{ #category : #commits }
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
	entity := builder ensureClassNamed: #Entity.
	group := builder newClassNamed: #Group comment: 'A GitLab Group'.
	group withGroup.
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
	diff := builder newClassNamed: #Diff comment: 'The diff of a commit'.

	job := builder newClassNamed: #Job comment: 'A CI Job'.

	mergeRequest := builder
		                newClassNamed: #MergeRequest
		                comment: 'a gitlab merge request'.

	change := builder
		          newClassNamed: #Change
		          comment: 'super class for addition and deletion '.

	addition := builder
		            newClassNamed: #Addition
		            comment:
		            'a detected addition of a line, seen within a diff '.
	addition withTesting.
	deletion := builder
		            newClassNamed: #Deletion
		            comment:
		            'a detected deletion of a line, seen within a diff '.
	deletion withTesting.

	lineOfCode := builder
		              newClassNamed: #LineOfCode
		              comment: 'a line of code in a diff comparaison '.

	diffRange := builder
		             newClassNamed: #DiffRange
		             comment:
		             'a indicate on which line of code are concerned by a diff (usually declared with @@ oldRange, newRange @@) '.

	note := builder
		        newClassNamed: #Note
		        comment:
		        'a note (a diff) proposed in a Merge Request; can be accepted, modified or deleted'.

	notePosition := builder
		                newClassNamed: #NotePosition
		                comment: 'indicate the position of a note'.

	noteSuggestion := builder
		                  newClassNamed: #NoteSuggestion
		                  comment: 'suggestion of code made in a note'.

	tag := builder
		       newClassNamed: #Tag
		       comment:
		       'a Tag is a reference to a specific point in the repository''s history'.


	release := builder
		           newClassNamed: #Release
		           comment:
		           'a Release is typically associated with a tag and provide additional metadata and assets that can be distributed to users'.

	issue := builder
		         newClassNamed: #Issue
		         comment:
		         'an Issues help collaboration within a team to plan, track, and deliver work'.

	milestone := builder
		             newClassNamed: #Milestone
		             comment:
		             'a Milestone is use to track progress on groups of issues or pull requests in a repository'
]

{ #category : #definition }
GLHMetamodelGenerator >> defineHierarchy [

	super defineHierarchy.
	entity --|> #TEntityMetaLevelDependency.
	fileDirectory --|> file.
	fileBlob --|> file.

	group --|> #TNamedEntity.
	project --|> #TNamedEntity.
	user --|> #TNamedEntity.
	commit --|> #TNamedEntity.
	diff --|> #TNamedEntity.
	job --|> #TNamedEntity.
	note --|> #TNamedEntity.
	notePosition --|> #TNamedEntity.
	noteSuggestion --|> #TNamedEntity.

	tRef --|> #TNamedEntity.
	tRef <|-- commit.
	tRef <|-- branch.
	tRef <|-- tag.

	change --|> #TNamedEntity.
	change <|-- addition.
	change <|-- deletion.
	change <|-- lineOfCode.
	mergeRequest --|> #TNamedEntity.

	issue --|> #TNamedEntity.
	milestone --|> #TNamedEntity
]

{ #category : #definition }
GLHMetamodelGenerator >> defineProperties [
	"Group properties"

	super defineProperties.
	self groupProperties.
	self projectProperties.
	self pipelinesProperties.
	self userProperties.
	self branchProperties.
	self fileProperties.
	self commitProperties.
	self diffProperties.
	self jobProperties.
	self changeProperties.
	self mergeRequestProperties.
	self diffRangeProperties.
	self noteProperties.
	self notePositionProperties.
	self noteSuggestionProperties.
	self tagProperties.
	self releaseProperties.
	self issueProperties.
	self milestoneProperties.

	self tRefProperties
]

{ #category : #definition }
GLHMetamodelGenerator >> defineRelations [
	"MERGE REQUEST RELATIONS""DIFF""TAG AND RELEASE"

	super defineRelations.
	(group property: #projects) <>-* (project property: #group).
	(group property: #subGroups) <>-* (group property: #group).

	(repository property: #branches) <>-* (branch property: #repository).
	(branch property: #files) <>-* (file property: #branch).
	(fileDirectory property: #files)
	<>-* (file property: #directoryOwner).
	(repository property: #commits) <>-* (commit property: #repository).
	"commit can appears in multiple branches. And a branch"
	(branch property: #commits) *-* (commit property: #branch).
	(commit property: #diffs) <>-* (diff property: #commit).
	(user property: #commits) <>-* (commit property: #commitCreator).
	(commit property: #parentCommits)
	*-* (commit property: #childCommits).
	(commit property: #jobs) <>-* (job property: #commit).
	(pipeline property: #jobs) <>-* (job property: #pipeline).
	(pipeline property: #user) *- (user property: #launchedPipelines).
	(user property: #jobs) <>-* (job property: #user).
	(diff property: #file) <>-* (file property: #diffs).
	(diff property: #diffRanges) <>-* (diffRange property: #diff).
	(diffRange property: #changes) -* (change property: #diffRange).

	self projectRelations.
	self tagRelations.
	self releaseRelations.
	self issueRelations.
	self mergeRequestsRelations.
	self noteRelations.
	self notePositionRelations.
	self noteSuggestionRelations.
	self milestoneRelations.
	self notePositionRelations
]

{ #category : #definition }
GLHMetamodelGenerator >> defineTraits [
	super defineTraits.
	
	tRef := builder newTraitNamed: #TRef comment: 'I''m representing a Git reference, that is a reference point in a repository''s history'.
	"generate the identity isXXX method (see https://modularmoose.org/developers/create-new-metamodel/#generating-test-method)"
	tRef withTesting.
]

{ #category : #diffs }
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

{ #category : #diffs }
GLHMetamodelGenerator >> diffRangeProperties [
"must parse the range. 
	originalLineRange = '-120,5' --> change starts at line #120
	5 is the number of lines in the original file affected by the change"
	diffRange property: #originalLineRange type: #String.
	diffRange property: #newLineRange type: #String.
	diffRange property: #lineOfCode type: #String
]

{ #category : #files }
GLHMetamodelGenerator >> fileProperties [

	file property: #name type: #String
]

{ #category : #groups }
GLHMetamodelGenerator >> groupProperties [

	group property: #id type: #Number. "Group properties"
	group property: #web_url type: #String.
	group property: #description type: #String.
	group property: #visibility type: #String.
	group property: #avatar_url type: #String
]

{ #category : #issues }
GLHMetamodelGenerator >> issueProperties [

	issue property: #name type: #String.
	issue property: #description type: #String.
	issue property: #state type: #String.
	issue property: #id type: #Number.
	
	issue property: #created_at type: #Object.
	issue property: #updated_at type: #Object.
	issue property: #closed_at type: #Object.
	issue property: #due_date type: #Object.
]

{ #category : #issues }
GLHMetamodelGenerator >> issueRelations [

	issue *-<> project.
	(issue property: #assignees) <>-* (user property: #assignedIssue).
	(issue property: #author) *-<> (user property: #createdIssue)
]

{ #category : #jobs }
GLHMetamodelGenerator >> jobProperties [

	job property: #id type: #Number.
	job property: #allow_failure type: #Boolean.
	job property: #web_url type: #String.
	job property: #duration type: #Object.
	job property: #name type: #String. 
	job property: #ref type: #String.
]

{ #category : #'merge requests' }
GLHMetamodelGenerator >> mergeRequestProperties [

	mergeRequest property: #id type: #Number.
	mergeRequest property: #iid type: #Number.
	mergeRequest property: #project_id type: #Number.
	mergeRequest property: #title type: #String.
	mergeRequest property: #description type: #String.
	mergeRequest property: #state type: #String.
	mergeRequest property: #created_at type: #Object.
	mergeRequest property: #updated_at type: #Object.
	mergeRequest property: #merged_at type: #Object.
	mergeRequest property: #closed_at type: #Object.
	mergeRequest property: #target_branch type: #String.
	mergeRequest property: #source_branch type: #String.
	mergeRequest property: #user_notes_count type: #Number.
	mergeRequest property: #upvotes type: #Number.
	mergeRequest property: #downvotes type: #Number.
	mergeRequest property: #source_project_id type: #Number.
	mergeRequest property: #target_project_id type: #Number.
	mergeRequest property: #labels type: #Object.
	mergeRequest property: #draft type: #Boolean.
	mergeRequest property: #work_in_progress type: #Boolean.
	mergeRequest property: #milestone type: #String.
	mergeRequest property: #merge_when_pipeline_succeeds type: #Boolean.
	mergeRequest property: #merge_status type: #String.
	mergeRequest property: #detailed_merge_status type: #String.
	mergeRequest property: #sha type: #String.
	mergeRequest property: #merge_commit_sha type: #String.
	mergeRequest property: #squash_commit_sha type: #String.
	mergeRequest property: #discussion_locked type: #String.
	mergeRequest property: #should_remove_source_branch type: #Boolean.
	mergeRequest property: #force_remove_source_branch type: #Boolean.
	mergeRequest property: #reference type: #String.
	mergeRequest property: #references_short type: #String.
	mergeRequest property: #references_relative type: #String.
	mergeRequest property: #references_full type: #String.
	mergeRequest property: #web_url type: #String.
	mergeRequest property: #time_stats_time_estimate type: #Number.
	mergeRequest property: #time_stats_total_time_spent type: #Number.
	mergeRequest property: #time_stats_human_time_estimate type: #String.
	mergeRequest
		property: #time_stats_human_total_time_spent
		type: #String.
	mergeRequest property: #squash type: #Boolean.
	mergeRequest property: #squash_on_merge type: #Boolean.
	mergeRequest property: #task_completion_status_count type: #Number.
	mergeRequest
		property: #task_completion_status_completed_count
		type: #Number.
	mergeRequest property: #has_conflicts type: #Boolean.
	mergeRequest property: #blocking_discussions_resolved type: #Boolean.
	mergeRequest property: #subscribed type: #Boolean.
	mergeRequest property: #changes_count type: #String.
	mergeRequest property: #latest_build_started_at type: #String.
	mergeRequest property: #latest_build_finished_at type: #String.
	mergeRequest property: #first_deployed_to_production_at type: #String.
	mergeRequest property: #approved type: #Boolean.

	"see https://github.com/moosetechnology/GitProjectHealth/issues/88"
	mergeRequest property: #commits type: #Object
]

{ #category : #'merge requests' }
GLHMetamodelGenerator >> mergeRequestsRelations [

	(mergeRequest property: #author)
	*- (user property: #createdMergeRequests).
	(mergeRequest property: #approved_by)
	*-* (user property: #approcheMergeRequests).
	(mergeRequest property: #merge_user) *- (user property: #usedMerges).
	(mergeRequest property: #closed_by)
	*- (user property: #closedMergeRequests).
	(mergeRequest property: #merged_by)
	*- (user property: #mergerOfMergeRequests).
	(mergeRequest property: #assignees)
	*-* (user property: #assignedMergeRequests).
	(mergeRequest property: #assignee)
	*- (user property: #currentlyAssignedMergeRequest).
	(mergeRequest property: #reviewers)
	*-* (user property: #reviewedMergeRequest).
	(mergeRequest property: #pipelines)
	<>-* (pipeline property: #mergeRequest).
	(mergeRequest property: #mergedCommit)
	- (commit property: #commitedMergeRequest).
	(mergeRequest property: #mergeRequestCommit)
	- (commit property: #commitedMergeRequest).
	(mergeRequest property: #squashCommit)
	- (commit property: #squashedMergeRequest).
	(mergeRequest property: #diffs) -* (diff property: #mergeRequest).
	(project property: #mergeRequests)
	<>-* (mergeRequest property: #project).

]

{ #category : #milestones }
GLHMetamodelGenerator >> milestoneProperties [

	milestone property: #id type: #Number.
	milestone property: #title type: #String.
	milestone property: #description type: #String.
	
	milestone property: #open_issues type: #Number .
	milestone property: #closed_issues type: #Number.

	milestone property: #created_at type: #Object.
	milestone property: #updated_at type: #Object.
	milestone property: #closed_at type: #Object.
	milestone property: #due_date type: #Object
]

{ #category : #milestones }
GLHMetamodelGenerator >> milestoneRelations [

	(milestone property: #project) *-<> (project property: #milestone).
	(milestone property: #author) <>- (user property: #createdMilestone).
	
	(milestone property: #issue) <>-* (issue property: #milestone).
	(milestone property: #mergeRequest) <>-* (mergeRequest property: #milestone).
]

{ #category : #notes }
GLHMetamodelGenerator >> notePositionProperties [

	notePosition property: #file_path type: #String.
	notePosition property: #original_file_path type: #String.
	notePosition property: #start_line type: #Number.
	notePosition property: #start_line_type type: #String.
	notePosition property: #end_line type: #Number.
	notePosition property: #end_line_type type: #String.
]

{ #category : #notes }
GLHMetamodelGenerator >> notePositionRelations [

	 (notePosition property: #note) - (note property: #position)
]

{ #category : #notes }
GLHMetamodelGenerator >> noteProperties [ 
	note property: #id type: #Number.
	note property: #body type: #String. 
	note property: #attachment type: #Object.
	note property: #author type: #Object.
	note property: #created_at type: #Object.
	note property: #updated_at type: #Object.
	note property: #system type: #Boolean.
	note property: #noteable_id type: #Number.
	note property: #noteable_type type: #String.
	note property: #project_id type: #Number.
	note property: #noteable_iid type: #Number.
	note property: #resolvable type: #Boolean.
	note property: #confidential type: #Boolean.
	note property: #internal type: #Boolean.
	note property: #imported type: #Boolean.
	note property: #imported_from type: #String.
	 
 
 
 
 
 
 
 
 

]

{ #category : #notes }
GLHMetamodelGenerator >> noteRelations [

	(note property: #mergeRequest) *- (mergeRequest property: #note).
	(note property: #position) - (notePosition property: #note)
]

{ #category : #notes }
GLHMetamodelGenerator >> noteSuggestionProperties [

	noteSuggestion property: #from_line type: #Number.
	noteSuggestion property: #to_line type: #Number.
	noteSuggestion property: #from_content type: #String.
	noteSuggestion property: #to_content type: #String.
]

{ #category : #notes }
GLHMetamodelGenerator >> noteSuggestionRelations [

	(noteSuggestion property: #note) -* (note property: #suggestions)
]

{ #category : #pipelines }
GLHMetamodelGenerator >> pipelinesProperties [
	
	"Pipelines properties"
	
	(pipeline property: #id type: #String) comment:
		'The id of the pipeline'.
	(pipeline property: #name type: #String) comment:
		'name of the pipeline'.	
			
	(pipeline property: #status type: #String) comment:
		'#success or #failure'.	
	(pipeline property: #ref type: #String) comment:
		'reference its emmited source (merge request or else)'.	
	(pipeline property: #sha type: #String) comment:
		'sha of its emmited source'.	
	
	(pipeline property: #sourceEvent type: #String) comment: 'triggering event from where the pipeline originate, such as #push #fork, etc.'.
	
	(pipeline property: #runDate type: #Object) comment:
		'Date this pipeline was run'.
	(pipeline property: #created_at type: #Object) comment: 'creation date of the pipeline'.
	(pipeline property: #updated_at type: #Object) comment: 'update date of the pipeline'.
	(pipeline property: #started_at type: #Object) comment: 'start date of the pipeline'.
	(pipeline property: #finished_at type: #Object) comment: 'finish date of the pipeline'.	
	(pipeline property: #duration type: #Object) comment: 'the running duration of a pipeline'.

]

{ #category : #projects }
GLHMetamodelGenerator >> projectProperties [

	project property: #id type: #Number. "Project properties"
	project property: #topics type: #Object.
	project property: #archived type: #Boolean.
	project property: #archived type: #Boolean.
	project property: #description type: #String.
	project property: #readme_url type: #String.
	project property: #avatar_url type: #String.
	project property: #web_url type: #String.
	project property: #creator_id type: #Number
]

{ #category : #projects }
GLHMetamodelGenerator >> projectRelations [

	(project property: #pipelines) <>-* (pipeline property: #project).
	(project property: #creator) *- (user property: #createdProjects).
	(project property: #contributors)
	*-* (user property: #contributedProjects).
	(project property: #repository) <>- (repository property: #project)
]

{ #category : #releases }
GLHMetamodelGenerator >> releaseProperties [

	release property: #description type: #String.
	release property: #tag_name type: #String.
	release property: #name type: #String.
	
	release property: #created_at type: #Object.
	release property: #released_at type: #Object.
	release property: #commit_path type: #String.
	release property: #tag_path type: #String.
]

{ #category : #releases }
GLHMetamodelGenerator >> releaseRelations [

	(release property: #author) *-<> (user property: #releases).
	(release property: #project) *-<> (project property: #releases)
]

{ #category : #'as yet unclassified' }
GLHMetamodelGenerator >> tRefProperties [
	"define the properties of a ref instance"

	tRef property: #sha type: #String.
]

{ #category : #tags }
GLHMetamodelGenerator >> tagProperties [

	tag property: #message type: #String.
	tag property: #target type: #String.
	tag property: #protected type: #Boolean.
	tag property: #created_at type: #Object.

]

{ #category : #tags }
GLHMetamodelGenerator >> tagRelations [
	(tag property: #commit) - (commit property: #tag).
	(tag property: #release) - (release property: #tag).
	(tag property: #repository) *-<> (repository property: #tags).
]

{ #category : #users }
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
	user property: #email type: #String.
	user property: #commit_email type: #String.
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
