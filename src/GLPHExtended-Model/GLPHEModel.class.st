Class {
	#name : 'GLPHEModel',
	#superclass : 'MooseModel',
	#traits : 'GLHTEntityCreator + GLPHETEntityCreator',
	#classTraits : 'GLHTEntityCreator classTrait + GLPHETEntityCreator classTrait',
	#category : 'GLPHExtended-Model-Model',
	#package : 'GLPHExtended-Model',
	#tag : 'Model'
}

{ #category : 'accessing' }
GLPHEModel class >> allSubmetamodelsPackagesNames [
	<generated>
	^ #(#'Moose-Query' #'GitLabHealth-Model' #'Famix-Traits')
]

{ #category : 'meta' }
GLPHEModel class >> annotation [
	<FMClass: #GLPHEModel super: #MooseModel>
	<package: #'GLPHExtended-Model'>
	<generated>
]
