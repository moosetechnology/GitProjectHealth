Class {
	#name : #GLPHMetamodelGenerator,
	#superclass : #FamixMetamodelGenerator,
	#instVars : [
		'mergeRequest',
		'addition',
		'deletion',
		'change',
		'repository',
		'file',
		'diff',
		'user',
		'pipeline',
		'commit',
		'project',
		'lineOfCode',
		'diffRange'
	],
	#category : #'GitLabProjectHealth-ExtendModel-Generator'
}

{ #category : #accessing }
GLPHMetamodelGenerator class >> packageName [
	^ #'GLPHExtended-Model'
]

{ #category : #accessing }
GLPHMetamodelGenerator class >> prefix [ 
	  ^ #'GLPHE'
]

{ #category : #accessing }
GLPHMetamodelGenerator class >> submetamodels [
	^ { GLHMetamodelGenerator   }
]

{ #category : #'as yet unclassified' }
GLPHMetamodelGenerator >> changeProperties [

	change property: #index type: #Number.
	change property: #relativeIndex type: #Number.
	change property: #sourceCode type: #String. 
	addition property: #delimiter type: #String defaultValue: '#+'.
	deletion property: #delimiter type: #String defaultValue: '#-'
]

{ #category : #definition }
GLPHMetamodelGenerator >> defineClasses [

	super defineClasses.
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
	deletion := builder
		            newClassNamed: #Deletion
		            comment:
		            'a detected deletion of a line, seen within a diff '.

	lineOfCode := builder
		              newClassNamed: #LineOfCode
		              comment: 'a line of code in a diff comparaison '.

	diffRange := builder
		             newClassNamed: #DiffRange
		             comment:
		             'a indicate on which line of code are concerned by a diff (usually declared with @@ oldRange, newRange @@) '.


	repository := self remoteEntity: #Repository withPrefix: #GLH.
	file := self remoteEntity: #File withPrefix: #GLH.
	diff := self remoteEntity: #Diff withPrefix: #GLH.
	user := self remoteEntity: #User withPrefix: #GLH.
	pipeline := self remoteEntity: #Pipeline withPrefix: #GLH.
	commit := self remoteEntity: #Commit withPrefix: #GLH.
	project := self remoteEntity: #Project withPrefix: #GLH
]

{ #category : #definition }
GLPHMetamodelGenerator >> defineHierarchy [

	super defineHierarchy.
	(builder ensureClassNamed: #Entity) --|> #TEntityMetaLevelDependency.
	change --|> #TNamedEntity.
	 change <|-- addition.
	change <|-- deletion.
	change <|-- lineOfCode.
	mergeRequest --|> #TNamedEntity
]

{ #category : #definition }
GLPHMetamodelGenerator >> defineProperties [

	super defineProperties.

	self changeProperties.
	self mergeRequestProperties.
	self diffRangeProperties.
]

{ #category : #definition }
GLPHMetamodelGenerator >> defineRelations [

	super defineRelations.

	"MERGE REQUEST RELATIONS"
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
	*-* (user property: #reviewedMergeResquest).

	(mergeRequest property: #pipeline)
	- (pipeline property: #mergeResquest).

	(mergeRequest property: #mergedCommit)
	- (commit property: #commitedMergeRequest).

	(mergeRequest property: #mergeRequestCommit)
	- (commit property: #commitedMergeRequest).

	(mergeRequest property: #squashCommit)
	- (commit property: #squashedMergeRequest).

	(mergeRequest property: #diffs) -* (diff property: #mergeRequest).

	(project property: #mergeRequests)
	<>-* (mergeRequest property: #project).

	"DIFF"
	(diff property: #file) <>-* (file property: #diffs).
	(diff property: #diffRanges) <>-* (diffRange property: #diff).
	(diffRange property: #changes) -* (change property: #diffRange)
]

{ #category : #'as yet unclassified' }
GLPHMetamodelGenerator >> diffRangeProperties [
"must parse the range. 
	originalLineRange = '-120,5' --> change starts at line #120
	5 is the number of lines in the original file affected by the change"
	diffRange property: #originalLineRange type: #String.
	diffRange property: #newLineRange type: #String.
	diffRange property: #lineOfCode type: #String
]

{ #category : #'as yet unclassified' }
GLPHMetamodelGenerator >> mergeRequestProperties [

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
	mergeRequest property: #approved type: #Boolean
]
