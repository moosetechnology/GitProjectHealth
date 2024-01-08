Class {
	#name : #BaselineOfGitLabHealth,
	#superclass : #BaselineOf,
	#category : #BaselineOfGitLabHealth
}

{ #category : #baselines }
BaselineOfGitLabHealth >> baseline: spec [
	<baseline>
	spec
		for: #common
		do: [ 
			self defineDependencies: spec.
			self definePackages: spec.
			self defineGroups: spec ]
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
		package: 'GitLabHealth-Model-Importer-Tests'
		with: [ spec requires: #( 'GitLabHealth-Model-Importer' 'GitHubHealth-Model-Importer' ) ]
]
