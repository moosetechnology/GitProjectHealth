Class {
	#name : #BitBucketModelImporter,
	#superclass : #GPModelImporter,
	#instVars : [
		'bitBucketApi',
		'withCommitDiffs',
		'withInitialCommits',
		'userCatalogue'
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

{ #category : #equality }
BitBucketModelImporter >> blockOnIdEquality [

	^ [ :existing :new | existing id = new id ]
]

{ #category : #'private - api' }
BitBucketModelImporter >> completeImportProject: aGLHProject [

	aGLHProject repository: GLHRepository new.
	self glhModel add: aGLHProject repository.
	"TODO: import repository"
	^ aGLHProject
]

{ #category : #'private - api' }
BitBucketModelImporter >> getContributionFromDiffs: diffs [

	| contribution |
	contribution := {
		                ('additions' -> 0).
		                ('deletions' -> 0) } asDictionary.

	diffs do: [ :diff |
		| hunks segments |
		hunks := diff at: #hunks ifAbsent: Array new.

		hunks do: [ :hunk |
			| addedSegment removedSegment |
			segments := hunk at: #segments.

			addedSegment := segments
				                detect: [ :segment |
				                (segment at: #type) = 'ADDED' ]
				                ifNone: [ nil ].
			removedSegment := segments
				                  detect: [ :segment |
				                  (segment at: #type) = 'REMOVED' ]
				                  ifNone: [ nil ].

			addedSegment ifNotNil: [
				contribution
					at: #additions
					put:
					(contribution at: #additions) + (addedSegment at: #lines) size ].
			removedSegment ifNotNil: [
				contribution
					at: #deletions
					put:
					(contribution at: #deletions) + (removedSegment at: #lines) size ] ] ].

	^ contribution
]

{ #category : #api }
BitBucketModelImporter >> importCommitsOfProject: aGLHProject since: since until: until [

	| commits |
	commits := bitBucketApi
		           commitsOfRepo: aGLHProject id
		           inProject: aGLHProject group id
		           since: since
		           until: until.

	commits := commits collect: [ :commit |
		           | glhCommit commitDiffs contribution |
		           glhCommit := self parseCommitIntoGLHCommit: commit.
		commitDiffs :=  self bitBucketApi diffsOfCommit: glhCommit id inRepo: aGLHProject id inProject: aGLHProject group id.
		          
		           contribution := self getContributionFromDiffs:
			                           (commitDiffs at: #diffs).
		           glhCommit additions: (contribution at: #additions).
		           glhCommit deletions: (contribution at: #deletions).
		           glhCommit ].

	aGLHProject repository commits: commits.
	self glhModel addAll: commits unless: self blockOnIdEquality.

	^ commits
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
			                        since: Date today - 10 days
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
					                             = aGLHUser username ]
					                             ifFound: [ true ]
					                             ifNone: [ false ] ] ].

	"Transform user repositories in GLHProject"
	userProjects := userRepositories collect: [ :repoCommits |
		                | repo project |
		                repo := repoCommits key.
		                project := repo at: #project.

		                (self glhModel allWithType: GLHProject)
			                detect: [ :glhProject |
			                glhProject id = (project at: #key) ]
			                ifFound: [ :glhProject | glhProject ]
			                ifNone: [
				                | glhProject |
				                glhProject := self parseRepoIntoGLHProject: repo.
				                glhModel add: glhProject.
				                glhProject ] ].

	aGLHUser contributedProjects: userProjects.

	^ userProjects
]

{ #category : #api }
BitBucketModelImporter >> importCreatorOfCommit: aGLHCommit [

	| creator |
	(self glhModel allWithType: GLHUser)
		detect: [ :user | user username = aGLHCommit author_name ]
		ifFound: [ :user |
			aGLHCommit commitCreator: user.
			^ user ].

	creator := self importUserByUsername: aGLHCommit author_name.
	aGLHCommit commitCreator: creator.
	^ creator
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

{ #category : #api }
BitBucketModelImporter >> importUserByUsername: username [

	| users user glhUser |
	users := self bitBucketApi usersByUsername: username.
	
	users ifEmpty: [ ^nil ].

	user := users first.

	glhUser := self parseUserIntoGLHUser: user.

	self glhModel add: glhUser unless: [ :nu :ou | nu id = ou id ].
	^ glhUser
]

{ #category : #parsing }
BitBucketModelImporter >> parseCommitIntoGLHCommit: commitDictionary [

	| author committer |

	author := commitDictionary at: #author.
	committer := commitDictionary at: #committer.

	^ GLHCommit new
		  id: (commitDictionary at: #id);
		  message: (commitDictionary at: #message);
		  author_email: (author at: #emailAddress);
		  author_name: (author at: #name);
		  authored_date: (DateAndTime fromUnixTime:
					   (commitDictionary at: #authorTimestamp) / 1000);
		  committed_date: (DateAndTime fromUnixTime:
					   (commitDictionary at: #committerTimestamp) / 1000);
		  committer_email: (committer at: #emailAddress);
		  committer_name: (committer at: #name)
]

{ #category : #parsing }
BitBucketModelImporter >> parseProjectIntoGLHGroup: projectRepository [

	^GLHGroup new
				                     name: (projectRepository at: #name);
				                     id: (projectRepository at: #key);
				                     description: (projectRepository at: #description).
]

{ #category : #parsing }
BitBucketModelImporter >> parseRepoIntoGLHProject: repositoryDictionary [

	| project group glhProject |
	project := repositoryDictionary at: #project.

	group := (self glhModel allWithType: GLHGroup)
		         detect: [ :glhGroup | glhGroup id = (project at: #key) ]
		         ifFound: [ :glhGroup | glhGroup ]
		         ifNone: [
			         | newGroup |
			         newGroup := self parseProjectIntoGLHGroup: project.
			         glhModel add: newGroup.
			         newGroup ].


	glhProject := GLHProject new
		              name: (repositoryDictionary at: #name);
		              id: (repositoryDictionary at: #slug);
						  repository: GLHRepository new;
		              group: group.

	group addProject: glhProject.

	^ glhProject
]

{ #category : #parsing }
BitBucketModelImporter >> parseUserIntoGLHUser: userDictionnary [

	^ GLHUser new name: (userDictionnary at: #displayName);
		public_email: (userDictionnary at: #emailAddress);
		id: (userDictionnary at: #id);
		username: (userDictionnary at: #name).
]

{ #category : #accessing }
BitBucketModelImporter >> userCatalogue [

	^ userCatalogue
]

{ #category : #accessing }
BitBucketModelImporter >> userCatalogue: anObject [

	userCatalogue := anObject
]

{ #category : #accessing }
BitBucketModelImporter >> withCommitDiffs [

	^ withCommitDiffs
]

{ #category : #accessing }
BitBucketModelImporter >> withCommitDiffs: anObject [

	withCommitDiffs := anObject
]

{ #category : #accessing }
BitBucketModelImporter >> withInitialCommits [

	^ withInitialCommits
]

{ #category : #accessing }
BitBucketModelImporter >> withInitialCommits: anObject [

	withInitialCommits := anObject
]
