"
A GitLab User

## Relations
======================

### Children
| Relation | Origin | Opposite | Type | Comment |
|---|
| `commits` | `GLHUser` | `commitCreator` | `GLHCommit` | |

### Other
| Relation | Origin | Opposite | Type | Comment |
|---|
| `createdProjects` | `GLHUser` | `creator` | `GLHProject` | |


## Properties
======================

| Name | Type | Default value | Comment |
|---|
| `avatar_url` | `String` | nil | |
| `bio` | `String` | nil | |
| `bot` | `String` | nil | |
| `created_at` | `String` | nil | |
| `followers` | `String` | nil | |
| `following` | `String` | nil | |
| `id` | `Number` | nil | |
| `job_title` | `String` | nil | |
| `linkedin` | `String` | nil | |
| `location` | `String` | nil | |
| `name` | `String` | nil | |
| `name` | `String` | nil | Basic name of the entity, not full reference.|
| `organization` | `String` | nil | |
| `pronouns` | `String` | nil | |
| `public_email` | `String` | nil | |
| `skype` | `String` | nil | |
| `state` | `String` | nil | |
| `twitter` | `String` | nil | |
| `username` | `String` | nil | |
| `web_url` | `String` | nil | |
| `website_url` | `String` | nil | |
| `work_information` | `String` | nil | |

"
Class {
	#name : #GLHUser,
	#superclass : #GLHEntity,
	#traits : 'FamixTNamedEntity',
	#classTraits : 'FamixTNamedEntity classTrait',
	#instVars : [
		'#avatar_url => FMProperty',
		'#bio => FMProperty',
		'#bot => FMProperty',
		'#commits => FMMany type: #GLHCommit opposite: #commitCreator',
		'#createdProjects => FMMany type: #GLHProject opposite: #creator',
		'#created_at => FMProperty',
		'#followers => FMProperty',
		'#following => FMProperty',
		'#id => FMProperty',
		'#job_title => FMProperty',
		'#linkedin => FMProperty',
		'#location => FMProperty',
		'#name => FMProperty',
		'#organization => FMProperty',
		'#pronouns => FMProperty',
		'#public_email => FMProperty',
		'#skype => FMProperty',
		'#state => FMProperty',
		'#twitter => FMProperty',
		'#username => FMProperty',
		'#web_url => FMProperty',
		'#website_url => FMProperty',
		'#work_information => FMProperty'
	],
	#category : #'GitLabHealth-Model-Entities'
}

{ #category : #meta }
GLHUser class >> annotation [

	<FMClass: #User super: #GLHEntity>
	<package: #'GitLabHealth-Model'>
	<generated>
	^ self
]

{ #category : #adding }
GLHUser >> addCommit: anObject [
	<generated>
	^ self commits add: anObject
]

{ #category : #adding }
GLHUser >> addCreatedProject: anObject [
	<generated>
	^ self createdProjects add: anObject
]

{ #category : #accessing }
GLHUser >> avatar_url [

	<FMProperty: #avatar_url type: #String>
	<generated>
	^ avatar_url
]

{ #category : #accessing }
GLHUser >> avatar_url: anObject [
	<generated>
	avatar_url := anObject
]

{ #category : #accessing }
GLHUser >> bio [

	<FMProperty: #bio type: #String>
	<generated>
	^ bio
]

{ #category : #accessing }
GLHUser >> bio: anObject [
	<generated>
	bio := anObject
]

{ #category : #accessing }
GLHUser >> bot [

	<FMProperty: #bot type: #String>
	<generated>
	^ bot
]

{ #category : #accessing }
GLHUser >> bot: anObject [
	<generated>
	bot := anObject
]

{ #category : #accessing }
GLHUser >> commits [
	"Relation named: #commits type: #GLHCommit opposite: #commitCreator"

	<generated>
	<derived>
	^ commits
]

{ #category : #accessing }
GLHUser >> commits: anObject [

	<generated>
	commits value: anObject
]

{ #category : #navigation }
GLHUser >> commitsGroup [
	<generated>
	<navigation: 'Commits'>
	^ MooseSpecializedGroup withAll: self commits asSet
]

{ #category : #accessing }
GLHUser >> createdProjects [
	"Relation named: #createdProjects type: #GLHProject opposite: #creator"

	<generated>
	<derived>
	^ createdProjects
]

{ #category : #accessing }
GLHUser >> createdProjects: anObject [

	<generated>
	createdProjects value: anObject
]

{ #category : #accessing }
GLHUser >> created_at [

	<FMProperty: #created_at type: #String>
	<generated>
	^ created_at
]

{ #category : #accessing }
GLHUser >> created_at: anObject [
	<generated>
	created_at := anObject
]

{ #category : #accessing }
GLHUser >> followers [

	<FMProperty: #followers type: #String>
	<generated>
	^ followers
]

{ #category : #accessing }
GLHUser >> followers: anObject [
	<generated>
	followers := anObject
]

{ #category : #accessing }
GLHUser >> following [

	<FMProperty: #following type: #String>
	<generated>
	^ following
]

{ #category : #accessing }
GLHUser >> following: anObject [
	<generated>
	following := anObject
]

{ #category : #accessing }
GLHUser >> id [

	<FMProperty: #id type: #Number>
	<generated>
	^ id
]

{ #category : #accessing }
GLHUser >> id: anObject [
	<generated>
	id := anObject
]

{ #category : #accessing }
GLHUser >> job_title [

	<FMProperty: #job_title type: #String>
	<generated>
	^ job_title
]

{ #category : #accessing }
GLHUser >> job_title: anObject [
	<generated>
	job_title := anObject
]

{ #category : #accessing }
GLHUser >> linkedin [

	<FMProperty: #linkedin type: #String>
	<generated>
	^ linkedin
]

{ #category : #accessing }
GLHUser >> linkedin: anObject [
	<generated>
	linkedin := anObject
]

{ #category : #accessing }
GLHUser >> location [

	<FMProperty: #location type: #String>
	<generated>
	^ location
]

{ #category : #accessing }
GLHUser >> location: anObject [
	<generated>
	location := anObject
]

{ #category : #accessing }
GLHUser >> name [

	<FMProperty: #name type: #String>
	<generated>
	^ name
]

{ #category : #accessing }
GLHUser >> name: anObject [
	<generated>
	name := anObject
]

{ #category : #accessing }
GLHUser >> organization [

	<FMProperty: #organization type: #String>
	<generated>
	^ organization
]

{ #category : #accessing }
GLHUser >> organization: anObject [
	<generated>
	organization := anObject
]

{ #category : #accessing }
GLHUser >> pronouns [

	<FMProperty: #pronouns type: #String>
	<generated>
	^ pronouns
]

{ #category : #accessing }
GLHUser >> pronouns: anObject [
	<generated>
	pronouns := anObject
]

{ #category : #accessing }
GLHUser >> public_email [

	<FMProperty: #public_email type: #String>
	<generated>
	^ public_email
]

{ #category : #accessing }
GLHUser >> public_email: anObject [
	<generated>
	public_email := anObject
]

{ #category : #accessing }
GLHUser >> skype [

	<FMProperty: #skype type: #String>
	<generated>
	^ skype
]

{ #category : #accessing }
GLHUser >> skype: anObject [
	<generated>
	skype := anObject
]

{ #category : #accessing }
GLHUser >> state [

	<FMProperty: #state type: #String>
	<generated>
	^ state
]

{ #category : #accessing }
GLHUser >> state: anObject [
	<generated>
	state := anObject
]

{ #category : #accessing }
GLHUser >> twitter [

	<FMProperty: #twitter type: #String>
	<generated>
	^ twitter
]

{ #category : #accessing }
GLHUser >> twitter: anObject [
	<generated>
	twitter := anObject
]

{ #category : #accessing }
GLHUser >> username [

	<FMProperty: #username type: #String>
	<generated>
	^ username
]

{ #category : #accessing }
GLHUser >> username: anObject [
	<generated>
	username := anObject
]

{ #category : #accessing }
GLHUser >> web_url [

	<FMProperty: #web_url type: #String>
	<generated>
	^ web_url
]

{ #category : #accessing }
GLHUser >> web_url: anObject [
	<generated>
	web_url := anObject
]

{ #category : #accessing }
GLHUser >> website_url [

	<FMProperty: #website_url type: #String>
	<generated>
	^ website_url
]

{ #category : #accessing }
GLHUser >> website_url: anObject [
	<generated>
	website_url := anObject
]

{ #category : #accessing }
GLHUser >> work_information [

	<FMProperty: #work_information type: #String>
	<generated>
	^ work_information
]

{ #category : #accessing }
GLHUser >> work_information: anObject [
	<generated>
	work_information := anObject
]
