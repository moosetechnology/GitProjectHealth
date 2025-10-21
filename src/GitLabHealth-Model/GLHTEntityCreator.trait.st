"
This trait is used by Famix models.
It provides an API for creating entities and adding them to the model.


"
Trait {
	#name : #GLHTEntityCreator,
	#category : #'GitLabHealth-Model-Model'
}

{ #category : #meta }
GLHTEntityCreator classSide >> annotation [

	<FMClass: #TEntityCreator super: #Object>
	<package: #'GitLabHealth-Model'>
	<generated>
	^ self
]

{ #category : #'entity creation' }
GLHTEntityCreator >> newAddition [

	<generated>
	^ self add: GLHAddition new
]

{ #category : #'entity creation' }
GLHTEntityCreator >> newBranch [

	<generated>
	^ self add: GLHBranch new
]

{ #category : #'entity creation' }
GLHTEntityCreator >> newBranchNamed: aName [

	<generated>
	^ self add: (GLHBranch named: aName)
]

{ #category : #'entity creation' }
GLHTEntityCreator >> newChange [

	<generated>
	^ self add: GLHChange new
]

{ #category : #'entity creation' }
GLHTEntityCreator >> newChangeNamed: aName [

	<generated>
	^ self add: (GLHChange named: aName)
]

{ #category : #'entity creation' }
GLHTEntityCreator >> newCommit [

	<generated>
	^ self add: GLHCommit new
]

{ #category : #'entity creation' }
GLHTEntityCreator >> newCommitNamed: aName [

	<generated>
	^ self add: (GLHCommit named: aName)
]

{ #category : #'entity creation' }
GLHTEntityCreator >> newDeletion [

	<generated>
	^ self add: GLHDeletion new
]

{ #category : #'entity creation' }
GLHTEntityCreator >> newDiff [

	<generated>
	^ self add: GLHDiff new
]

{ #category : #'entity creation' }
GLHTEntityCreator >> newDiffNamed: aName [

	<generated>
	^ self add: (GLHDiff named: aName)
]

{ #category : #'entity creation' }
GLHTEntityCreator >> newDiffRange [

	<generated>
	^ self add: GLHDiffRange new
]

{ #category : #'entity creation' }
GLHTEntityCreator >> newFile [

	<generated>
	^ self add: GLHFile new
]

{ #category : #'entity creation' }
GLHTEntityCreator >> newFileBlob [

	<generated>
	^ self add: GLHFileBlob new
]

{ #category : #'entity creation' }
GLHTEntityCreator >> newFileDirectory [

	<generated>
	^ self add: GLHFileDirectory new
]

{ #category : #'entity creation' }
GLHTEntityCreator >> newGroup [

	<generated>
	^ self add: GLHGroup new
]

{ #category : #'entity creation' }
GLHTEntityCreator >> newGroupNamed: aName [

	<generated>
	^ self add: (GLHGroup named: aName)
]

{ #category : #'entity creation' }
GLHTEntityCreator >> newIssue [

	<generated>
	^ self add: GLHIssue new
]

{ #category : #'entity creation' }
GLHTEntityCreator >> newIssueNamed: aName [

	<generated>
	^ self add: (GLHIssue named: aName)
]

{ #category : #'entity creation' }
GLHTEntityCreator >> newJob [

	<generated>
	^ self add: GLHJob new
]

{ #category : #'entity creation' }
GLHTEntityCreator >> newJobNamed: aName [

	<generated>
	^ self add: (GLHJob named: aName)
]

{ #category : #'entity creation' }
GLHTEntityCreator >> newLineOfCode [

	<generated>
	^ self add: GLHLineOfCode new
]

{ #category : #'entity creation' }
GLHTEntityCreator >> newMergeRequest [

	<generated>
	^ self add: GLHMergeRequest new
]

{ #category : #'entity creation' }
GLHTEntityCreator >> newMergeRequestNamed: aName [

	<generated>
	^ self add: (GLHMergeRequest named: aName)
]

{ #category : #'entity creation' }
GLHTEntityCreator >> newMilestone [

	<generated>
	^ self add: GLHMilestone new
]

{ #category : #'entity creation' }
GLHTEntityCreator >> newMilestoneNamed: aName [

	<generated>
	^ self add: (GLHMilestone named: aName)
]

{ #category : #'entity creation' }
GLHTEntityCreator >> newNote [

	<generated>
	^ self add: GLHNote new
]

{ #category : #'entity creation' }
GLHTEntityCreator >> newNoteNamed: aName [

	<generated>
	^ self add: (GLHNote named: aName)
]

{ #category : #'entity creation' }
GLHTEntityCreator >> newNotePosition [

	<generated>
	^ self add: GLHNotePosition new
]

{ #category : #'entity creation' }
GLHTEntityCreator >> newNotePositionNamed: aName [

	<generated>
	^ self add: (GLHNotePosition named: aName)
]

{ #category : #'entity creation' }
GLHTEntityCreator >> newNoteSuggestion [

	<generated>
	^ self add: GLHNoteSuggestion new
]

{ #category : #'entity creation' }
GLHTEntityCreator >> newNoteSuggestionNamed: aName [

	<generated>
	^ self add: (GLHNoteSuggestion named: aName)
]

{ #category : #'entity creation' }
GLHTEntityCreator >> newPipeline [

	<generated>
	^ self add: GLHPipeline new
]

{ #category : #'entity creation' }
GLHTEntityCreator >> newProject [

	<generated>
	^ self add: GLHProject new
]

{ #category : #'entity creation' }
GLHTEntityCreator >> newProjectNamed: aName [

	<generated>
	^ self add: (GLHProject named: aName)
]

{ #category : #'entity creation' }
GLHTEntityCreator >> newRelease [

	<generated>
	^ self add: GLHRelease new
]

{ #category : #'entity creation' }
GLHTEntityCreator >> newRepository [

	<generated>
	^ self add: GLHRepository new
]

{ #category : #'entity creation' }
GLHTEntityCreator >> newTag [

	<generated>
	^ self add: GLHTag new
]

{ #category : #'entity creation' }
GLHTEntityCreator >> newTagNamed: aName [

	<generated>
	^ self add: (GLHTag named: aName)
]

{ #category : #'entity creation' }
GLHTEntityCreator >> newUser [

	<generated>
	^ self add: GLHUser new
]

{ #category : #'entity creation' }
GLHTEntityCreator >> newUserNamed: aName [

	<generated>
	^ self add: (GLHUser named: aName)
]
