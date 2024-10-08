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

{ #category : #'import - commits' }
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
		           commitDiffs := self bitBucketApi
			                          diffsOfCommit: glhCommit id
			                          inRepo: aGLHProject id
			                          inProject: aGLHProject group id.

		           contribution := self getContributionFromDiffs:
			                           (commitDiffs at: #diffs).
		           glhCommit additions: (contribution at: #additions).
		           glhCommit deletions: (contribution at: #deletions).
		           glhCommit ].

	aGLHProject repository commits: commits.
	self glhModel addAll: commits unless: self blockOnIdEquality.

	^ commits
]

{ #category : #'import - projects' }
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
			                        since: DateAndTime now - 10 days
			                        until: DateAndTime now) ].


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

{ #category : #'import - commits' }
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

{ #category : #'import - merge-requests' }
BitBucketModelImporter >> importMergeRequestCommits: mergeRequest [

	| commits |
	commits := self bitBucketApi
		           commitsOfPullRequest: mergeRequest id
		           ofRepo: mergeRequest project id
		           inProject: mergeRequest project group id.

	commits := commits collect: [ :commit |
		           self parseCommitIntoGLHCommit: commit ].

	mergeRequest commits: commits.

	^ commits
]

{ #category : #'import - merge-requests' }
BitBucketModelImporter >> importMergeRequests: aGLHProject since: fromDate until: toDate [

	| pullRequests |
	pullRequests := bitBucketApi
		                pullRequestsOfRepo: aGLHProject id
		                inProject: aGLHProject group id
		                since: fromDate
		                until: toDate.

	pullRequests := pullRequests collect: [ :pullRequest |
		                self parsePullRequestIntoGLPHEMergeRequest:
			                pullRequest ].

	self glhModel addAll: pullRequests unless: self blockOnIdEquality.

	^ pullRequests
]

{ #category : #'import - merge-requests' }
BitBucketModelImporter >> importMergeResquestAuthor: mergeRequest [
	mergeRequest author ifNotNil: [ ^mergeRequest ]
]

{ #category : #'import - merge-requests' }
BitBucketModelImporter >> importMergeResquestMerger: mergeRequest [

	| activities mergeActivity mergeUser |
	mergeRequest merge_user ifNotNil: [ ^ mergeRequest merge_user ].
	mergeRequest state = 'merged' ifFalse: [ ^ nil ].

	activities := self bitBucketApi
		              activitiesOfPullRequest: mergeRequest id
		              inRepo: mergeRequest project id
		              ofProject: mergeRequest project group id.

	mergeActivity := activities detect: [ :activity |
		                 (activity at: #action) = 'MERGED' ].

	mergeUser := mergeActivity at: #user.

	mergeUser := (glhModel allWithType: GLHUser)
		             detect: [ :user | user id = (mergeUser at: #id) ]
		             ifFound: [ :user | user ]
		             ifNone: [
			             | glhUser |
			             glhUser := self parseUserIntoGLHUser: mergeUser.
			             glhModel add: glhUser.
			             glhUser ].

	mergeRequest merge_user: mergeUser.
	^ mergeUser
]

{ #category : #'import - users' }
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

	| author committer parentIds |
	author := commitDictionary at: #author.
	committer := commitDictionary at: #committer.

	parentIds := (commitDictionary at: #parents) collect: [ :parent |
		             parent at: #id ].

	^ GLHCommit new
		  id: (commitDictionary at: #id);
		  message: (commitDictionary at: #message);
		  author_email: (author at: #emailAddress);
		  author_name: (author at: #name);
		  authored_date: (DateAndTime fromUnixTime:
					   (commitDictionary at: #authorTimestamp) / 1000);
		  created_at: (DateAndTime fromUnixTime:
					   (commitDictionary at: #authorTimestamp) / 1000);
		  committed_date: (DateAndTime fromUnixTime:
					   (commitDictionary at: #committerTimestamp) / 1000);
		  committer_email: (committer at: #emailAddress);
		  committer_name: (committer at: #name);
		  parent_ids: parentIds
]

{ #category : #parsing }
BitBucketModelImporter >> parseProjectIntoGLHGroup: projectRepository [

	^GLHGroup new
				                     name: (projectRepository at: #name);
				                     id: (projectRepository at: #key);
				                     description: (projectRepository at: #description).
]

{ #category : #parsing }
BitBucketModelImporter >> parsePullRequestIntoGLPHEMergeRequest: pullRequestDictionary [

	| repository project toRef fromRef glpheMergeRequest author state reviewers |
	toRef := pullRequestDictionary at: #toRef.
	fromRef := pullRequestDictionary at: #fromRef.
	
	reviewers := pullRequestDictionary at: #reviewers.
	reviewers := reviewers collect: [ :reviewer | 
		|reviewerUser|
		reviewerUser := reviewer at: #user.
		(self glhModel allWithType: GLHUser) detect: [ :user | user id = (reviewerUser at: #id) ]	 ifFound: [ :user | user ] ifNone: [ 
			|glhUser|
			glhUser := self parseUserIntoGLHUser: reviewerUser.
			glhModel  add: glhUser.
			glhUser.		
		]
		
	].

	repository := toRef at: #repository.
	project := (self glhModel allWithType: GLHProject)
		           detect: [ :glhProject |
		           glhProject id = (repository at: #id) ]
		           ifFound: [ :glhProject | glhProject ]
		           ifNone: [
			           project := self parseRepoIntoGLHProject: repository.
			           self glhModel add: project.
			           project ].


	author := pullRequestDictionary at: #author.
	author := (self glhModel allWithType: GLHUser)
		          detect: [ :user | user id = ((author at: #user) at: #id) ]
		          ifFound: [ :user | user ]
		          ifNone: [
		          self importUserByUsername:
			          ((author at: #user) at: #displayName) ].


	glpheMergeRequest := GLPHEMergeRequest new
		                     name: (pullRequestDictionary at: #title);
		                     title: (pullRequestDictionary at: #title);
		                     id: (pullRequestDictionary at: #id);
		                     project: project;
		                     project_id: project id;
		                     target_branch: (toRef at: #id);
		                     target_project_id:
			                     ((toRef at: #repository) at: #id);
		                     source_branch: (fromRef at: #id);
		                     target_project_id:
			                     ((fromRef at: #repository) at: #id);
		                     updated_at: (DateAndTime fromUnixTime:
					                      (pullRequestDictionary at: #updatedDate)
					                      / 1000);
		                     created_at: (DateAndTime fromUnixTime:
					                      (pullRequestDictionary at: #createdDate)
					                      / 1000);
		                     author: author.

	"STATE"
	state := pullRequestDictionary at: #state.
	state = 'OPEN' ifTrue: [ glpheMergeRequest state: 'opened' ].
	state = 'MERGED' ifTrue: [
		glpheMergeRequest state: 'merged'.
		glpheMergeRequest merged_at: (DateAndTime fromUnixTime:
				 (pullRequestDictionary at: #closedDate) / 1000) ].

	state = 'DECLINED' ifTrue: [
		glpheMergeRequest state: 'closed'.
		glpheMergeRequest closed_at: (DateAndTime fromUnixTime:
				 (pullRequestDictionary at: #closedDate) / 1000) ].

	^ glpheMergeRequest
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
