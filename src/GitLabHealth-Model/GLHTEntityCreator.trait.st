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
GLHTEntityCreator >> newBranch [

	<generated>
	^ self add: GLHBranch new
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
GLHTEntityCreator >> newRepository [

	<generated>
	^ self add: GLHRepository new
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
