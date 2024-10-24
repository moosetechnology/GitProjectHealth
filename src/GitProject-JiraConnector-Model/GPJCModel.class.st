Class {
	#name : #GPJCModel,
	#superclass : #MooseModel,
	#traits : 'GLHTEntityCreator + GLPHETEntityCreator + JPTEntityCreator',
	#classTraits : 'GLHTEntityCreator classTrait + GLPHETEntityCreator classTrait + JPTEntityCreator classTrait',
	#category : #'GitProject-JiraConnector-Model-Model'
}

{ #category : #accessing }
GPJCModel class >> allSubmetamodelsPackagesNames [
	<generated>
	^ #(#'Moose-Query' #'JiraPharoAPI-Model' #'GitLabHealth-Model' #'GLPHExtended-Model' #'Famix-Traits')
]

{ #category : #meta }
GPJCModel class >> annotation [
	<FMClass: #GPJCModel super: #MooseModel>
	<package: #'GitProject-JiraConnector-Model'>
	<generated>
]
