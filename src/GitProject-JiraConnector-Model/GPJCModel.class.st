Class {
	#name : #GPJCModel,
	#superclass : #MooseModel,
	#traits : 'JPTEntityCreator',
	#classTraits : 'JPTEntityCreator classTrait',
	#category : #'GitProject-JiraConnector-Model-Model'
}

{ #category : #accessing }
GPJCModel class >> allSubmetamodelsPackagesNames [
	<generated>
	^ #(#'Moose-Query' #'JiraPharoAPI-Model' #'GitLabHealth-Model' #'Famix-Traits')
]

{ #category : #meta }
GPJCModel class >> annotation [
	<FMClass: #GPJCModel super: #MooseModel>
	<package: #'GitProject-JiraConnector-Model'>
	<generated>
]
