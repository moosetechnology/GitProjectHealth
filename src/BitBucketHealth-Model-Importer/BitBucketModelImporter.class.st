Class {
	#name : #BitBucketModelImporter,
	#superclass : #GPModelImporter,
	#instVars : [
		'bitBucketApi'
	],
	#category : #'BitBucketHealth-Model-Importer'
}

{ #category : #accessing }
BitBucketModelImporter >> bitBucketApi [

	^ bitBucketApi
]

{ #category : #accessing }
BitBucketModelImporter >> bitBucketApi: anObject [

	bitBucketApi := anObject
]

{ #category : #'as yet unclassified' }
BitBucketModelImporter >> importContributedProjectsOfUser: aGLHUser [
	| projects |
	"get all projects"
	projects := self bitBucketApi projects

	"get all repos of projects"
	

	"get all commits of repo"

	"look if user is author of min one commit"
]

{ #category : #api }
BitBucketModelImporter >> importUser: accountId [

	| result reader glhUser |
	(self glhModel allWithType: GLHUser)
		detect: [ :user | user id = accountId ]
		ifFound: [ :user | ^ user ].

	result := self bitBucketApi user: accountId.
	reader := (NeoJSONReader on: result readStream) next.
	
	glhUser := GLHUser new
		id: accountId;
		created_at: ((reader at: #created_on) asDate); 
		username: (reader at:#display_name);
		name: (reader at:#display_name).
		
	glhModel add: glhUser.
		
	^glhUser
]
