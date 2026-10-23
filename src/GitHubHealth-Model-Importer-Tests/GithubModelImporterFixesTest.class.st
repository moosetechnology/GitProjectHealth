"
I test the fixes made to GithubModelImporter (F1 commits pagination keys, F2 commits since/until, F3 merge requests since/until + iid, F4 importCommit:ofProject:, F6 importUserByUsername:, F8 commit reader e-mails and git author name).

I use GithubApiRecordingMock: its commits / pullRequests / users resources are persistent recording doubles, so I can both script the JSON answered by the API (responder) and assert on the requests sent (calls). JSON bodies come from GithubJsonFixtures.
"
Class {
	#name : #GithubModelImporterFixesTest,
	#superclass : #TestCase,
	#instVars : [
		'importer',
		'model',
		'api',
		'defaultProject'
	],
	#category : #'GitHubHealth-Model-Importer-Tests'
}

{ #category : #helpers }
GithubModelImporterFixesTest >> commitJsonSha: aSha files: aCollectionOfFileDictionaries [
	"JSON of GET /repos/{owner}/{repo}/commits/{ref} carrying the given entries under the files key"

	| json |
	json := GithubJsonFixtures
		        commitDictionarySha: aSha
		        date: '2025-11-15T10:00:00Z'
		        login: 'octocat'
		        name: 'Monalisa Octocat'
		        email: 'mona@github.com'
		        parents: #(  ).
	json at: #files put: aCollectionOfFileDictionaries asArray.
	^ NeoJSONWriter toString: json
]

{ #category : #helpers }
GithubModelImporterFixesTest >> commitsParamsAt: anIndex [
	"Parameters Dictionary of the anIndex-th commits listing request"

	^ ((api commits callsTo: #getForRepo:ofOwner:withParms:) at: anIndex)
		  third
]

{ #category : #helpers }
GithubModelImporterFixesTest >> commitsResponderByPage: aDictionary [
	"Answer the commits JSON page registered for the requested #page, or an empty page"

	api commits responder: [ :arguments |
		aDictionary at: (arguments third at: #page) ifAbsent: [ '[]' ] ]
]

{ #category : #helpers }
GithubModelImporterFixesTest >> importDiffsOfCommitSha: aSha files: aCollectionOfFileDictionaries [
	"Run importDiffOfCommit: against a commit whose getCommit:ForRepo:ofOwner: answer carries the given files"

	| commit |
	api commits responder: [ :arguments |
			self
				commitJsonSha: arguments first
				files: aCollectionOfFileDictionaries ].
	commit := GLHCommit new
		          id: aSha;
		          short_id: (aSha first: 8);
		          repository: defaultProject repository;
		          yourself.
	importer importDiffOfCommit: commit.
	^ commit
]

{ #category : #helpers }
GithubModelImporterFixesTest >> octocatUsersResponder [
	"getUsername: and getUserId: answer JSON Strings, as the real GithubUsers does; unknown logins answer the 404 body"

	api users responder: [ :arguments :selector |
			(selector = #getUserId: or: [ arguments first = 'octocat' ])
				ifTrue: [
					GithubJsonFixtures
						userLogin: 'octocat'
						id: 1
						name: 'monalisa octocat' ]
				ifFalse: [ GithubJsonFixtures notFound ] ]
]

{ #category : #helpers }
GithubModelImporterFixesTest >> pullRequestNumber: aNumber createdAt: aDateAndTime [

	^ GithubJsonFixtures
		  pullRequestNumber: aNumber
		  createdAt: aDateAndTime asUTC printString
]

{ #category : #helpers }
GithubModelImporterFixesTest >> pullRequestsResponderByPage: aDictionary [

	api pullRequests responder: [ :arguments |
		aDictionary at: (arguments third at: #page) ifAbsent: [ '[]' ] ]
]

{ #category : #running }
GithubModelImporterFixesTest >> setUp [

	super setUp.
	api := GithubApiRecordingMock new.
	importer := GithubModelImporter new.
	importer repoApi: api.
	"diff import would send a second getCommit:ForRepo:ofOwner: per commit; keep it out of these focused tests"
	importer withCommitDiffs: false.
	model := GLHModel new.
	importer glhModel: model.
	defaultProject := GLHProject new
		                  name: 'myProject';
		                  group: (GLHGroup new name: 'itsGroup');
		                  repository: GLHRepository new;
		                  yourself
]

{ #category : #helpers }
GithubModelImporterFixesTest >> since [
	"Lower bound of the observation window: 2025-10-01T00:00:00Z"

	^ self utcYear: 2025 month: 10 day: 1
]

{ #category : #'tests - F1' }
GithubModelImporterFixesTest >> testF1ImportCommitsOfProjectUsesSinceAndPerPageOnEveryPage [
	"Page 1 is full (100 commits) so a second page is requested; page 2 (5 commits) ends the loop.
	The second request must use the fixed keys #since / #per_page, not the former typos #sine / #perPage"

	| secondPageParams |
	self commitsResponderByPage: {
			(1 -> (GithubJsonFixtures commitsPageOfSize: 100 prefix: 'a')).
			(2 -> (GithubJsonFixtures commitsPageOfSize: 5 prefix: 'b')) }
			asDictionary.

	importer importCommitsOfProject: defaultProject.

	self
		assert: (api commits callsTo: #getForRepo:ofOwner:withParms:) size
		equals: 2.
	secondPageParams := self commitsParamsAt: 2.
	self assert: (secondPageParams includesKey: #since).
	self deny: (secondPageParams includesKey: #sine).
	self deny: (secondPageParams includesKey: #perPage).
	self assert: (secondPageParams at: #per_page) equals: 100.
	self assert: (secondPageParams at: #page) equals: 2.
	self assert: ((self commitsParamsAt: 1) includesKey: #since).
	self assert: ((self commitsParamsAt: 1) at: #per_page) equals: 100.
	self assert: (model allWithType: GLHCommit) size equals: 105.
	self assert: defaultProject repository commits size equals: 105
]

{ #category : #'tests - F2' }
GithubModelImporterFixesTest >> testF2EmptyRepositoryAnswersNoCommit [
	"GitHub answers HTTP 409 on the commits of an empty repository"

	| result |
	api commits responder: [ GithubJsonFixtures repositoryEmpty ].

	result := importer
		          importCommitsOfProject: defaultProject
		          since: self since
		          until: self until.

	self assertEmpty: result.
	self
		assert: (api commits callsTo: #getForRepo:ofOwner:withParms:) size
		equals: 1.
	self assertEmpty: (model allWithType: GLHCommit)
]

{ #category : #'tests - F2' }
GithubModelImporterFixesTest >> testF2NilBoundsAreOmitted [

	| params |
	importer importCommitsOfProject: defaultProject since: nil until: nil.

	params := self commitsParamsAt: 1.
	self deny: (params includesKey: #since).
	self deny: (params includesKey: #until).
	self assert: (params at: #per_page) equals: 100.
	self assert: (params at: #page) equals: 1
]

{ #category : #'tests - F2' }
GithubModelImporterFixesTest >> testF2PaginatesUntilAPageIsNotFull [
	"100 / 100 / 0: the third (empty) page must be requested, then the loop stops"

	| result |
	self commitsResponderByPage: {
			(1 -> (GithubJsonFixtures commitsPageOfSize: 100 prefix: 'a')).
			(2 -> (GithubJsonFixtures commitsPageOfSize: 100 prefix: 'b')).
			(3 -> '[]') } asDictionary.

	result := importer
		          importCommitsOfProject: defaultProject
		          since: self since
		          until: self until.

	self
		assert: (api commits callsTo: #getForRepo:ofOwner:withParms:) size
		equals: 3.
	self
		assert: ((1 to: 3) collect: [ :index |
				 (self commitsParamsAt: index) at: #page ]) asArray
		equals: #( 1 2 3 ).
	self assert: result size equals: 200.
	self assert: (model allWithType: GLHCommit) size equals: 200
]

{ #category : #'tests - F2' }
GithubModelImporterFixesTest >> testF2SinceUntilAreSentAsUTCStrings [

	importer
		importCommitsOfProject: defaultProject
		since: self since
		until: self until.

	self
		assert: (api commits callsTo: #getForRepo:ofOwner:withParms:) size
		equals: 1.
	self
		assert: ((self commitsParamsAt: 1) at: #since)
		equals: '2025-10-01T00:00:00Z'.
	self
		assert: ((self commitsParamsAt: 1) at: #until)
		equals: '2026-10-01T00:00:00Z'.
	self assert: ((self commitsParamsAt: 1) at: #per_page) equals: 100.
	self assert: ((self commitsParamsAt: 1) at: #page) equals: 1
]

{ #category : #'tests - F2' }
GithubModelImporterFixesTest >> testF2SinceUntilWithNonUTCOffsetAreConvertedToUTC [
	"2025-10-01T02:00:00+02:00 is 2025-10-01T00:00:00Z"

	| sincePlus2 untilPlus2 |
	sincePlus2 := DateAndTime
		              year: 2025
		              month: 10
		              day: 1
		              hour: 2
		              minute: 0
		              second: 0
		              offset: 2 hours.
	untilPlus2 := DateAndTime
		              year: 2026
		              month: 10
		              day: 1
		              hour: 2
		              minute: 0
		              second: 0
		              offset: 2 hours.

	importer
		importCommitsOfProject: defaultProject
		since: sincePlus2
		until: untilPlus2.

	self
		assert: ((self commitsParamsAt: 1) at: #since)
		equals: '2025-10-01T00:00:00Z'.
	self
		assert: ((self commitsParamsAt: 1) at: #until)
		equals: '2026-10-01T00:00:00Z'
]

{ #category : #'tests - F2' }
GithubModelImporterFixesTest >> testF2TwoSuccessiveImportsDoNotDuplicateCommits [

	self commitsResponderByPage:
		{ (1 -> (GithubJsonFixtures commitsPageOfSize: 5 prefix: 'a')) }
			asDictionary.

	importer
		importCommitsOfProject: defaultProject
		since: self since
		until: self until.
	importer
		importCommitsOfProject: defaultProject
		since: self since
		until: self until.

	self
		assert: (api commits callsTo: #getForRepo:ofOwner:withParms:) size
		equals: 2.
	self assert: (model allWithType: GLHCommit) size equals: 5.
	self assert: defaultProject repository commits size equals: 5
]

{ #category : #'tests - F3' }
GithubModelImporterFixesTest >> testF3IidIsThePullRequestNumber [
	"F3b: parseMergeRequestsResult: maps GitHub `number` to iid; `id` stays the global GitHub id"

	| mergeRequest |
	api pullRequests responder: [
			GithubJsonFixtures pullRequestsPage:
				{ (self pullRequestNumber: 42 createdAt: self since + 1 day) } ].

	mergeRequest := (importer
		                 importMergeRequestsOfProject: defaultProject
		                 since: self since
		                 until: self until) first.

	self assert: mergeRequest iid equals: 42.
	self assert: mergeRequest id equals: 1000042
]

{ #category : #'tests - F3' }
GithubModelImporterFixesTest >> testF3MixedImporterDelegatesToApiImporter [

	| mixed result |
	api pullRequests responder: [
			GithubJsonFixtures pullRequestsPage:
				{ (self pullRequestNumber: 42 createdAt: self since + 1 day) } ].
	mixed := GitModelMixedImporter new
		         apiImporter: importer;
		         yourself.

	self
		shouldnt: [
				result := mixed
					          importMergeRequestsOfProject: defaultProject
					          since: self since
					          until: self until ]
		raise: Error.

	self assert: api pullRequests calls size equals: 1.
	self assert: result size equals: 1.
	self assert: result first iid equals: 42
]

{ #category : #'tests - F3' }
GithubModelImporterFixesTest >> testF3NoPullRequestOutsideTheWindowInTheModel [

	| mergeRequests |
	self pullRequestsResponderByPage: self windowedPullRequestPages.

	importer
		importMergeRequestsOfProject: defaultProject
		since: self since
		until: self until.

	mergeRequests := model allWithType: GLHMergeRequest.
	self assert: mergeRequests size equals: 110.
	self assert: (mergeRequests allSatisfy: [ :mr |
			 mr created_at >= self since and: [ mr created_at < self until ] ]).
	self assert: defaultProject mergeRequests size equals: 110
]

{ #category : #'tests - F3' }
GithubModelImporterFixesTest >> testF3NonArrayAnswerSignalsAnError [
	"e.g. HTTP 401 answers an object, not an array of pulls"

	api pullRequests responder: [ GithubJsonFixtures badCredentials ].

	self
		should: [
				importer
					importMergeRequestsOfProject: defaultProject
					since: self since
					until: self until ]
		raise: Error.
	self assertEmpty: (model allWithType: GLHMergeRequest)
]

{ #category : #'tests - F3' }
GithubModelImporterFixesTest >> testF3SendsExactPullsParameters [

	| arguments params |
	importer
		importMergeRequestsOfProject: defaultProject
		since: self since
		until: self until.

	self assert: api pullRequests calls size equals: 1.
	arguments := (api pullRequests callsTo:
		              #getForRepo:ofOwner:withParms:) first.
	self assert: arguments first equals: 'myProject'.
	self assert: arguments second equals: 'itsGroup'.
	params := arguments third.
	self assert: (params at: #state) equals: 'all'.
	self assert: (params at: #per_page) equals: 100.
	self assert: (params at: #sort) equals: 'created'.
	self assert: (params at: #direction) equals: 'desc'.
	self assert: (params at: #page) equals: 1.
	self assert: params size equals: 5
]

{ #category : #'tests - F3' }
GithubModelImporterFixesTest >> testF3StopsOnThePageThatCrossesSince [
	"Page 2 ends before since, so page 3 must not be requested"

	| result |
	self pullRequestsResponderByPage: self windowedPullRequestPages.

	result := importer
		          importMergeRequestsOfProject: defaultProject
		          since: self since
		          until: self until.

	self assert: api pullRequests calls size equals: 2.
	self
		assert:
			((api pullRequests callsTo: #getForRepo:ofOwner:withParms:)
				 collect: [ :arguments | arguments third at: #page ]) asArray
		equals: #( 1 2 ).
	self assert: result size equals: 110
]

{ #category : #'tests - F3' }
GithubModelImporterFixesTest >> testF3WindowIncludesSinceAndExcludesUntil [
	"#890 is created exactly at since (inclusive bound), #1000 exactly at until (exclusive bound)"

	| iids |
	self pullRequestsResponderByPage: self windowedPullRequestPages.

	importer
		importMergeRequestsOfProject: defaultProject
		since: self since
		until: self until.

	iids := (model allWithType: GLHMergeRequest) collect: [ :mr | mr iid ].
	self assert: (iids includes: 890).
	self deny: (iids includes: 1000).
	self deny: (iids includes: 889).
	self assert: (iids includes: 999).
	self assert: (iids includes: 900)
]

{ #category : #'tests - F4' }
GithubModelImporterFixesTest >> testF4ImportCommitAlreadyInModelDoesNotCallTheApi [

	| existing |
	existing := GLHCommit new
		            id: 'abc1234567890abcdef1234567890abcdef12345';
		            yourself.
	model add: existing.

	self
		assert: (importer
				 importCommit: 'abc1234567890abcdef1234567890abcdef12345'
				 ofProject: defaultProject)
		identicalTo: existing.
	self assertEmpty: api commits calls
]

{ #category : #'tests - F4' }
GithubModelImporterFixesTest >> testF4ImportCommitCallsGetCommitForRepoOfOwner [

	| sha commit |
	sha := 'abc1234567890abcdef1234567890abcdef12345'.
	api commits responder: [ :arguments |
		GithubJsonFixtures commitSha: arguments first ].

	commit := importer importCommit: sha ofProject: defaultProject.

	self
		assert: api commits calls asArray
		equals: { (#getCommit:ForRepo:ofOwner: -> {
				 sha.
				 'myProject'.
				 'itsGroup' }) }.
	self assert: commit id equals: sha.
	self assert: ((model allWithType: GLHCommit) includes: commit).
	self assert: (defaultProject repository commits includes: commit)
]

{ #category : #'tests - F4' }
GithubModelImporterFixesTest >> testF4ImportCommitOnNotFoundAnswersNilWithoutError [
	"A 404 body is parsed into a GLHCommit without id: the importer must answer nil and add nothing"

	| commit |
	api commits responder: [ GithubJsonFixtures notFound ].

	self
		shouldnt: [
			commit := importer
				          importCommit: 'deadbeef'
				          ofProject: defaultProject ]
		raise: Error.

	self assert: commit isNil.
	self assert: api commits calls size equals: 1.
	self assertEmpty: (model allWithType: GLHCommit).
	self assertEmpty: defaultProject repository commits
]

{ #category : #'tests - F4' }
GithubModelImporterFixesTest >> testF4ImportCommitWithNilShaAnswersNilWithoutCallingTheApi [

	self assert:
		(importer importCommit: nil ofProject: defaultProject) isNil.
	self assertEmpty: api commits calls
]

{ #category : #'tests - F4' }
GithubModelImporterFixesTest >> testF4ImportMergeRequestMergeCommitsWithNilSquashSha [
	"GitHub pulls never carry squash_commit_sha: the nil guard must skip it without any API call"

	| mergeRequest found |
	mergeRequest := GLHMergeRequest new
		                iid: 7;
		                sha: 'head0000000000000000000000000000000000007';
		                merge_commit_sha:
			                'merge000000000000000000000000000000000007';
		                project: defaultProject;
		                yourself.
	self assert: mergeRequest squash_commit_sha isNil.
	api commits responder: [ :arguments |
		GithubJsonFixtures commitSha: arguments first ].

	self
		shouldnt: [
		found := importer importMergeRequestMergeCommits: mergeRequest ]
		raise: Error.

	self assert: found size equals: 2.
	self assert: mergeRequest squashCommit isNil.
	self
		assert: mergeRequest mergeRequestCommit id
		equals: 'head0000000000000000000000000000000000007'.
	self
		assert: mergeRequest mergedCommit id
		equals: 'merge000000000000000000000000000000000007'.
	self
		assert:
			((api commits callsTo: #getCommit:ForRepo:ofOwner:) collect: [
				 :arguments | arguments first ]) asArray
		equals: #( 'head0000000000000000000000000000000000007'
			   'merge000000000000000000000000000000000007' )
]

{ #category : #'tests - F6' }
GithubModelImporterFixesTest >> testF6ImportCreatorOfCommitSetsCommitCreator [
	"author_name holds the GitHub login (see F8), which is the key used to find the creator"

	| commit creator |
	self octocatUsersResponder.
	commit := GLHCommit new
		          id: 'abc';
		          author_name: 'octocat';
		          yourself.

	creator := importer importCreatorOfCommit: commit.

	self assert: commit commitCreator identicalTo: creator.
	self assert: creator id equals: 1
]

{ #category : #'tests - F6' }
GithubModelImporterFixesTest >> testF6ImportUserByUsernameFakesUserOnNotFound [
	"A 404 String answer must not crash and must produce a placeholder user named after the login"

	| user |
	self octocatUsersResponder.

	self
		shouldnt: [ user := importer importUserByUsername: 'ghost' ]
		raise: Error.

	self assert: user class equals: GLHUser.
	self assert: user username equals: 'ghost'.
	self assertEmpty: (api users callsTo: #getUserId:).
	self assert: ((model allWithType: GLHUser) includes: user)
]

{ #category : #'tests - F6' }
GithubModelImporterFixesTest >> testF6ImportUserByUsernameParsesStringAnswer [

	| user |
	self octocatUsersResponder.

	user := importer importUserByUsername: 'octocat'.

	self assert: user class equals: GLHUser.
	self assert: user id equals: 1.
	self
		assert: (api users callsTo: #getUsername:) asArray
		equals: { { 'octocat' } }.
	self assert: ((model allWithType: GLHUser) includes: user)
]

{ #category : #'tests - F6' }
GithubModelImporterFixesTest >> testF6ImportUserByUsernameReadsIdFromAnArrayAnswer [

	| user |
	api users responder: [ :arguments :selector |
			selector = #getUsername:
				ifTrue: [
						'[' , (GithubJsonFixtures
							 userLogin: 'octocat'
							 id: 1
							 name: 'monalisa octocat') , ']' ]
				ifFalse: [
					GithubJsonFixtures
						userLogin: 'octocat'
						id: 1
						name: 'monalisa octocat' ] ].

	user := importer importUserByUsername: 'octocat'.

	self assert: user class equals: GLHUser.
	self assert: user id equals: 1.
	self
		assert: (api users callsTo: #getUserId:) asArray
		equals: { { 1 } }
]

{ #category : #'tests - F6' }
GithubModelImporterFixesTest >> testF6SecondImportOfSameLoginDoesNotCallTheApi [

	| first callsAfterFirstImport second |
	self octocatUsersResponder.
	first := importer importUserByUsername: 'octocat'.
	callsAfterFirstImport := api users calls size.

	second := importer importUserByUsername: 'octocat'.

	self assert: callsAfterFirstImport > 0.
	self assert: api users calls size equals: callsAfterFirstImport.
	self assert: second identicalTo: first
]

{ #category : #'tests - F8' }
GithubModelImporterFixesTest >> testF8CommitReaderKeepsEmailsAndGitAuthorName [
	"Author and committer get distinct e-mails to detect a swapped mapping.
	author_name must stay the GitHub login (used by importCreatorOfCommit:), the Git name goes to the cache"

	| json commit |
	json := GithubJsonFixtures
		        commitDictionarySha:
		        'f5ac58f4afe4632b0a26d1e968439c78962da289'
		        date: '2024-09-09T14:32:48Z'
		        login: 'ClotildeToullec'
		        name: 'Clotilde Toullec'
		        email: '39184695+ClotildeToullec@users.noreply.github.com'
		        parents: #( 'a6d1e968439c78962da289f5ac58f4afe4632b0a' ).
	(json at: #commit) at: #committer put: (OrderedDictionary new
			 at: #name put: 'GitHub';
			 at: #email put: 'noreply@github.com';
			 at: #date put: '2024-09-09T14:32:48Z';
			 yourself).

	commit := importer parseCommitResult: (NeoJSONWriter toString: json).

	self
		assert: commit id
		equals: 'f5ac58f4afe4632b0a26d1e968439c78962da289'.
	self
		assert: commit author_email
		equals: '39184695+ClotildeToullec@users.noreply.github.com'.
	self assert: commit committer_email equals: 'noreply@github.com'.
	self
		assert: (commit cacheAt: #gitAuthorName)
		equals: 'Clotilde Toullec'.
	self assert: commit author_name equals: 'ClotildeToullec'.
	self
		assert: commit parent_ids asArray
		equals: #( 'a6d1e968439c78962da289f5ac58f4afe4632b0a' )
]

{ #category : #'tests - F9' }
GithubModelImporterFixesTest >> testF9DiffPathsFromFilenameAndPreviousFilename [
	"new_path is filename; old_path is previous_filename when present (renames), filename otherwise.
	Both key orders must give the same paths"

	| modifiedFirst renamedFirst |
	modifiedFirst := OrderedDictionary new
		                 at: #filename put: 'src/Modified.java';
		                 at: #status put: 'modified';
		                 at: #patch put: '@@ -1 +1 @@\-a\+b' withCRs;
		                 yourself.
	renamedFirst := OrderedDictionary new
		                at: #filename put: 'src/NewName.java';
		                at: #status put: 'renamed';
		                at: #previous_filename put: 'src/OldName.java';
		                yourself.
	{
		{
			modifiedFirst.
			renamedFirst }.
		{
			(OrderedDictionary new
				 at: #patch put: '@@ -1 +1 @@\-a\+b' withCRs;
				 at: #status put: 'modified';
				 at: #filename put: 'src/Modified.java';
				 yourself).
			(OrderedDictionary new
				 at: #previous_filename put: 'src/OldName.java';
				 at: #status put: 'renamed';
				 at: #filename put: 'src/NewName.java';
				 yourself) } } do: [ :files |
			| commit modified renamed |
			commit := importer parseCommitResult: (self
					           commitJsonSha:
					           'abc1234567890abcdef1234567890abcdef12345'
					           files: files).
			self assert: commit diffs size equals: 2.
			modified := commit diffs first.
			renamed := commit diffs second.
			self assert: modified new_path equals: 'src/Modified.java'.
			self assert: modified old_path equals: 'src/Modified.java'.
			self
				assert: modified diffString
				equals: '@@ -1 +1 @@\-a\+b' withCRs.
			self assert: renamed new_path equals: 'src/NewName.java'.
			self assert: renamed old_path equals: 'src/OldName.java'.
			self assert: renamed diffString isNil ]
]

{ #category : #'tests - F9' }
GithubModelImporterFixesTest >> testF9ImportDiffKeepsFilesWithIdenticalPatch [
	"Two different files with the very same patch must give two diffs"

	| commit patch files |
	patch := '@@ -1,3 +1,3 @@\ package p;\-import a.A;\+import b.A;'
		         withCRs.
	files := #( 'src/Parameter.java' 'src/LocalVariable.java' ) collect: [
			         :path |
			         OrderedDictionary new
				         at: #filename put: path;
				         at: #status put: 'modified';
				         at: #patch put: patch;
				         yourself ].

	commit := self
		          importDiffsOfCommitSha:
		          '9cf66ecbf17206b60247d33bff749e1190be7e49'
		          files: files.

	self assert: commit diffs size equals: 2.
	self
		assert: (commit diffs collect: [ :diff | diff new_path ]) asSet
		equals: #( 'src/Parameter.java' 'src/LocalVariable.java' ) asSet.
	self assert:
		(commit diffs allSatisfy: [ :diff | diff diffString = patch ])
]

{ #category : #'tests - F9' }
GithubModelImporterFixesTest >> testF9ImportDiffKeepsRenamesWithoutPatch [
	"Pure renames have no patch: they must still give one diff per file"

	| commit files |
	files := (1 to: 3) collect: [ :index |
			         OrderedDictionary new
				         at: #filename
				         put: 'src/new/File' , index printString , '.java';
				         at: #status put: 'renamed';
				         at: #previous_filename
				         put: 'src/old/File' , index printString , '.java';
				         yourself ].

	commit := self
		          importDiffsOfCommitSha:
		          'de779fd4ad456948ece30540041e08583a0e624b'
		          files: files.

	self
		assert: api commits calls asArray
		equals: { (#getCommit:ForRepo:ofOwner:
			 -> { 'de779fd4ad456948ece30540041e08583a0e624b'.
				 'myProject'. 'itsGroup' }) }.
	self assert: commit diffs size equals: 3.
	self
		assert: (commit diffs collect: [ :diff | diff new_path ]) asSet
		equals:
			#( 'src/new/File1.java' 'src/new/File2.java' 'src/new/File3.java' )
				asSet.
	self
		assert: (commit diffs collect: [ :diff | diff old_path ]) asSet
		equals:
			#( 'src/old/File1.java' 'src/old/File2.java' 'src/old/File3.java' )
				asSet
]

{ #category : #helpers }
GithubModelImporterFixesTest >> until [
	"Upper (exclusive) bound of the observation window: 2026-10-01T00:00:00Z"

	^ self utcYear: 2026 month: 10 day: 1
]

{ #category : #helpers }
GithubModelImporterFixesTest >> utcYear: aYear month: aMonth day: aDay [

	^ DateAndTime
		  year: aYear
		  month: aMonth
		  day: aDay
		  hour: 0
		  minute: 0
		  second: 0
		  offset: Duration zero
]

{ #category : #helpers }
GithubModelImporterFixesTest >> windowedPullRequestPages [
	"Pull requests sorted by created_at desc, as asked with sort=created direction=desc.
	Page 1 (100 PRs): #1000 created exactly at until (excluded), #999..#901 inside the window.
	Page 2 (100 PRs): #900..#891 inside, #890 created exactly at since (included), #889..#801 before since: this page crosses since.
	Page 3 (100 PRs, all before since) must never be requested.
	Expected PRs in window: #890..#999 = 110 PRs"

	| page1 page2 page3 |
	page1 := (0 to: 99) collect: [ :k |
		         self
			         pullRequestNumber: 1000 - k
			         createdAt: self until - k hours ].
	page2 := (0 to: 99) collect: [ :k |
		         self
			         pullRequestNumber: 900 - k
			         createdAt: self since + (10 - k) hours ].
	page3 := (0 to: 99) collect: [ :k |
			         self
				         pullRequestNumber: 800 - k
				         createdAt: self since - (100 + k) hours ].
	^ {
		  (1 -> (GithubJsonFixtures pullRequestsPage: page1)).
		  (2 -> (GithubJsonFixtures pullRequestsPage: page2)).
		  (3 -> (GithubJsonFixtures pullRequestsPage: page3)) } asDictionary
]
