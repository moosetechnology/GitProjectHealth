Class {
	#name : #GHModelImporter,
	#superclass : #Object,
	#instVars : [
		'api',
		'glhModel'
	],
	#category : #'BL-GitHubHealth-Model-Importer'
}

{ #category : #accessing }
GHModelImporter >> api [

	^ api
]

{ #category : #accessing }
GHModelImporter >> api: anObject [

	api := anObject
]

{ #category : #accessing }
GHModelImporter >> glhModel [

	^ glhModel
]

{ #category : #accessing }
GHModelImporter >> glhModel: anObject [

	glhModel := anObject
]

{ #category : #api }
GHModelImporter >> importGroup: aGroupName [

	| result groupResult |
	result := self api organization: aGroupName.
	groupResult := self parseGroupResult: result.
	self glhModel add: groupResult
]

{ #category : #initialization }
GHModelImporter >> initialize [
	super initialize.
	self api: GHApi new.
]

{ #category : #private }
GHModelImporter >> parseGroupResult: aResult [

	| reader |
	reader := NeoJSONReader on: aResult readStream.
	reader for: GLHGroup do: [ :mapping | 
		mapping mapInstVar: #name to: #login.
		mapping mapInstVar: #description to: #description.
		mapping mapInstVar: #id to: #id.
		mapping mapInstVar: #web_url to: #html_url ].
	^ reader nextAs: GLHGroup
]
