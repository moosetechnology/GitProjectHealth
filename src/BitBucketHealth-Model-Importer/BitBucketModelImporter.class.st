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

{ #category : #api }
BitBucketModelImporter >> importContributedProjectsOfUser: aGLHUser [

	| projects repositories repositoriesCommits userRepositories userProjects |
	"get all projects"
	projects := self bitBucketApi projects.

	"get all repos of projects"
	repositories := projects flatCollect: [ :project |
		                self bitBucketApi repositoriesOfProject:
			                (project at: #key) ].


	"get all commits of repo"
	repositoriesCommits := repositories collect: [ :repository |
		                       repository -> (self bitBucketApi
			                        commitsOfRepo: (repository at: #slug)
			                        inProject:
			                        ((repository at: #project) at: #key)
			                        since: Date today - 7 days
			                        until: Date today) ].

	"look if user is author of min one commit"
	userRepositories := repositoriesCommits select: [ :repository |
		                    | repos |
		                    repos := repository value
			                             ifEmpty: [ false ]
			                             ifNotEmpty: [
				                             repository value
					                             detect: [ :commit |
					                             ((commit at: #author) at: #name)
					                             = aGLHUser name ]
					                             ifNone: [ false ] ].

		                    repos isNotEmpty ].

	"Transform user repositories in GLHProject"
	userProjects := userRepositories collect: [ :repoCommits |
		                | repo project group glhProject |
		                repo := repoCommits key.
		                project := repo at: #project.

		                group := (self glhModel allWithType: GLHGroup)
			                         detect: [ :glhGroup |
			                         glhGroup id = project at: #key ]
			                         ifFound: [ :glhGroup | glhGroup ]
			                         ifNone: [
				                         | newGroup |
				                         newGroup := GLHGroup new
					                                     name: (project at: #name);
					                                     id: (project at: #key);
					                                     description:
						                                     (project at: #description).
				                         glhModel add: newGroup.
				                         newGroup ].


		                glhProject :=GLHProject new
			                name: (repo at: #name);
			                id: (repo at: #slug);
			                group: group.
			
							group addProject: glhProject.
							glhProject
			
			 ].

	^userProjects
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
