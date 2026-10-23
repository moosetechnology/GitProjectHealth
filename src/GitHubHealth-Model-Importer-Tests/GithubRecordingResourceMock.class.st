"
I am an abstract recording test double for a GitHub API resource (commits, pulls, users).

Every API selector I implement records `selector -> arguments` (arguments is an Array) in `calls`, then answers what `responder` returns. The responder is a block evaluated with `cull: arguments cull: selector`, so it may take zero, one (the arguments Array) or two arguments. It must answer a JSON String, like the real GithubApi.

Default responder answers '[]'.
"
Class {
	#name : #GithubRecordingResourceMock,
	#superclass : #Object,
	#instVars : [
		'calls',
		'responder'
	],
	#category : #'GitHubHealth-Model-Importer-Tests'
}

{ #category : #accessing }
GithubRecordingResourceMock >> calls [
	"Answer the recorded calls, in order, as `selector -> arguments` associations"

	^ calls
]

{ #category : #accessing }
GithubRecordingResourceMock >> callsTo: aSelector [
	"Answer the argument Arrays of the recorded calls to aSelector, in order"

	^ calls
		  select: [ :call | call key = aSelector ]
		  thenCollect: [ :call | call value ]
]

{ #category : #initialization }
GithubRecordingResourceMock >> initialize [

	super initialize.
	calls := OrderedCollection new.
	responder := [ '[]' ]
]

{ #category : #recording }
GithubRecordingResourceMock >> record: aSelector withArguments: anArray [

	calls add: aSelector -> anArray.
	^ responder cull: anArray cull: aSelector
]

{ #category : #accessing }
GithubRecordingResourceMock >> responder [

	^ responder
]

{ #category : #accessing }
GithubRecordingResourceMock >> responder: aBlock [
	"aBlock is evaluated with `cull: arguments cull: selector` and must answer a JSON String"

	responder := aBlock
]
