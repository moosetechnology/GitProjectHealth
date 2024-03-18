Class {
	#name : #GLPHModelImporter,
	#superclass : #GLHModelImporter,
	#category : #'GitLabProjectHealth-Model-Importer'
}

{ #category : #'private - api' }
GLPHModelImporter >> completeImportProject: aGLHProject [

	super completeImportProject: aGLHProject.
	self importMergeRequests: aGLHProject
]

{ #category : #'as yet unclassified' }
GLPHModelImporter >> importProject: aProjectID [
]

{ #category : #initialization }
GLPHModelImporter >> initialize [

	super initialize.
	withCommitDiffs := true
]
