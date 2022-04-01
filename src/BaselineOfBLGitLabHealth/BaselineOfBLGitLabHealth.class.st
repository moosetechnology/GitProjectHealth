Class {
	#name : #BaselineOfBLGitLabHealth,
	#superclass : #BaselineOf,
	#category : #BaselineOfBLGitLabHealth
}

{ #category : #baselines }
BaselineOfBLGitLabHealth >> baseline: spec [
	<baseline>
	spec
		for: #common
		do: [ 
			self defineDependencies: spec.
			self definePackages: spec.
			self defineGroups: spec ]
]

{ #category : #baselines }
BaselineOfBLGitLabHealth >> defineDependencies: spec [

	spec
		baseline: 'NeoJSON'
		with: [ spec repository: 'github://svenvc/NeoJSON/repository' ].
	spec
		baseline: 'MoreLogger'
		with: [ spec repository: 'github://badetitou/MoreLogger:main/src' ]
]

{ #category : #baselines }
BaselineOfBLGitLabHealth >> defineGroups: spec [
]

{ #category : #baselines }
BaselineOfBLGitLabHealth >> definePackages: spec [

	spec
		package: 'BL-GitLabHealth-Model';
		package: 'BL-GitLabHealth-Model-Generator';
		package: 'BL-GitLabHealth-Model-Visualization';
		package: 'BL-GitLabHealth-Model-Importer'
		with: [ spec requires: #( 'NeoJSON' 'MoreLogger' ) ];
		package: 'BL-GitLabHealth-Model-Importer-Tests'
		with: [ spec requires: #( 'BL-GitLabHealth-Model-Importer' ) ]
]
