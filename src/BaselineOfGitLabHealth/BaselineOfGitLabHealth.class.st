Class {
	#name : #BaselineOfGitLabHealth,
	#superclass : #BaselineOf,
	#category : #BaselineOfGitLabHealth
}

{ #category : #baselines }
BaselineOfGitLabHealth >> baseline: spec [

	<baseline>
	spec for: #common do: [
		self defineDependencies: spec.
		self definePackages: spec.
		self defineGroups: spec.
		self defineJiraConnector: spec.
		self defineFamixConnector: spec.

		spec for: #( #WithoutFamix ) do: [
			spec
				baseline: 'Moose'
				with: [
				spec repository: 'github://moosetechnology/Moose:development/src' ].
			spec package: 'GitLabHealth-Model' with: [ spec requires: #( 'Moose' ) ] ] ]
]

{ #category : #baselines }
BaselineOfGitLabHealth >> customProjectAttributes [
    self class environment at: #MooseEntity ifAbsent: [ ^ #(#WithoutFamix) ].

    ^ #()
]

{ #category : #baselines }
BaselineOfGitLabHealth >> defineDependencies: spec [

	spec
		baseline: 'NeoJSON'
		with: [ spec repository: 'github://svenvc/NeoJSON/repository' ].
	spec
		baseline: 'MoreLogger'
		with: [ spec repository: 'github://badetitou/MoreLogger:main/src' ].
	spec baseline: 'Voyage' with: [
		spec
			loads: #( 'mongo' );
			repository: 'github://pharo-nosql/voyage/mc' ].
	spec baseline: 'AWS' with: [
		spec repository:
			'github://Evref-BL/aws-sdk-smalltalk:master/pharo-repository' ].

	spec
		baseline: 'GitlabAPI'
		with: [
		spec repository: 'github://Evref-BL/Gitlab-Pharo-API:main' ].

	spec
		baseline: 'BitbucketPharoAPI'
		with: [
		spec repository: 'github://Evref-BL/Bitbucket-Pharo-API:main' ]
]

{ #category : #baselines }
BaselineOfGitLabHealth >> defineFamixConnector: spec [

	spec
		package: 'GitProject-FamixConnector'
		with: [ spec requires: #( 'GitProject-FamixConnector-Model' ) ];
		package: 'GitProject-FamixConnector-Model';
		package: 'GitProject-FamixConnector-Generator'
		with: [ spec requires: #( 'GitProject-FamixConnector-Model' ) ];
		package: 'GitProject-FamixConnector-Tests'
		with: [ spec requires: #( 'GitProject-FamixConnector' ) ]
]

{ #category : #baselines }
BaselineOfGitLabHealth >> defineGroups: spec [

	spec
		group: 'Jira'
		with:
			#( 'GitProject-JiraConnector' 'GitProject-JiraConnector-Generator'
			   'GitProject-JiraConnector-Tests' ).

	spec
		group: 'Famix'
		with:
			#( 'GitProject-FamixConnector' 'GitProject-FamixConnector-Generator'
			   'GitProject-FamixConnector-Tests' ).
	spec
		group: 'Core'
		with: #( 'GitLabHealth-Model' 'GitLabHealth-Model-Extension'
			   'GitLabHealth-Model-Tests' 'GitLabHealth-Model-Extension-Tests'
			   'GitLabHealth-Model-Generator' 'GitLabHealth-Model-Inspector'
			   'GitLabHealth-Model-Visualization'
			   'GitLabHealth-Model-Importer' 'GitLabHealth-Model-Importer-Tests'
			   'GitHubHealth-Model-Importer-Tests'
			   'GitLabHealth-Model-Analysis' 'GitLabHealth-Model-Analysis-Tests'
			   'GitLabHealth-Visualization'
			   'GitLabProjectHealth-Model-Importer'
			   'GitLabProjectHealth-Model-Importer-Tests'
			   'BitBucketHealth-Model-Importer'
			   'BitBucketHealth-Model-Importer-Tests' ).
	spec group: 'default' with: #( 'Core' )
]

{ #category : #baselines }
BaselineOfGitLabHealth >> defineJiraConnector: spec [

	spec
		package: 'GitProject-JiraConnector-Model'
		with: [ spec requires: #( 'JiraPharoAPI' ) ];
		package: 'GitProject-JiraConnector' with: [
			spec requires: #( 'GitProject-JiraConnector-Model'
				   'JiraPharoAPI' ) ];
		package: 'GitProject-JiraConnector-Generator';
		package: 'GitProject-JiraConnector-Tests' with: [
			spec requires: #( 'GitProject-JiraConnector'
				   'JiraPharoAPI' ) ].

	"dependency"
	spec
		baseline: 'JiraPharoAPI'
		with: [
		spec repository: 'github://Evref-BL/Jira-Pharo-API:main/src' ]
]

{ #category : #baselines }
BaselineOfGitLabHealth >> definePackages: spec [
	"generic"

	spec
		package: 'GitProjectHealth-Model-Importer'
		with: [ spec requires: #( 'GitlabAPI' ) ].
	spec
		package: 'GitProjectHealth-Model-Importer-Tests'
		with: [ spec requires: #( 'GitProjectHealth-Model-Importer' ) ].

	"gitlab"
	spec
		package: 'GitLabHealth-Model';
		package: 'GitLabHealth-Model-Extension'
		with: [ spec requires: #( 'GitLabHealth-Model' ) ];
		package: 'GitLabHealth-Model-Extension-Tests'
		with: [ spec requires: #( 'GitLabHealth-Model-Extension' ) ];
		package: 'GitLabHealth-Model-Generator';
		package: 'GitLabHealth-Model-Inspector'
		with: [ spec requires: #( 'GitLabHealth-Model-Visualization' ) ];
		package: 'GitLabHealth-Model-Visualization';
		package: 'GitLabHealth-Model-Importer' with: [
			spec requires:
					#( 'NeoJSON' 'MoreLogger' 'GitProjectHealth-Model-Importer' ) ];
		package: 'GitHubHealth-Model-Importer' with: [
			spec requires:
					#( 'NeoJSON' 'MoreLogger' 'GitProjectHealth-Model-Importer' ) ];
		package: 'GitLabHealth-Model-Importer-Tests' with: [
			spec requires:
					#( 'GitLabHealth-Model-Importer' 'GitHubHealth-Model-Importer' ) ].
	spec
		package: 'GitLabHealth-Model-Tests'
		with: [ spec requires: #( 'GitLabHealth-Model' ) ].
	spec
		package: 'GitHubHealth-Model-Importer-Tests'
		with: [ spec requires: #( 'GitHubHealth-Model-Importer' ) ].

	"Bitbucket"
	spec
		package: 'BitBucketHealth-Model-Importer'
		with: [ spec requires: #( 'BitbucketPharoAPI' ) ];
		package: 'BitBucketHealth-Model-Importer-Tests'
		with: [ spec requires: #( 'BitBucketHealth-Model-Importer' ) ].

	"model extension"
	spec
		package: 'GitLabHealth-Model-Analysis'
		with: [ spec requires: #( 'Voyage' 'AWS' ) ];
		package: 'GitLabHealth-Model-Analysis-Tests'
		with: [ spec requires: #( 'GitLabHealth-Model-Analysis' ) ];
		package: 'GitLabHealth-Visualization';
		package: 'GitLabProjectHealth-Model-Importer';
		package: 'GitLabProjectHealth-Model-Importer-Tests'
		with: [ spec requires: #( 'GitLabProjectHealth-Model-Importer' ) ]
]
