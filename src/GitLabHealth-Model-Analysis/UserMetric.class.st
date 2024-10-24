Class {
	#name : #UserMetric,
	#superclass : #Metric,
	#instVars : [
		'user',
		'userCommits',
		'userMergeRequests',
		'emailDomain'
	],
	#category : #'GitLabHealth-Model-Analysis'
}

{ #category : #utils }
UserMetric >> cacheSymbolFor: anEntityType since: since until: until [

	^ (anEntityType printString , ' since ' , since printString , ' to '
	   , until printString) asSymbol
]

{ #category : #calculating }
UserMetric >> calculate [

	^ self subclassResponsibility
]

{ #category : #accessing }
UserMetric >> description [

	^ self subclassResponsibility
]

{ #category : #accessing }
UserMetric >> emailDomain: anObject [

	emailDomain := anObject
]

{ #category : #churn }
UserMetric >> foundSuccessorOf: commits andCompleteImportForMax: commitLimit [

	| analyzingCommits i size |
	analyzingCommits := Set new.
	glhImporter withCommitDiffs: true.

	commits do: [ :c |
		GitAnalyzer new
			visitChildCommits: c childCommits
			toStoreThemIn: analyzingCommits
			upto: commitLimit ].

	i := 0.
	size := analyzingCommits size.
	analyzingCommits do: [ :c |

		glhImporter completeImportedCommit: c ].

	^ analyzingCommits
]

{ #category : #initialization }
UserMetric >> initialize [
	over := Date
]

{ #category : #loading }
UserMetric >> load [

	^ self subclassResponsibility
]

{ #category : #loading }
UserMetric >> loadCompleteMergeRequestsSince: since until: until [

	| mergeRequests |
	mergeRequests := self
		                 loadMergeRequestsSince: since until: until.

	mergeRequests do: [ :mergeRequest |
		glhImporter importMergeResquestMerger: mergeRequest.
		glhImporter importMergeRequestCommits: mergeRequest ].

	^ mergeRequests
]

{ #category : #loading }
UserMetric >> loadMergeRequestsSince: since until: until [

	| cacheSymbol mergeRequests |
	glhImporter withCommitDiffs: false.
	cacheSymbol := self
		               cacheSymbolFor: GLPHEMergeRequest
		               since: since
		               until: until.

	mergeRequests := user contributedProjects collect: [ :project |
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

	^ mergeRequests "mergeRequests select: [ :mergeRequest |
		  mergeRequest author = user ]"
]

{ #category : #loading }
UserMetric >> loadMergeRequestsWithJiraIssueSince: since until: until [

	| email mergeRequests |
	mergeRequests := self
		                 loadMergeRequestsSince: since until:  until.

	email := self userEmail.

	jiraImporter importAllCurrentAndPastIssuesOf: email.

	GPJCConnector new
		gpModel: glhImporter glhModel;
		jiraModel: jiraImporter model;
		connect.

	^ mergeRequests select: [ :mergeRequest |
		  mergeRequest jiraIssue isNotNil ]
]

{ #category : #loading }
UserMetric >> loadUserCommitsSince: since until: until [

	| cacheSymbol allCommits |
	glhImporter withCommitDiffs: false.

	cacheSymbol := self
		               cacheSymbolFor: GLHCommit
		               since: since
		               until: until.

	"download commits unless project cache is not empty"
	allCommits := user contributedProjects collect: [ :project |
		              project repository
			              cacheAt: cacheSymbol
			              ifAbsentPut: [
				              | foundCommits |
				              foundCommits := glhImporter
					                              importCommitsOfProject: project
					                              since: since
					                              until: until.
				              foundCommits ] ].

	allCommits := allCommits flatten.
	allCommits do: [ :commit | glhImporter importCreatorOfCommit: commit ].
	glhImporter chainsCommitsFrom: allCommits.
	glhImporter withCommitDiffs: true.

	^ allCommits reject: [ :commit | commit commitCreator ~= user ]
]

{ #category : #loading }
UserMetric >> loadUserCompleteCommitsSince: since until: until [

	| commits |
	commits := self loadUserCommitsSince: since until: until.
	commits do: [ :commit | glhImporter completeImportedCommit: commit ].
	^ commits
]

{ #category : #loading }
UserMetric >> loadUserCompleteMergeRequestsSince: since until: until [

	| mergeRequests |
	mergeRequests := self loadUserMergeRequestsSince: since until: until.

	mergeRequests do: [ :mergeRequest |
		glhImporter importMergeResquestMerger: mergeRequest.
		glhImporter importMergeRequestCommits: mergeRequest ].

	^ mergeRequests
]

{ #category : #loading }
UserMetric >> loadUserCompleteMergeRequestsWithJiraIssueSince: since until: until [

	| email mergeRequests |
	mergeRequests := self loadUserCompleteMergeRequestsSince: since until: until.

	email := self userEmail.

	jiraImporter importAllCurrentAndPastIssuesOf: email.

	GPJCConnector new
		gpModel: glhImporter glhModel;
		jiraModel: jiraImporter model;
		connect.

	^ mergeRequests select: [ :mergeRequest |
		  mergeRequest jiraIssue isNotNil ]
]

{ #category : #loading }
UserMetric >> loadUserMergeRequestsSince: since until: until [

	| mergeRequests |
	mergeRequests := self loadMergeRequestsSince: since until: until.

	^ mergeRequests select: [ :mergeRequest | mergeRequest author = user ]
]

{ #category : #loading }
UserMetric >> loadUserMergeRequestsWithJiraIssueSince: since until: until [

	| email mergeRequests |
	mergeRequests := self loadUserMergeRequestsSince: since until: until.

	email := self userEmail.

	jiraImporter importAllCurrentAndPastIssuesOf: email.

	GPJCConnector new
		gpModel: glhImporter glhModel;
		jiraModel: jiraImporter model;
		connect.

	^ mergeRequests select: [ :mergeRequest |
		  mergeRequest jiraIssue isNotNil ]
]

{ #category : #accessing }
UserMetric >> name [

	^ self subclassResponsibility
]

{ #category : #accessing }
UserMetric >> user: anObject [

	user := anObject
]

{ #category : #email }
UserMetric >> userEmail [
	^ ('' join: {
			   user username.
			   emailDomain }) asLowercase
]
