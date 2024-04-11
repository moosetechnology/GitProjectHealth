"
This trait is used by Famix models.
It provides an API for creating entities and adding them to the model.


"
Trait {
	#name : #GLPHETEntityCreator,
	#category : #'GLPHExtended-Model-Model'
}

{ #category : #meta }
GLPHETEntityCreator classSide >> annotation [

	<FMClass: #TEntityCreator super: #Object>
	<package: #'GLPHExtended-Model'>
	<generated>
	^ self
]

{ #category : #'entity creation' }
GLPHETEntityCreator >> newAddition [

	<generated>
	^ self add: GLPHEAddition new
]

{ #category : #'entity creation' }
GLPHETEntityCreator >> newChange [

	<generated>
	^ self add: GLPHEChange new
]

{ #category : #'entity creation' }
GLPHETEntityCreator >> newDeletion [

	<generated>
	^ self add: GLPHEDeletion new
]

{ #category : #'entity creation' }
GLPHETEntityCreator >> newDiffRange [

	<generated>
	^ self add: GLPHEDiffRange new
]

{ #category : #'entity creation' }
GLPHETEntityCreator >> newLineOfCode [

	<generated>
	^ self add: GLPHELineOfCode new
]

{ #category : #'entity creation' }
GLPHETEntityCreator >> newMergeRequest [

	<generated>
	^ self add: GLPHEMergeRequest new
]

{ #category : #'entity creation' }
GLPHETEntityCreator >> newMergeRequestNamed: aName [

	<generated>
	^ self add: (GLPHEMergeRequest named: aName)
]
