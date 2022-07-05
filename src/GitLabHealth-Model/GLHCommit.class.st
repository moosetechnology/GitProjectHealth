"
a commit attached to a repository
"
Class {
	#name : #GLHCommit,
	#superclass : #GLHEntity,
	#instVars : [
		'#id => FMProperty',
		'#short_id => FMProperty',
		'#title => FMProperty',
		'#author_name => FMProperty',
		'#author_email => FMProperty',
		'#authored_date => FMProperty',
		'#committer_name => FMProperty',
		'#committer_email => FMProperty',
		'#committed_date => FMProperty',
		'#created_at => FMProperty',
		'#message => FMProperty',
		'#web_url => FMProperty',
		'#repository => FMOne type: #GLHRepository opposite: #commits',
		'#branch => FMOne type: #GLHBranch opposite: #commits'
	],
	#category : #'GitLabHealth-Model-Entities'
}

{ #category : #meta }
GLHCommit class >> annotation [

	<FMClass: #Commit super: #GLHEntity>
	<package: #'GitLabHealth-Model'>
	<generated>
	^self
]

{ #category : #accessing }
GLHCommit >> author_email [

	<FMProperty: #author_email type: #String>
	<generated>
	^ author_email
]

{ #category : #accessing }
GLHCommit >> author_email: anObject [
	<generated>
	author_email := anObject
]

{ #category : #accessing }
GLHCommit >> author_name [

	<FMProperty: #author_name type: #String>
	<generated>
	^ author_name
]

{ #category : #accessing }
GLHCommit >> author_name: anObject [
	<generated>
	author_name := anObject
]

{ #category : #accessing }
GLHCommit >> authored_date [

	<FMProperty: #authored_date type: #Object>
	<generated>
	^ authored_date
]

{ #category : #accessing }
GLHCommit >> authored_date: anObject [
	<generated>
	authored_date := anObject
]

{ #category : #accessing }
GLHCommit >> branch [
	"Relation named: #branch type: #GLHBranch opposite: #commits"

	<generated>
	<container>
	^ branch
]

{ #category : #accessing }
GLHCommit >> branch: anObject [

	<generated>
	branch := anObject
]

{ #category : #navigation }
GLHCommit >> branchGroup [
	<generated>
	<navigation: 'Branch'>
	^ MooseSpecializedGroup with: self branch
]

{ #category : #accessing }
GLHCommit >> committed_date [

	<FMProperty: #committed_date type: #Object>
	<generated>
	^ committed_date
]

{ #category : #accessing }
GLHCommit >> committed_date: anObject [
	<generated>
	committed_date := anObject
]

{ #category : #accessing }
GLHCommit >> committer_email [

	<FMProperty: #committer_email type: #String>
	<generated>
	^ committer_email
]

{ #category : #accessing }
GLHCommit >> committer_email: anObject [
	<generated>
	committer_email := anObject
]

{ #category : #accessing }
GLHCommit >> committer_name [

	<FMProperty: #committer_name type: #String>
	<generated>
	^ committer_name
]

{ #category : #accessing }
GLHCommit >> committer_name: anObject [
	<generated>
	committer_name := anObject
]

{ #category : #accessing }
GLHCommit >> created_at [

	<FMProperty: #created_at type: #Object>
	<generated>
	^ created_at
]

{ #category : #accessing }
GLHCommit >> created_at: anObject [
	<generated>
	created_at := anObject
]

{ #category : #accessing }
GLHCommit >> id [

	<FMProperty: #id type: #String>
	<generated>
	^ id
]

{ #category : #accessing }
GLHCommit >> id: anObject [
	<generated>
	id := anObject
]

{ #category : #accessing }
GLHCommit >> message [

	<FMProperty: #message type: #String>
	<generated>
	^ message
]

{ #category : #accessing }
GLHCommit >> message: anObject [
	<generated>
	message := anObject
]

{ #category : #accessing }
GLHCommit >> repository [
	"Relation named: #repository type: #GLHRepository opposite: #commits"

	<generated>
	<container>
	^ repository
]

{ #category : #accessing }
GLHCommit >> repository: anObject [

	<generated>
	repository := anObject
]

{ #category : #navigation }
GLHCommit >> repositoryGroup [
	<generated>
	<navigation: 'Repository'>
	^ MooseSpecializedGroup with: self repository
]

{ #category : #accessing }
GLHCommit >> short_id [

	<FMProperty: #short_id type: #String>
	<generated>
	^ short_id
]

{ #category : #accessing }
GLHCommit >> short_id: anObject [
	<generated>
	short_id := anObject
]

{ #category : #accessing }
GLHCommit >> title [

	<FMProperty: #title type: #String>
	<generated>
	^ title
]

{ #category : #accessing }
GLHCommit >> title: anObject [
	<generated>
	title := anObject
]

{ #category : #accessing }
GLHCommit >> web_url [

	<FMProperty: #web_url type: #String>
	<generated>
	^ web_url
]

{ #category : #accessing }
GLHCommit >> web_url: anObject [
	<generated>
	web_url := anObject
]
