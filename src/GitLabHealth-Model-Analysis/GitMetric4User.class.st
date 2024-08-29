Class {
	#name : #GitMetric4User,
	#superclass : #GitMetric,
	#instVars : [
		'itsCommits',
		'itsMergeRequests',
		'emailDomain'
	],
	#category : #'GitLabHealth-Model-Analysis'
}

{ #category : #churn }
GitMetric4User >> foundSuccessorOf: userCommits andCompleteImportForMax: commitLimit [

	| analyzingCommits i size |
	analyzingCommits := Set new.
	glhImporter withCommitDiffs: true.

	userCommits do: [ :c |
		GitAnalyzer new
			visitChildCommits: c childCommits
			toStoreThemIn: analyzingCommits
			upto: commitLimit ].

	i := 0.
	size := analyzingCommits size.
	analyzingCommits do: [ :c |
		('import complete commits  [' , (i := i + 1) printString , '/'
		 , size printString , ']') recordInfo.
		glhImporter completeImportedCommit: c ].

	^ analyzingCommits
]

{ #category : #initialization }
GitMetric4User >> initialize [

	user := GLHUser new.
	itsCommits := Dictionary new.
	itsMergeRequests := Dictionary new.

	emailDomain := '@generic-domain.com'
]

{ #category : #accessing }
GitMetric4User >> itsProjects: projects [
	itsProjects := projects .
]

{ #category : #churn }
GitMetric4User >> loadCommitOfProjects: aCollection since: aTimespan [
	|commits|
	
	commits := (aCollection collect: [ :id |
		 glhImporter
			importCommitsOProject: (itsProjects at: id)
			since: aTimespan
			until: nil ]) flattened.

	commits do: [ :commit |
		glhImporter completeImportedCommit: commit. 
		 ].

	^ self userCommits.
]

{ #category : #loading }
GitMetric4User >> loadCommitsSince: since until: until [

	| cacheSymbol allCommits userCommits |
	itsProjects ifNil: [ self loadProjects ].

	glhImporter withCommitDiffs: false.

	cacheSymbol := self
		               cacheSymbolFor: GLHCommit
		               since: since
		               until: until.

	"download commits unless project cache is not empty"
	allCommits := itsProjects collect: [ :project |
		              project repository cacheAt: cacheSymbol ifAbsentPut: [
			              | foundCommits |
			              foundCommits := glhImporter
				                              importCommitsOProject: project
				                              since: since
				                              until: until.
			              foundCommits ] ].

	allCommits := allCommits flatten.
	allCommits do: [ :commit | glhImporter importCreatorOfCommit: commit ].
	glhImporter chainsCommitsFrom: allCommits.
	glhImporter withCommitDiffs: true.

	^ userCommits := allCommits reject: [ :commit |
		                 commit commitCreator ~= user ]
]

{ #category : #loading }
GitMetric4User >> loadCompleteCommitsSince: since until: until [

	| commits |
	commits := self loadCommitsSince: since until: until.
	commits do: [ :commit | glhImporter completeImportedCommit: commit ].
	^commits
	
	 
]

{ #category : #loading }
GitMetric4User >> loadCompleteMergeRequestsSince: since until: until [

	| mergeRequests |
	mergeRequests := self loadMergeRequestsSince: since until: until.

	mergeRequests do: [ :mergeRequest |
		glhImporter importMergeResquestMerger: mergeRequest ].
	
	^mergeRequests
]

{ #category : #loading }
GitMetric4User >> loadMergeRequestsSince: since until: until [
	
	| cacheSymbol mergeRequests userMergeRequests |
	itsProjects ifNil: [ self loadProjects ].
	glhImporter withCommitDiffs: false.
	cacheSymbol := self
		               cacheSymbolFor: GLPHEMergeRequest
		               since: since
		               until: until.

	mergeRequests := itsProjects collect: [ :project |
		                 | mr |
		                 project cacheAt: cacheSymbol ifAbsentPut: [
			                 mr := glhImporter
				                       importMergeRequests: project
				                       since: since
				                       until: until.
			                 mr ] ].

	mergeRequests := mergeRequests flattened.
	glhImporter withCommitDiffs: true.

	mergeRequests do: [ :mr | glhImporter importMergeResquestAuthor: mr ].

	userMergeRequests := mergeRequests select: [ :mergeRequest |
		                     mergeRequest author = user ].
	^ userMergeRequests
]

{ #category : #loading }
GitMetric4User >> loadMergeRequestsWithJiraIssueSince: since until: until [

	| email |
	itsMergeRequests := self loadMergeRequestsSince: since until: until.

	email := self userEmail.

	jiraImporter importAllCurrentAndPastIssuesOf: email.

	GPJCConnector new
		gpModel: glhImporter glhModel;
		jiraModel: jiraImporter model;
		connect.

	^ itsMergeRequests select: [ :mergeRequest |
		  mergeRequest jiraIssue isNotNil ]
]

{ #category : #loading }
GitMetric4User >> loadProjects [

	itsProjects ifNotNil: [ ^ itsProjects ].

	itsProjects := glhImporter importContributedProjectsOfUser: user.

	itsProjects do: [ :project |
		glhImporter completeImportProject: project ].

	^ itsProjects
]

{ #category : #accessing }
GitMetric4User >> user [
	^ user
]

{ #category : #accessing }
GitMetric4User >> user: anUser [
	user := anUser. 
]

{ #category : #accessing }
GitMetric4User >> userCommits [
	^ user commits
]

{ #category : #email }
GitMetric4User >> userEmail [
	"overide this method to adapt on your situation"
 
	^ ('' join: {
			          user username.
			          emailDomain }) asLowercase.
]

{ #category : #email }
GitMetric4User >> withUserEmailDomain: aEmailDomain [
	emailDomain :=  aEmailDomain. 
]
