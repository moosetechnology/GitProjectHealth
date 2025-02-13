Class {
	#name : #BitBucketModelImporter,
	#superclass : #GitModelImporter,
	#instVars : [
		'withInitialCommits'
	],
	#category : #'BitBucketHealth-Model-Importer'
}

{ #category : #accessing }
BitBucketModelImporter >> bitBucketApi [

	self
		deprecated: 'Use #repoApi instead'
		on: '7 October 2024'
		in:
		'Pharo-11.0.0+build.726.sha.aece1b5473acf3830a0e082c1bc3a15d4ff3522b (64 Bit)'.

	^ repoApi
]

{ #category : #accessing }
BitBucketModelImporter >> bitBucketApi: anObject [

	self
		deprecated: 'Use #repoApi: instead'
		on: '7 October 2024'
		in:
		'Pharo-11.0.0+build.726.sha.aece1b5473acf3830a0e082c1bc3a15d4ff3522b (64 Bit)'.

	repoApi := anObject
]

{ #category : #'import - projects' }
BitBucketModelImporter >> completeImportProject: aGLHProject [

	aGLHProject repository: GLHRepository new.
	self glhModel add: aGLHProject repository.
	"TODO: import repository"
	^ aGLHProject
]

{ #category : #commit }
BitBucketModelImporter >> completeImportedCommit: aCommit [ 
	
	('completing commit: ' , aCommit short_id printString) recordInfo.
	self importCreatorOfCommit: aCommit.

	self withCommitDiffs ifTrue: [
		| diffs |
		aCommit diffs ifEmpty: [
			diffs := self importDiffOfCommit: aCommit.
			self glhModel addAll: diffs unless: self blockForDiffEquality ] ].

	^ aCommit
]

{ #category : #'private - api' }
BitBucketModelImporter >> convertBitBucketDiffToGitDiff: response [

	| fromHash toHash sourceLine sourceSpan destinationLine destinationSpan result filePathSource filePathDestination |
	fromHash := (response at: 'fromHash') ifNil: ''.
	toHash := (response at: 'toHash') ifNil: ''.


	"Iterate over each diff in 'diffs'"
	result := (response at: #diffs) collect: [ :diff | "Extract file path, hashes"
		          | gitDiff hunks|
		          gitDiff := ''.
		          filePathSource := (diff at: 'source')
			                            ifNil: ''
			                            ifNotNil: [ :source |
			                            source at: 'toString' ].
		          filePathDestination := (diff at: 'destination')
			                                 ifNil: ''
			                                 ifNotNil: [ :destination |
			                                 destination at: 'toString' ].

		          "Build the diff header"
		          " gitDiff := gitDiff , 'diff --git a/', filePath, ' b/', filePath, String cr."
		          " gitDiff := gitDiff , 'index ', fromHash, '..', toHash, ' 100644', String cr."
		          gitDiff := gitDiff , '--- a/' , filePathSource , String cr.
		          gitDiff := gitDiff , '+++ b/' , filePathDestination
		                     , String cr.

		          "Iterate over hunks"
					 hunks := diff at: #hunks ifPresent: [ :value | value ]  ifAbsent: [ { } ]. 
		          hunks do: [ :hunk |
			          sourceLine := hunk at: 'sourceLine'.
			          sourceSpan := hunk at: 'sourceSpan'.
			          destinationLine := hunk at: 'destinationLine'.
			          destinationSpan := hunk at: 'destinationSpan'.

			          "Hunk header"
			          gitDiff := gitDiff
			                     , ('@@ -{1},{2} +{3},{4} @@' format: {
						                      sourceLine.
						                      sourceSpan.
						                      destinationLine.
						                      destinationSpan }) , String cr.

			          "Iterate over segments"
			          (hunk at: 'segments') do: [ :segment |
				          (segment at: 'lines') do: [ :line |
					          (segment at: 'type') = 'CONTEXT' ifTrue: [
						          gitDiff := gitDiff , (line at: 'line') , String cr ].
					          (segment at: 'type') = 'REMOVED' ifTrue: [
						          gitDiff := gitDiff , '-' , (line at: 'line')
						                     , String cr ].
					          (segment at: 'type') = 'ADDED' ifTrue: [
						          gitDiff := gitDiff , '+' , (line at: 'line')
						                     , String cr ] ] ] ].
		          GLHDiff new
			          diffString: gitDiff;
			          old_path: filePathSource;
			          new_path: filePathDestination ].

	^ result
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
BitBucketModelImporter >> importAndLoadLatestsCommitsOfProject: aGLHProject [

	| commits |
	self completeImportProject: aGLHProject.

	commits := self
		           importCommitsOfProject: aGLHProject
		           since: (Date today - 3 week) asDateAndTime
		           until: Date today asDateAndTime.
	commits do: [ :commit | self completeImportedCommit: commit ].
	
	self chainsCommitsFrom: commits.
	
	^ commits
]

{ #category : #'import - commits' }
BitBucketModelImporter >> importCommitsOfProject: aGLHProject since: since until: until [

	| commits |
	commits := self repoApi
		           commitsOfRepoProjectId: aGLHProject id
		           inProjectGroupId: aGLHProject group id
		           since: since
		           until: until.

	commits := commits collect: [ :commit |
		     
		           self parseCommitIntoGLHCommit: commit ofProject: aGLHProject.

		         ].


	commits := self glhModel
		           addAll: commits
		           unless: self blockOnIdEquality.
	^ aGLHProject repository commits
		  addAll: commits
		  unless: self blockOnIdEquality
]

{ #category : #'import - projects' }
BitBucketModelImporter >> importContributedProjectsOfUser: aGLHUser [

	| projects repositories repositoriesCommits userRepositories userProjects |
	"get all projects"
	projects := self repoApi projects.

	"get all repos of projects"
	repositories := projects flatCollect: [ :project |
		                self repoApi repositoryProjectsOfProjectGroupId:
			                (project at: #key) ].


	"get all commits of repo"
	repositoriesCommits := repositories collect: [ :repository |
		                       repository -> (self repoApi
			                        commitsOfRepoProjectId: (repository at: #slug)
			                        inProjectGroupId:
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

{ #category : #'import - commits' }
BitBucketModelImporter >> importDiffOfCommit: aCommit [

	| result diffsResult |
	aCommit diffs ifNotEmpty: [
		'Diff already importer: ' , aCommit short_id printString recordInfo.
		^ aCommit diffs ].
	('Import diff of commit: ' , aCommit short_id printString) recordInfo.
	result := self repoApi
		          diffsOfCommit: aCommit id
		          inRepoProjectId: aCommit repository project id
		          inProjectGroupId: aCommit repository project group id.

	diffsResult := self convertBitBucketDiffToGitDiff: result.


	diffsResult := aCommit diffs
		               addAll: diffsResult
		               unless: self blockForDiffEquality.

	"changes are added into the model during the import"
	diffsResult do: [ :diff | self importDiffRangesForDiff: diff ].

	^ diffsResult
]

{ #category : #'import - merge-requests' }
BitBucketModelImporter >> importMergeRequestCommits: mergeRequest [

	| commits |
	commits := self repoApi
		           commitsOfPullRequest: mergeRequest id
		           ofRepoProjectId: mergeRequest project id
		           inProjectGroupId: mergeRequest project group id.

	commits := commits collect: [ :commit |
		           self parseCommitIntoGLHCommit: commit ofProject: mergeRequest project ].

	mergeRequest commits: commits.

	^ commits
]

{ #category : #'import - merge-requests' }
BitBucketModelImporter >> importMergeRequests: aGLHProject since: fromDate until: toDate [

	| pullRequests |
	pullRequests := self repoApi
		                pullRequestsOfRepoProjectId: aGLHProject id
		                inProjectGroupId: aGLHProject group id
		                since: fromDate
		                until: toDate.

	pullRequests := pullRequests collect: [ :pullRequest |
		                self parsePullRequestIntoGLPHEMergeRequest:
			                pullRequest ].

	pullRequests := self glhModel addAll: pullRequests unless: self blockOnIdEquality.

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

	activities := self repoApi
		              activitiesOfPullRequest: mergeRequest id
		              inRepoProjectId: mergeRequest project id
		              ofProjectGroupId: mergeRequest project group id.

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

	 

	^ self userCatalogue collectUsernames at: username ifAbsent: [
		|users glhUser user|
		
		users := self repoApi usersByUsername: username.
		users ifEmpty: [ ^ nil ].
		user := users first.

		glhUser := self parseUserIntoGLHUser: user.
		self glhModel add: glhUser unless: self blockOnIdEquality.
		self userCatalogue addUser: glhUser withName: username. 
		glhUser
		 ].
	
	
]

{ #category : #parsing }
BitBucketModelImporter >> parseCommitIntoGLHCommit: commitDictionary ofProject: aGLHProject [

	| author committer parentIds commitDiffs contribution |
	author := commitDictionary at: #author.
	committer := commitDictionary at: #committer.

	parentIds := (commitDictionary at: #parents) collect: [ :parent |
		             parent at: #id ].

	commitDiffs := self repoApi
		               diffsOfCommit: (commitDictionary at: #id)
		               inRepoProjectId: aGLHProject id
		               inProjectGroupId: aGLHProject group id.

	contribution := self getContributionFromDiffs:
		                (commitDiffs at: #diffs).

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
		  parent_ids: parentIds;
		  additions: (contribution at: #additions);
		  deletions: (contribution at: #deletions)
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


	glpheMergeRequest := GLHMergeRequest new
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
BitBucketModelImporter >> withInitialCommits [

	^ withInitialCommits
]

{ #category : #accessing }
BitBucketModelImporter >> withInitialCommits: anObject [

	withInitialCommits := anObject
]
