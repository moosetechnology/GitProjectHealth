"
A GitLab User

## Relations
======================

### Children
| Relation | Origin | Opposite | Type | Comment |
|---|
| `commits` | `GLHUser` | `commitCreator` | `GLHCommit` | |
| `jobs` | `GLHUser` | `user` | `GLHJob` | |

### Other
| Relation | Origin | Opposite | Type | Comment |
|---|
| `approcheMergeRequests` | `GLHUser` | `approved_by` | `GLHMergeRequest` | |
| `assignedMergeRequests` | `GLHUser` | `assignees` | `GLHMergeRequest` | |
| `closedMergeRequests` | `GLHUser` | `closed_by` | `GLHMergeRequest` | |
| `contributedProjects` | `GLHUser` | `contributors` | `GLHProject` | |
| `createdMergeRequests` | `GLHUser` | `author` | `GLHMergeRequest` | |
| `createdProjects` | `GLHUser` | `creator` | `GLHProject` | |
| `currentlyAssignedMergeRequest` | `GLHUser` | `assignee` | `GLHMergeRequest` | |
| `mergerOfMergeRequests` | `GLHUser` | `merged_by` | `GLHMergeRequest` | |
| `reviewedMergeResquest` | `GLHUser` | `reviewers` | `GLHMergeRequest` | |
| `usedMerges` | `GLHUser` | `merge_user` | `GLHMergeRequest` | |


## Properties
======================

| Name | Type | Default value | Comment |
|---|
| `avatar_url` | `String` | nil | |
| `bio` | `String` | nil | |
| `bot` | `String` | nil | |
| `commit_email` | `String` | nil | |
| `created_at` | `String` | nil | |
| `email` | `String` | nil | |
| `followers` | `String` | nil | |
| `following` | `String` | nil | |
| `id` | `Number` | nil | |
| `job_title` | `String` | nil | |
| `linkedin` | `String` | nil | |
| `location` | `String` | nil | |
| `name` | `String` | nil | Basic name of the entity, not full reference.|
| `name` | `String` | nil | |
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
		'#approcheMergeRequests => FMMany type: #GLHMergeRequest opposite: #approved_by',
		'#assignedMergeRequests => FMMany type: #GLHMergeRequest opposite: #assignees',
		'#avatar_url => FMProperty',
		'#bio => FMProperty',
		'#bot => FMProperty',
		'#closedMergeRequests => FMMany type: #GLHMergeRequest opposite: #closed_by',
		'#commit_email => FMProperty',
		'#commits => FMMany type: #GLHCommit opposite: #commitCreator',
		'#contributedProjects => FMMany type: #GLHProject opposite: #contributors',
		'#createdMergeRequests => FMMany type: #GLHMergeRequest opposite: #author',
		'#createdProjects => FMMany type: #GLHProject opposite: #creator',
		'#created_at => FMProperty',
		'#currentlyAssignedMergeRequest => FMMany type: #GLHMergeRequest opposite: #assignee',
		'#email => FMProperty',
		'#followers => FMProperty',
		'#following => FMProperty',
		'#id => FMProperty',
		'#job_title => FMProperty',
		'#jobs => FMMany type: #GLHJob opposite: #user',
		'#linkedin => FMProperty',
		'#location => FMProperty',
		'#mergerOfMergeRequests => FMMany type: #GLHMergeRequest opposite: #merged_by',
		'#name => FMProperty',
		'#organization => FMProperty',
		'#pronouns => FMProperty',
		'#public_email => FMProperty',
		'#reviewedMergeResquest => FMMany type: #GLHMergeRequest opposite: #reviewers',
		'#skype => FMProperty',
		'#state => FMProperty',
		'#twitter => FMProperty',
		'#usedMerges => FMMany type: #GLHMergeRequest opposite: #merge_user',
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
GLHUser >> addApprocheMergeRequest: anObject [
	<generated>
	^ self approcheMergeRequests add: anObject
]

{ #category : #adding }
GLHUser >> addAssignedMergeRequest: anObject [
	<generated>
	^ self assignedMergeRequests add: anObject
]

{ #category : #adding }
GLHUser >> addClosedMergeRequest: anObject [
	<generated>
	^ self closedMergeRequests add: anObject
]

{ #category : #adding }
GLHUser >> addCommit: anObject [
	<generated>
	^ self commits add: anObject
]

{ #category : #adding }
GLHUser >> addContributedProject: anObject [
	<generated>
	^ self contributedProjects add: anObject
]

{ #category : #adding }
GLHUser >> addCreatedMergeRequest: anObject [
	<generated>
	^ self createdMergeRequests add: anObject
]

{ #category : #adding }
GLHUser >> addCreatedProject: anObject [
	<generated>
	^ self createdProjects add: anObject
]

{ #category : #adding }
GLHUser >> addCurrentlyAssignedMergeRequest: anObject [
	<generated>
	^ self currentlyAssignedMergeRequest add: anObject
]

{ #category : #adding }
GLHUser >> addJob: anObject [
	<generated>
	^ self jobs add: anObject
]

{ #category : #adding }
GLHUser >> addMergerOfMergeRequest: anObject [
	<generated>
	^ self mergerOfMergeRequests add: anObject
]

{ #category : #adding }
GLHUser >> addReviewedMergeResquest: anObject [
	<generated>
	^ self reviewedMergeResquest add: anObject
]

{ #category : #adding }
GLHUser >> addUsedMerge: anObject [
	<generated>
	^ self usedMerges add: anObject
]

{ #category : #accessing }
GLHUser >> approcheMergeRequests [
	"Relation named: #approcheMergeRequests type: #GLHMergeRequest opposite: #approved_by"

	<generated>
	^ approcheMergeRequests
]

{ #category : #accessing }
GLHUser >> approcheMergeRequests: anObject [

	<generated>
	approcheMergeRequests value: anObject
]

{ #category : #accessing }
GLHUser >> assignedMergeRequests [
	"Relation named: #assignedMergeRequests type: #GLHMergeRequest opposite: #assignees"

	<generated>
	^ assignedMergeRequests
]

{ #category : #accessing }
GLHUser >> assignedMergeRequests: anObject [

	<generated>
	assignedMergeRequests value: anObject
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
GLHUser >> closedMergeRequests [
	"Relation named: #closedMergeRequests type: #GLHMergeRequest opposite: #closed_by"

	<generated>
	<derived>
	^ closedMergeRequests
]

{ #category : #accessing }
GLHUser >> closedMergeRequests: anObject [

	<generated>
	closedMergeRequests value: anObject
]

{ #category : #accessing }
GLHUser >> commit_email [

	<FMProperty: #commit_email type: #String>
	<generated>
	^ commit_email
]

{ #category : #accessing }
GLHUser >> commit_email: anObject [
	<generated>
	commit_email := anObject
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
GLHUser >> contributedProjects [
	"Relation named: #contributedProjects type: #GLHProject opposite: #contributors"

	<generated>
	^ contributedProjects
]

{ #category : #accessing }
GLHUser >> contributedProjects: anObject [

	<generated>
	contributedProjects value: anObject
]

{ #category : #accessing }
GLHUser >> createdMergeRequests [
	"Relation named: #createdMergeRequests type: #GLHMergeRequest opposite: #author"

	<generated>
	<derived>
	^ createdMergeRequests
]

{ #category : #accessing }
GLHUser >> createdMergeRequests: anObject [

	<generated>
	createdMergeRequests value: anObject
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
GLHUser >> currentlyAssignedMergeRequest [
	"Relation named: #currentlyAssignedMergeRequest type: #GLHMergeRequest opposite: #assignee"

	<generated>
	<derived>
	^ currentlyAssignedMergeRequest
]

{ #category : #accessing }
GLHUser >> currentlyAssignedMergeRequest: anObject [

	<generated>
	currentlyAssignedMergeRequest value: anObject
]

{ #category : #accessing }
GLHUser >> email [

	<FMProperty: #email type: #String>
	<generated>
	^ email
]

{ #category : #accessing }
GLHUser >> email: anObject [
	<generated>
	email := anObject
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
GLHUser >> jobs [
	"Relation named: #jobs type: #GLHJob opposite: #user"

	<generated>
	<derived>
	^ jobs
]

{ #category : #accessing }
GLHUser >> jobs: anObject [

	<generated>
	jobs value: anObject
]

{ #category : #navigation }
GLHUser >> jobsGroup [
	<generated>
	<navigation: 'Jobs'>
	^ MooseSpecializedGroup withAll: self jobs asSet
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
GLHUser >> mergerOfMergeRequests [
	"Relation named: #mergerOfMergeRequests type: #GLHMergeRequest opposite: #merged_by"

	<generated>
	<derived>
	^ mergerOfMergeRequests
]

{ #category : #accessing }
GLHUser >> mergerOfMergeRequests: anObject [

	<generated>
	mergerOfMergeRequests value: anObject
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
GLHUser >> reviewedMergeResquest [
	"Relation named: #reviewedMergeResquest type: #GLHMergeRequest opposite: #reviewers"

	<generated>
	^ reviewedMergeResquest
]

{ #category : #accessing }
GLHUser >> reviewedMergeResquest: anObject [

	<generated>
	reviewedMergeResquest value: anObject
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
GLHUser >> usedMerges [
	"Relation named: #usedMerges type: #GLHMergeRequest opposite: #merge_user"

	<generated>
	<derived>
	^ usedMerges
]

{ #category : #accessing }
GLHUser >> usedMerges: anObject [

	<generated>
	usedMerges value: anObject
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
