Class {
	#name : #GLHModel,
	#superclass : #MooseModel,
	#traits : 'GLHTEntityCreator',
	#classTraits : 'GLHTEntityCreator classTrait',
	#category : #'GitLabHealth-Model-Model'
}

{ #category : #accessing }
GLHModel class >> allSubmetamodelsPackagesNames [
	<generated>
	^ #(#'Moose-Query' #'Famix-Traits')
]

{ #category : #meta }
GLHModel class >> annotation [
	<FMClass: #GLHModel super: #MooseModel>
	<package: #'GitLabHealth-Model'>
	<generated>
]
