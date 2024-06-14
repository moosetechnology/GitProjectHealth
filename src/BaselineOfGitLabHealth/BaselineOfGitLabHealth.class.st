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
		with: [ spec repository: 'github://badetitou/MoreLogger:main/src' ]
]

{ #category : #baselines }
BaselineOfGitLabHealth >> defineGroups: spec [
]

{ #category : #baselines }
BaselineOfGitLabHealth >> definePackages: spec [

	spec
		package: 'GitLabHealth-Model';
		package: 'GitLabHealth-Model-Extension'
		with: [ spec requires: #( 'GitLabHealth-Model' ) ];
		package: 'GitLabHealth-Model-Generator';
		package: 'GitLabHealth-Model-Inspector'
		with: [ spec requires: #( 'GitLabHealth-Model-Visualization' ) ];
		package: 'GitLabHealth-Model-Visualization';
		package: 'GitLabHealth-Model-Importer'
		with: [ spec requires: #( 'NeoJSON' 'MoreLogger' ) ];
		package: 'GitHubHealth-Model-Importer'
		with: [ spec requires: #( 'NeoJSON' 'MoreLogger' ) ];
		package: 'GitLabHealth-Model-Importer-Tests' with: [
			spec requires:
					#( 'GitLabHealth-Model-Importer' 'GitHubHealth-Model-Importer' ) ].
	spec
		package: 'GitHubHealth-Model-Importer-Tests'
		with: [ spec requires: #( 'GitHubHealth-Model-Importer' ) ].

	"model extension"
	spec
		package: 'GLPHExtended-Model' with: [
			spec requires:
					#( 'GitLabHealth-Model' 'GitLabHealth-Model-Extension' ) ];
		package: 'GLPHExtended-Model-Extension' with: [
			spec requires:
					#( 'GLPHExtended-Model' 'GitLabHealth-Model' 'GitLabHealth-Model-Extension' ) ];
		package: 'GitLabHealth-Model-Analysis';
		package: 'GitLabHealth-Model-Analysis-Tests'
		with: [ spec requires: #( 'GitLabHealth-Model-Analysis' ) ];
		package: 'GitLabHealth-Visualization';
		package: 'GitLabProjectHealth-ExtendModel-Generator';
		package: 'GitLabProjectHealth-Model-Importer';
		package: 'GitLabProjectHealth-Model-Importer-Tests'
		with: [ spec requires: #( 'GitLabProjectHealth-Model-Importer' ) ]
]
