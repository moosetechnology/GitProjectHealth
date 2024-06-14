Class {
	#name : #GPCModel,
	#superclass : #MooseModel,
	#traits : 'GLHTEntityCreator',
	#classTraits : 'GLHTEntityCreator classTrait',
	#category : #'GitProject-FamixConnector-Model-Model'
}

{ #category : #accessing }
GPCModel class >> allSubmetamodelsPackagesNames [
	<generated>
	^ #(#'Moose-Query' #'GitLabHealth-Model' #'Famix-Traits')
]

{ #category : #meta }
GPCModel class >> annotation [
	<FMClass: #GPCModel super: #MooseModel>
	<package: #'GitProject-FamixConnector-Model'>
	<generated>
]
