"
I generate JSON strings shaped like real GitHub REST API responses (see GithubCommitsMock>>#get:inProject: and GithubModelImporterTest>>#testParseCommitsResult): single commits, pages of commits, pull requests, users and error bodies (404, 409, bad credentials). All my API is class-side.
"
Class {
	#name : #GithubJsonFixtures,
	#superclass : #Object,
	#category : #'GitHubHealth-Model-Importer-Tests'
}

{ #category : #errors }
GithubJsonFixtures class >> badCredentials [

	^ '{"message":"Bad credentials","documentation_url":"https://docs.github.com/rest","status":"401"}'
]

{ #category : #commits }
GithubJsonFixtures class >> commitDictionarySha: aSha date: anIsoString login: aLogin name: aGitName email: anEmail parents: parentShas [
	"Same shape as an element of GET /repos/{owner}/{repo}/commits (see GithubCommitsMock>>#get:inProject:)"

	| gitPerson githubUser |
	gitPerson := OrderedDictionary new
		             at: #name put: aGitName;
		             at: #email put: anEmail;
		             at: #date put: anIsoString;
		             yourself.
	githubUser := OrderedDictionary new
		              at: #login put: aLogin;
		              at: #id put: 1;
		              at: #type put: 'User';
		              at: #site_admin put: false;
		              yourself.
	^ OrderedDictionary new
		  at: #url
		  put:
			  'https://api.github.com/repos/itsGroup/myProject/commits/' , aSha;
		  at: #sha put: aSha;
		  at: #html_url
		  put: 'https://github.com/itsGroup/myProject/commit/' , aSha;
		  at: #commit put: (OrderedDictionary new
				   at: #author put: gitPerson;
				   at: #committer put: gitPerson copy;
				   at: #message put: 'Commit ' , aSha;
				   at: #tree put: (OrderedDictionary new
						    at: #sha put: aSha;
						    yourself);
				   at: #comment_count put: 0;
				   yourself);
		  at: #author put: githubUser;
		  at: #committer put: githubUser copy;
		  at: #parents put: (parentShas collect: [ :parentSha |
				   OrderedDictionary new
					   at: #url
					   put:
						   'https://api.github.com/repos/itsGroup/myProject/commits/'
						   , parentSha;
					   at: #sha put: parentSha;
					   yourself ]) asArray;
		  yourself
]

{ #category : #commits }
GithubJsonFixtures class >> commitSha: aSha [

	^ self
		  commitSha: aSha
		  date: '2025-11-15T10:00:00Z'
		  login: 'octocat'
		  name: 'Monalisa Octocat'
		  email: 'mona@github.com'
		  parents: #(  )
]

{ #category : #commits }
GithubJsonFixtures class >> commitSha: aSha date: anIsoString login: aLogin name: aGitName email: anEmail parents: parentShas [
	"JSON of one commit, as answered by GET /repos/{owner}/{repo}/commits/{ref}"

	^ NeoJSONWriter toString: (self
			   commitDictionarySha: aSha
			   date: anIsoString
			   login: aLogin
			   name: aGitName
			   email: anEmail
			   parents: parentShas)
]

{ #category : #commits }
GithubJsonFixtures class >> commitsPageOfSize: aSize prefix: aPrefix [
	"JSON array of aSize commits whose sha is aPrefix followed by a 4-digit index; use distinct prefixes to get distinct commits across pages"

	^ NeoJSONWriter toString: ((1 to: aSize) collect: [ :index |
				   self
					   commitDictionarySha:
					   aPrefix , (index printPaddedWith: $0 to: 4)
					   date: '2025-11-15T10:00:00Z'
					   login: 'octocat'
					   name: 'Monalisa Octocat'
					   email: 'mona@github.com'
					   parents: #(  ) ])
]

{ #category : #errors }
GithubJsonFixtures class >> notFound [

	^ '{"message":"Not Found","status":"404"}'
]

{ #category : #'pull requests' }
GithubJsonFixtures class >> pullRequestDictionaryNumber: aNumber createdAt: anIsoString mergedAt: aMergedIsoStringOrNil mergeCommitSha: aMergeShaOrNil headSha: aHeadSha [
	"Same shape as an element of GET /repos/{owner}/{repo}/pulls. The id differs from the number on purpose"

	^ OrderedDictionary new
		  at: #url
		  put: 'https://api.github.com/repos/itsGroup/myProject/pulls/'
			  , aNumber printString;
		  at: #id put: 1000000 + aNumber;
		  at: #number put: aNumber;
		  at: #state
		  put:
			  (aMergedIsoStringOrNil ifNil: [ 'open' ] ifNotNil: [ 'closed' ]);
		  at: #title put: 'PR ' , aNumber printString;
		  at: #user put: (OrderedDictionary new
				   at: #login put: 'octocat';
				   at: #id put: 1;
				   yourself);
		  at: #created_at put: anIsoString;
		  at: #updated_at put: anIsoString;
		  at: #closed_at put: aMergedIsoStringOrNil;
		  at: #merged_at put: aMergedIsoStringOrNil;
		  at: #merge_commit_sha put: aMergeShaOrNil;
		  at: #head put: (OrderedDictionary new
			   at: #ref put: 'feature-' , aNumber printString;
			   at: #sha put: aHeadSha;
			   yourself);
		  at: #base put: (OrderedDictionary new
			   at: #ref put: 'main';
			   at: #sha put: 'base' , aHeadSha;
			   yourself);
		  yourself
]

{ #category : #'pull requests' }
GithubJsonFixtures class >> pullRequestNumber: aNumber createdAt: anIsoString [
	"An unmerged pull request dictionary"

	^ self
		  pullRequestDictionaryNumber: aNumber
		  createdAt: anIsoString
		  mergedAt: nil
		  mergeCommitSha: nil
		  headSha: 'head' , aNumber printString
]

{ #category : #'pull requests' }
GithubJsonFixtures class >> pullRequestsPage: aCollectionOfDictionaries [

	^ NeoJSONWriter toString: aCollectionOfDictionaries asArray
]

{ #category : #errors }
GithubJsonFixtures class >> repositoryEmpty [
	"Body answered by GitHub for the commits of an empty repository (HTTP 409)"

	^ '{"message":"Git Repository is empty.","documentation_url":"https://docs.github.com/rest/commits/commits#list-commits","status":"409"}'
]

{ #category : #users }
GithubJsonFixtures class >> userLogin: aLogin id: anId name: aName [
	"Same shape as GET /users/{username} (see GithubUsersMock>>#getUserId:)"

	^ NeoJSONWriter toString: (OrderedDictionary new
			   at: #login put: aLogin;
			   at: #id put: anId;
			   at: #url put: 'https://api.github.com/users/' , aLogin;
			   at: #html_url put: 'https://github.com/' , aLogin;
			   at: #type put: 'User';
			   at: #site_admin put: false;
			   at: #name put: aName;
			   at: #email put: nil;
			   at: #created_at put: '2008-01-14T04:33:35Z';
			   at: #updated_at put: '2008-01-14T04:33:35Z';
			   yourself)
]
